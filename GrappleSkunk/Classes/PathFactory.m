//
//  PathFactory.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "PathFactory.h"

static float const kRadiusControlMultiplier = 0.6;
static float const kFudgeDelta = 0.5;

@implementation PathFactory

+ (NSBezierPath*)createCircularPathOfRadius:(CGFloat)radius atPoint:(NSPoint)point
{
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    
    NSRect circleRect;
    
    circleRect.size.width = circleRect.size.height = 2.0 * radius;
    circleRect.origin.x = point.x - radius;
    circleRect.origin.y = point.y - radius;
    
    [thePath appendBezierPathWithOvalInRect: circleRect];
    
    return thePath;
}

+ (NSBezierPath*)createPointBoundedCurveBezierPath:(NSArray*)cgPointsArray
                             snipOverlappingPoints:(BOOL)snip
{
    //there must be at least 3 points to define a closed path
    if( !cgPointsArray || ([cgPointsArray count]<3))
    {
        return nil;
    }
    
    NSUInteger pointCount = [cgPointsArray count];
    
    NSBezierPath *bezierPath = [NSBezierPath new];
    
    CGPoint startPoint;
    
    CGPoint point1 = [cgPointsArray[0] CGPointValue];
    CGPoint point2 = [cgPointsArray[1] CGPointValue];
    
    float segmentlength = hypotf(point2.x -point1.x, point2.y-point1.y);
    float segmentRadius = 0.0;
    float segmult = 0.0;
    
    if( segmentlength < 1.0 )
    {
        segmentRadius = 0.0;
    }
    else
    {
        segmentRadius = segmentlength/2.0;
        segmult = 0.5;
    }
    
    startPoint = CGPointMake(point1.x + ((point2.x-point1.x)*segmult), point1.y + ((point2.y-point1.y)*segmult));
    
    [bezierPath moveToPoint:startPoint];
    
    for( UInt32 index = 1; index <= pointCount; index++ )
    {
        [PathFactory appendCurveToBezierPath:bezierPath firstPoint:[cgPointsArray[index-1] CGPointValue] secondPoint:[cgPointsArray[index%pointCount] CGPointValue] thirdPoint:[cgPointsArray[(index+1)%pointCount] CGPointValue] snipOverlappingPoints:snip];
    }
    
    [bezierPath closePath];
    
    return bezierPath;
}

+ (void)appendCurveToBezierPath:(NSBezierPath*)path
                     firstPoint:(CGPoint)point1
                    secondPoint:(CGPoint)point2
                     thirdPoint:(CGPoint)point3
          snipOverlappingPoints:(BOOL)snip
{
    //make sure the points are all unique
    if( (point1.x==point2.x && point1.y==point2.y) ||
       (point1.x==point3.x && point1.y==point3.y) ||
       (point2.x==point3.x && point2.y==point3.y) )
    {
        if( snip )
        {
            return;
        }
        
        if(point1.x==point2.x && point1.y==point2.y)
        {
            point2.x += kFudgeDelta;
            point2.y += kFudgeDelta;
        }
        
        if(point2.x==point3.x && point2.y==point3.y)
        {
            point3.x += kFudgeDelta;
            point3.y += kFudgeDelta;
        }
        
        if(point1.x==point3.x && point1.y==point3.y)
        {
            point3.x += kFudgeDelta;
            point3.y += kFudgeDelta;
        }
    }
    
    float segment1length = hypotf(point2.x -point1.x, point2.y-point1.y);
    float segment2length = hypotf(point3.x -point2.x, point3.y-point2.y);
    
    float seg1radius = 0.0;
    float seg2radius = 0.0;
    
    float seg1mult = 0.0;
    float seg2mult = 1.0 - 0.0;
    
    float control1mult = 0.0;
    float control2mult = 0.0;
    
    if( segment1length < 1.0 )
    {
        seg1radius = 0.0;
    }
    else
    {
        seg1radius = segment1length/2.0;
        seg1mult = 0.5;
        control1mult = (segment1length-seg1radius+(seg1radius*kRadiusControlMultiplier))/segment1length;
    }
    
    if( segment2length < 1.0 )
    {
        seg2radius = 0.0;
    }
    else
    {
        seg2radius = segment2length/2.0;
        seg2mult = 0.5;
        control2mult = (segment2length-seg2radius+(seg2radius*kRadiusControlMultiplier))/segment2length;
    }
    
    //XXX
    //TODO:if the angle between the two segments is too acute, move the curve back until
    //the required radius is less tight
    //XXX
    
    //CGPoint arcStartPoint = CGPointMake(point1.x + ((point2.x-point1.x)*seg1mult), point1.y + ((point2.y-point1.y)*seg1mult));
    CGPoint arcEndPoint = CGPointMake(point2.x + ((point3.x-point2.x)*seg2mult), point2.y + ((point3.y-point2.y)*seg2mult));
    
    CGPoint arcStartPointControl = CGPointMake(point1.x + ((point2.x-point1.x)*control1mult), point1.y + ((point2.y-point1.y)*control1mult));
    CGPoint arcEndPointControl = CGPointMake(point3.x - ((point3.x-point2.x)*control2mult), point3.y - ((point3.y-point2.y)*control2mult));
    
    [path curveToPoint:arcEndPoint controlPoint1:arcStartPointControl controlPoint2:arcEndPointControl];
}

@end

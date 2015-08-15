//
//  GraphMachine.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "GraphMachine.h"

static NSString * const kXValKey = @"kXValKey";
static NSString * const kYValKey = @"kYValKey";
static NSString * const kLabelKey = @"kLabelKey";
static NSString * const kAuxViewKey = @"kAuxViewKey";

static const CGFloat kGraphXAxisRatio = 0.9; //the x span takes up 80% of the frame width
static const CGFloat kGraphYAxisRatio = 0.9; //the y span takes up 80% of the frame height

typedef NSComparisonResult (^CompareBlock)(id, id);

@interface GraphMachine ()

@property (strong, nonatomic) NSMutableArray* dataPoints;
@property (copy, nonatomic) CompareBlock sortComparator;

@property (assign, nonatomic) CGFloat xInterval;
@property (assign, nonatomic) CGFloat xMinIntervalPoint;
@property (assign, nonatomic) CGFloat yInterval;
@property (assign, nonatomic) CGFloat yMinIntervalPoint;

@property (assign, nonatomic) CGFloat minDataPointX;
@property (assign, nonatomic) CGFloat maxDataPointX;
@property (assign, nonatomic) CGFloat minDataPointY;
@property (assign, nonatomic) CGFloat maxDataPointY;

@property (assign, nonatomic) CGFloat xSpan;
@property (assign, nonatomic) CGFloat ySpan;

@end

@implementation GraphMachine

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self clear];
        
        _sortComparator = ^(id obj1, id obj2) {
            NSNumber *x1 = (NSNumber*)((NSDictionary*)obj1)[kXValKey];
            NSNumber *x2 = (NSNumber*)((NSDictionary*)obj2)[kXValKey];
            return (NSComparisonResult)[x1 compare:x2];
        };
        
        
    }
    return self;
}

- (void)setXGraphInterval:(CGFloat)xIval
   minXGraphIntervalPoint:(CGFloat)xIvalPoint
        theYGraphInterval:(CGFloat)yIval
andMinYGraphIntervalPoint:(CGFloat)yIvalPoint
{
    self.xInterval = xIval;
    self.xMinIntervalPoint = xIvalPoint;
    self.yInterval = yIval;
    self.yMinIntervalPoint = yIvalPoint;
}

- (void)addDataPointWithXValue:(CGFloat)xValue
                        yValue:(CGFloat)yValue
                         label:(NSString*)label
                       auxView:(NSView*)auxView
{
    if( label == nil )
    {
        label = (NSString*)[NSNull null];
    }
    
    if( auxView == nil )
    {
        auxView = (NSView*)[NSNull null];
    }
    
    NSDictionary *newDataPoint = @{
                                       kXValKey : [NSNumber numberWithFloat:xValue],
                                       kYValKey : [NSNumber numberWithFloat:yValue],
                                       kLabelKey : label,
                                       kAuxViewKey : auxView
                                   };
    
    NSUInteger sortedIndex = [self.dataPoints indexOfObject:newDataPoint
                                        inSortedRange:(NSRange){0, [self.dataPoints count]}
                                              options:NSBinarySearchingInsertionIndex
                                      usingComparator:self.sortComparator];
    
    [self.dataPoints insertObject:newDataPoint atIndex:sortedIndex];
    
    [self updateExtremaForPointWithXValue:xValue yValue:yValue];
}

- (void)updateExtremaForPointWithXValue:(CGFloat)x
                                 yValue:(CGFloat)y
{
    if( x < self.minDataPointX )
    {
        self.minDataPointX = x;
    }
    
    if( x > self.maxDataPointX )
    {
        self.maxDataPointX = x;
    }
    
    if( y < self.minDataPointY )
    {
        self.minDataPointY = y;
    }
    
    if( y > self.maxDataPointY )
    {
        self.maxDataPointY = y;
    }

    self.xSpan = self.maxDataPointX - self.minDataPointX;
    self.ySpan = self.maxDataPointY - self.minDataPointY;
}

- (void)calculateExtrema
{
    for( id item in self.dataPoints )
    {
        NSDictionary *pointDictionary = (NSDictionary*)item;
        
        NSNumber *xNumber = (NSNumber*)(pointDictionary[kXValKey]);
        NSNumber *yNumber = (NSNumber*)(pointDictionary[kYValKey]);
        
        CGFloat x = [xNumber floatValue];
        CGFloat y = [yNumber floatValue];
        
        [self updateExtremaForPointWithXValue:x yValue:y];
    }
}

- (void)clear
{
    self.dataPoints = [NSMutableArray new];
    
    self.xInterval = 0.0;
    self.xMinIntervalPoint = 0.0;
    self.yInterval = 0.0;
    self.yMinIntervalPoint = 0.0;
    
    self.minDataPointX = HUGE_VALF;
    self.maxDataPointX = -HUGE_VALF;
    self.minDataPointY = HUGE_VALF;
    self.maxDataPointY = -HUGE_VALF;
    
    self.xSpan = 0.0;
    self.ySpan = 0.0;
}

- (NSBezierPath*)createGridPath:(CGRect)inFrame
{
    if( self.xSpan == 0.0 || self.ySpan == 0.0 ) return nil; //error condition
    
    CGFloat frameWidth = inFrame.size.width;
    CGFloat frameHeight = inFrame.size.height;
    
    CGFloat graphDisplayFrameWidth = frameWidth * kGraphXAxisRatio;
    CGFloat graphDisplayFrameHeight = frameHeight * kGraphYAxisRatio;
    
    //CGFloat graphDisplayMarginX = ((frameWidth - graphDisplayFrameWidth) / 2.0);
    //CGFloat graphDisplayMarginY = ((frameHeight - graphDisplayFrameHeight) / 2.0);
    
    //CGFloat graphDisplayFrameMinX = inFrame.origin.x + graphDisplayMarginX;
    //CGFloat graphDisplayFrameMinY = inFrame.origin.y + graphDisplayMarginY;
    
    //CGFloat graphDisplayFrameMaxX = inFrame.origin.x + frameWidth - graphDisplayMarginX;
    //CGFloat graphDisplayFrameMaxY = inFrame.origin.y + frameHeight - graphDisplayMarginY;
    
    CGFloat xRatioDisplayToData = graphDisplayFrameWidth / self.xSpan;
    CGFloat yRatioDisplayToData = graphDisplayFrameHeight / self.ySpan;
    
    CGFloat fullFrameWidthDataSpanX = self.xSpan / kGraphXAxisRatio;
    CGFloat fullFrameHeightDataSpanY = self.ySpan / kGraphYAxisRatio;
    
    CGFloat fullFrameWidthDataMarginX = ((fullFrameWidthDataSpanX - self.xSpan) / 2.0);
    CGFloat fullFrameHeightDataMarginY = ((fullFrameHeightDataSpanY - self.ySpan) / 2.0);
    
    CGFloat xGridDataValueMin = self.minDataPointX - fullFrameWidthDataMarginX;
    CGFloat xGridDataValueMax = self.maxDataPointX + fullFrameWidthDataMarginX;
    
    CGFloat yGridDataValueMin = self.minDataPointY - fullFrameHeightDataMarginY;
    CGFloat yGridDataValueMax = self.maxDataPointY + fullFrameHeightDataMarginY;
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    
    CGFloat xGridDataValue = self.xMinIntervalPoint;
    
    while( xGridDataValue <= xGridDataValueMax )
    {
        CGFloat frameX = inFrame.origin.x + ((xGridDataValue - xGridDataValueMin) * xRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( frameX, inFrame.origin.y)];
        [thePath lineToPoint: CGPointMake( frameX, inFrame.origin.y + frameHeight)];
        
        xGridDataValue += self.xInterval;
    }
    
    xGridDataValue = self.xMinIntervalPoint - self.xInterval;
    
    while( xGridDataValue >= xGridDataValueMin )
    {
        CGFloat frameX = inFrame.origin.x + ((xGridDataValue - xGridDataValueMin) * xRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( frameX, inFrame.origin.y)];
        [thePath lineToPoint: CGPointMake( frameX, inFrame.origin.y + frameHeight)];
        
        xGridDataValue -= self.xInterval;
    }
    
    CGFloat yGridDataValue = self.yMinIntervalPoint;
    
    while( yGridDataValue <= yGridDataValueMax )
    {
        CGFloat frameY = inFrame.origin.y + ((yGridDataValue - yGridDataValueMin) * yRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( inFrame.origin.x, frameY )];
        [thePath lineToPoint: CGPointMake( inFrame.origin.x + frameWidth, frameY )];
        
        yGridDataValue += self.yInterval;
    }
    
    yGridDataValue = self.yMinIntervalPoint - self.yInterval;
    
    while( yGridDataValue >= yGridDataValueMin )
    {
        CGFloat frameY = inFrame.origin.y + ((yGridDataValue - yGridDataValueMin) * yRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( inFrame.origin.x, frameY )];
        [thePath lineToPoint: CGPointMake( inFrame.origin.x + frameWidth, frameY )];
        
        yGridDataValue -= self.yInterval;
    }
    
    return thePath;
}

- (CGPoint)getMinimumConglomeratePoint
{
    return CGPointMake( self.minDataPointX, self.minDataPointY );
}

@end

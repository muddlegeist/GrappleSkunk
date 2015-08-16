//
//  PathFactory.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "PathFactory.h"

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

@end

//
//  MovingSpotEntity.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "MovingSpotEntity.h"
#import "NSBezierPath+QuartzPath.h"

static NSString * const kAnimationKey = @"shapeAnimation";

@implementation MovingSpotEntity

- (NSBezierPath*)createPathAtPoint:(NSPoint)spotPoint
{
    NSBezierPath * drawPath = [NSBezierPath bezierPath];
    [drawPath setLineWidth: 1];
    
    NSRect circleRect;
    
    circleRect.size.width = circleRect.size.height = 2.0 * self.radius;
    circleRect.origin.x = spotPoint.x - self.radius;
    circleRect.origin.y = spotPoint.y - self.radius;
    
    [drawPath appendBezierPathWithOvalInRect: circleRect];
    
    return drawPath;
}

- (void)animateToDestination
{
    NSBezierPath *originationPath = [self createPathAtPoint:self.viewPoint];
    NSBezierPath *destinationPath = [self createPathAtPoint:self.destinationPoint];
    
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    theAnimation.delegate = self;
    
    theAnimation.fromValue = (__bridge id) [originationPath quartzPath];
    theAnimation.toValue = (__bridge id) [destinationPath quartzPath];
    
    theAnimation.repeatCount = 0;
    
    theAnimation.duration = 2.0;
    theAnimation.autoreverses = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    
    [self.pathLayer addAnimation:theAnimation forKey:kAnimationKey];
    
    self.pathLayer.path = [destinationPath quartzPath];
    self.viewPoint = self.destinationPoint;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end

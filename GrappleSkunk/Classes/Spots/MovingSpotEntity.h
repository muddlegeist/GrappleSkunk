//
//  MovingSpotEntity.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

#import "SpotEntity.h"

@interface MovingSpotEntity : SpotEntity <NSAnimationDelegate>

@property (assign, nonatomic) NSPoint destinationPoint;

- (NSBezierPath*)createPathAtPoint:(NSPoint)spotPoint;

- (void)animateToDestination;

@end

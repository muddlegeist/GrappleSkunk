//
//  MovingSpotEntity.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "SpotEntity.h"

@interface MovingSpotEntity : SpotEntity

@property (assign, nonatomic) NSPoint currentPoint;
@property (assign, nonatomic) NSPoint velocityPoint;

@end

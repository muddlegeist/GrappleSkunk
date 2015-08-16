//
//  MGSpotEntity.h
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{ defaultState, overState, downState, disabledState } EntityStateType;

@interface MGSpotEntity : NSObject

@property (assign, nonatomic) EntityStateType entityState;
@property (assign, nonatomic) NSPoint viewPoint;
@property (assign, nonatomic) CGFloat radius;
@property (strong, nonatomic) CAShapeLayer *pathLayer;
@property (strong, nonatomic) NSDictionary* spotData;

- (id)initWithRadius: (CGFloat)r;
- (void)preparePathLayer;

-(BOOL) isHit:(NSPoint)pt;

- (NSBezierPath*)createPath;

@end

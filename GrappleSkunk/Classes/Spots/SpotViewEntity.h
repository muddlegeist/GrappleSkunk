//
//  SpotViewEntity.h
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum{ defaultState, overState, downState, disabledState } EntityStateType;

@interface SpotViewEntity : NSObject

@property (assign, nonatomic) EntityStateType entityState;
@property (assign, nonatomic) NSPoint viewPoint;
@property (assign, nonatomic) CGFloat radius;
@property (assign, nonatomic) int userData;

- (id)initWithRadius: (CGFloat)r;
- (void)draw;

-(BOOL) isHit:(NSPoint)pt;

@end

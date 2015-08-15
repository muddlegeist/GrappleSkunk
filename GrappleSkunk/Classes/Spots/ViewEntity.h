//
//  ViewEntity.h
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum{ defaultState, overState, downState, disabledState } EntityStateType;

@interface ViewEntity : NSObject

@property (assign, nonatomic) EntityStateType entityState;
@property (assign, nonatomic) NSPoint viewPoint;

-(void) draw;

@end

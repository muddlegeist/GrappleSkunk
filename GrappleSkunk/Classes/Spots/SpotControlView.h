//
//  SpotControlView.h
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpotViewEntity.h"

@interface SpotControlView : NSView

@property (strong, nonatomic) NSMutableArray* spots;
@property (strong, nonatomic) id targetID;

- (SpotViewEntity*)createAndAddSpot:(NSPoint)pt;
- (SpotViewEntity*)createAndAddSpot:(NSPoint)pt withRadius:(CGFloat)radius;
- (void)addSpot:(NSPoint)pt;
- (void)addSpot:(NSPoint)pt withRadius:(CGFloat)radius;
- (void)removeSpot:(SpotViewEntity*)victimSpot;

- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;
- (void)mouseDragged:(NSEvent *)theEvent;
- (void)mouseMoved:(NSEvent *)theEvent;

@end

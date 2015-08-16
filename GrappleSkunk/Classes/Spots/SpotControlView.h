//
//  SpotControlView.h
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SpotEntity.h"

@interface SpotControlView : NSView

@property (strong, nonatomic) NSMutableArray* spots;
@property (strong, nonatomic) id targetID;

- (void)addSpot:(NSPoint)pt
     withRadius:(CGFloat)radius
withDataDictionary:(NSDictionary*)spotDictionary;

- (void)addMovingSpotAtPoint:(NSPoint)originalPt
         forDestinationPoint:(NSPoint)destinationPt
                  withRadius:(CGFloat)radius
          withDataDictionary:(NSDictionary*)spotDictionary;

- (void)removeSpot:(SpotEntity*)victimSpot;
- (void)removeAllSpots;

- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;
- (void)mouseMoved:(NSEvent *)theEvent;

- (void)animateSpots;

- (NSArray*)getPointsArray;

@end

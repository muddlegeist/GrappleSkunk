//
//  MGGraphView.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GrappleSkunkConstants.h"


@interface MGGraphView : NSView

@property (strong, nonatomic) NSBezierPath *theGridPath;

- (void)addDataPoints:(NSArray*)dataPointsArray;
- (void)clearDataPoints;


@end

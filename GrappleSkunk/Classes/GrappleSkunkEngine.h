//
//  GrappleSkunkEngine.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GrappleSkunkEngine : NSObject

- (void)addDataFromProjectFile:(NSString*)projectFile;
- (void)addDataFromJSONString:(NSString*)jsonString;
- (void)addDataFromDemoDictionary:(NSDictionary*)dataDictionary;

- (void)setDefaultGridIntervals;

- (NSBezierPath*)getGridPathForFrame:(CGRect)inFrame;
- (NSArray*)getSortedArrayScaledToFrame:(CGRect)inFrame;
- (void)drawAxissesInView:(NSView*)view;

@end

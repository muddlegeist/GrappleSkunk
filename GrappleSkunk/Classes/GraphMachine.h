//
//  GraphMachine.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GraphMachine : NSObject

- (void)addDataPointWithXValue:(CGFloat)xValue
                        yValue:(CGFloat)yValue
                         label:(NSString*)label
                       auxView:(NSView*)auxView;

- (void)setXGraphInterval:(CGFloat)xIval
   minXGraphIntervalPoint:(CGFloat)xIvalPoint
        theYGraphInterval:(CGFloat)yIval
andMinYGraphIntervalPoint:(CGFloat)yIvalPoint;

- (void)clear;

- (NSBezierPath*)createGridPath:(CGRect)inFrame;

- (CGPoint)getMinimumConglomeratePoint;

@end

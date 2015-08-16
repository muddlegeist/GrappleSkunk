//
//  PathFactory.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PathFactory : NSObject

+ (NSBezierPath*)createCircularPathOfRadius:(CGFloat)radius atPoint:(NSPoint)point;

+ (NSBezierPath*)createPointBoundedCurveBezierPath:(NSArray*)cgPointsArray
                             snipOverlappingPoints:(BOOL)snip;

+ (void)appendCurveToBezierPath:(NSBezierPath*)path
                     firstPoint:(CGPoint)point1
                    secondPoint:(CGPoint)point2
                     thirdPoint:(CGPoint)point3
          snipOverlappingPoints:(BOOL)snip;

@end

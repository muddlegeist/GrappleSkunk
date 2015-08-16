//
//  MGGraphLineView.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/16/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MGGraphLineView : NSView

@property (strong, nonatomic) NSArray* theGraphPoints;

- (void)doAnimation;

@end

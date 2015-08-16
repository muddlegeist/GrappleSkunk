//
//  ValueFormatter.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ValueFormatter <NSObject>

- (NSString*)makeFormattedString:(CGFloat)value;

@end

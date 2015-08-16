//
//  DollarFormatter.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueFormatter.h"

@interface DollarFormatter : NSObject <ValueFormatter>

- (NSString*)makeFormattedString:(CGFloat)value;

@end


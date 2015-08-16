//
//  DollarFormatter.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "DollarFormatter.h"

@interface DollarFormatter ()

@property (strong, nonatomic) NSNumberFormatter* dollarFormatter;

@end

@implementation DollarFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dollarFormatter = [NSNumberFormatter new];

        [_dollarFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [_dollarFormatter setCurrencyCode:@"USD"];
    }
    return self;
}

- (NSString*)makeFormattedString:(CGFloat)value
{
    NSString* dollarString = [self.dollarFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
    
    return dollarString;
}

@end

//
//  MMDDFormatter.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "MMDDFormatter.h"

@interface MMDDFormatter ()

@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@end

@implementation MMDDFormatter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [NSDateFormatter new];
        
        [_dateFormatter setDateFormat:@"MM/DD"];
    }
    return self;
}

- (NSString*)makeFormattedString:(CGFloat)value
{
    NSDate* theDate = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)value];

    NSString *stringFromDate = [self.dateFormatter stringFromDate:theDate];
    
    return stringFromDate;
}

@end

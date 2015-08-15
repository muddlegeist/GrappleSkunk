//
//  GraphMachine.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "GraphMachine.h"

static NSString * const kXValKey = @"kXValKey";
static NSString * const kYValKey = @"kYValKey";
static NSString * const kLabelKey = @"kLabelKey";
static NSString * const kAuxViewKey = @"kAuxViewKey";

typedef NSComparisonResult (^CompareBlock)(id, id);

@interface GraphMachine ()

@property (strong, nonatomic) NSMutableArray* dataPoints;
@property (copy, nonatomic) CompareBlock sortComparator;

@end

@implementation GraphMachine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sortComparator = ^(id obj1, id obj2) {
            NSNumber *y1 = (NSNumber*)((NSDictionary*)obj1)[kYValKey];
            NSNumber *y2 = (NSNumber*)((NSDictionary*)obj2)[kYValKey];
            return (NSComparisonResult)[y1 compare:y2];
        };
    }
    return self;
}

- (void)addDataPointWithXValue:(CGFloat)xValue
                        yValue:(CGFloat)yValue
                         label:(NSString*)label
                       auxView:(NSView*)auxView
{
    if( label == nil )
    {
        label = (NSString*)[NSNull null];
    }
    
    if( auxView == nil )
    {
        auxView = (NSView*)[NSNull null];
    }
    
    NSDictionary *newDataPoint = @{
                                       kXValKey : [NSNumber numberWithFloat:xValue],
                                       kYValKey : [NSNumber numberWithFloat:yValue],
                                       kLabelKey : label,
                                       kAuxViewKey : auxView
                                   };
    
    NSUInteger sortedIndex = [self.dataPoints indexOfObject:newDataPoint
                                        inSortedRange:(NSRange){0, [self.dataPoints count]}
                                              options:NSBinarySearchingInsertionIndex
                                      usingComparator:self.sortComparator];
    
    [self.dataPoints insertObject:newDataPoint atIndex:sortedIndex];
}

@end

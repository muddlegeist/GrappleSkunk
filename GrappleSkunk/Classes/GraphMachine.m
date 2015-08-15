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

@property (assign, nonatomic) CGFloat xInterval;
@property (assign, nonatomic) CGFloat xMinIntervalPoint;
@property (assign, nonatomic) CGFloat yInterval;
@property (assign, nonatomic) CGFloat yMinIntervalPoint;

@property (assign, nonatomic) CGFloat minDataPointX;
@property (assign, nonatomic) CGFloat maxDataPointX;
@property (assign, nonatomic) CGFloat minDataPointY;
@property (assign, nonatomic) CGFloat maxDataPointY;

@property (assign, nonatomic) CGFloat xSpan;
@property (assign, nonatomic) CGFloat ySpan;

@end

@implementation GraphMachine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataPoints = [NSMutableArray new];
        _sortComparator = ^(id obj1, id obj2) {
            NSNumber *x1 = (NSNumber*)((NSDictionary*)obj1)[kXValKey];
            NSNumber *x2 = (NSNumber*)((NSDictionary*)obj2)[kXValKey];
            return (NSComparisonResult)[x1 compare:x2];
        };
        
        _xInterval = 0.0;
        _xMinIntervalPoint = 0.0;
        _yInterval = 0.0;
        _yMinIntervalPoint = 0.0;
        
        _minDataPointX = HUGE_VALF;
        _maxDataPointX = -HUGE_VALF;
        _minDataPointY = HUGE_VALF;
        _maxDataPointY = -HUGE_VALF;
        
        _xSpan = 0.0;
        _ySpan = 0.0;
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

- (void)setXGraphInterval:(CGFloat)xIval
    minXGraphIntervalPoint:(CGFloat)xIvalPoint
        theYGraphInterval:(CGFloat)yIval
    andMinYGraphIntervalPoint:(CGFloat)yIvalPoint
{
    self.xInterval = xIval;
    self.xMinIntervalPoint = xIvalPoint;
    self.yInterval = yIval;
    self.yMinIntervalPoint = yIvalPoint;
}

- (void)calculateExtrema
{
    for( id item in self.dataPoints )
    {
        NSDictionary *pointDictionary = (NSDictionary*)item;
        
        NSNumber *xNumber = (NSNumber*)(pointDictionary[kXValKey]);
        NSNumber *yNumber = (NSNumber*)(pointDictionary[kYValKey]);
        
        CGFloat x = [xNumber floatValue];
        CGFloat y = [yNumber floatValue];
        
        if( x > self.minDataPointX )
        {
            self.minDataPointX = x;
        }
        
        if( x > self.maxDataPointX )
        {
            self.maxDataPointX = x;
        }
        
        if( y > self.minDataPointY )
        {
            self.minDataPointY = y;
        }
        
        if( y > self.maxDataPointY )
        {
            self.maxDataPointY = y;
        }
    }
    
    self.xSpan = self.maxDataPointX - self.minDataPointX;
    self.ySpan = self.maxDataPointY - self.minDataPointY;
}

- (void)clear
{
    self.dataPoints = [NSMutableArray new];
}

- (NSBezierPath*)createGridBezier:(CGRect)inFrame
{
    
}

@end

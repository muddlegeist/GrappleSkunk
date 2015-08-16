//
//  GraphMachine.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "GraphMachine.h"
#import "DataPointDictionaryKeys.h"

static const CGFloat kGraphXAxisRatio = 0.9; //the x span takes up 90% of the frame width
static const CGFloat kGraphYAxisRatio = 0.7; //the y span takes up 70% of the frame height

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

@property (assign, nonatomic) BOOL scratchDataCalculated;

//scratch paper properties - for simplifying the math in the methods
@property (assign, nonatomic) CGFloat xSpan;
@property (assign, nonatomic) CGFloat ySpan;

@property (assign, nonatomic) CGFloat frameWidth;
@property (assign, nonatomic) CGFloat frameHeight;

@property (assign, nonatomic) CGFloat graphDisplayFrameWidth;
@property (assign, nonatomic) CGFloat graphDisplayFrameHeight;

@property (assign, nonatomic) CGFloat graphDisplayMarginX;
@property (assign, nonatomic) CGFloat graphDisplayMarginY;

@property (assign, nonatomic) CGFloat graphDisplayFrameMinX;
@property (assign, nonatomic) CGFloat graphDisplayFrameMinY;

@property (assign, nonatomic) CGFloat graphDisplayFrameMaxX;
@property (assign, nonatomic) CGFloat graphDisplayFrameMaxY;

@property (assign, nonatomic) CGFloat xRatioDisplayToData;
@property (assign, nonatomic) CGFloat yRatioDisplayToData;

@property (assign, nonatomic) CGFloat fullFrameWidthDataSpanX;
@property (assign, nonatomic) CGFloat fullFrameHeightDataSpanY;

@property (assign, nonatomic) CGFloat fullFrameWidthDataMarginX;
@property (assign, nonatomic) CGFloat fullFrameHeightDataMarginY;

@property (assign, nonatomic) CGFloat xGridDataValueMin;
@property (assign, nonatomic) CGFloat xGridDataValueMax;

@property (assign, nonatomic) CGFloat yGridDataValueMin;
@property (assign, nonatomic) CGFloat yGridDataValueMax;

@end

@implementation GraphMachine

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self clear];
        
        _sortComparator = ^(id obj1, id obj2) {
            NSNumber *x1 = (NSNumber*)((NSDictionary*)obj1)[kXValKey];
            NSNumber *x2 = (NSNumber*)((NSDictionary*)obj2)[kXValKey];
            return (NSComparisonResult)[x1 compare:x2];
        };
        
        
    }
    return self;
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
    
    [self updateExtremaForPointWithXValue:xValue yValue:yValue];
}

- (void)updateExtremaForPointWithXValue:(CGFloat)x
                                 yValue:(CGFloat)y
{
    if( x < self.minDataPointX )
    {
        self.minDataPointX = x;
    }
    
    if( x > self.maxDataPointX )
    {
        self.maxDataPointX = x;
    }
    
    if( y < self.minDataPointY )
    {
        self.minDataPointY = y;
    }
    
    if( y > self.maxDataPointY )
    {
        self.maxDataPointY = y;
    }

    self.xSpan = self.maxDataPointX - self.minDataPointX;
    self.ySpan = self.maxDataPointY - self.minDataPointY;
    
    [self doScratchCalculations];
}

- (void)doScratchCalculations
{
    if( self.xSpan == 0.0 || self.ySpan == 0.0 ) return; //error condition
    
    //precalculate some useful stuff
    if( !CGRectEqualToRect(self.calculationFrame, CGRectZero) )
    {
        self.frameWidth = self.calculationFrame.size.width;
        self.frameHeight = self.calculationFrame.size.height;
        
        self.graphDisplayFrameWidth = self.frameWidth * kGraphXAxisRatio;
        self.graphDisplayFrameHeight = self.frameHeight * kGraphYAxisRatio;
        
        self.graphDisplayMarginX = ((self.frameWidth - self.graphDisplayFrameWidth) / 2.0);
        self.graphDisplayMarginY = ((self.frameHeight - self.graphDisplayFrameHeight) / 2.0);
        
        self.graphDisplayFrameMinX = self.calculationFrame.origin.x + self.graphDisplayMarginX;
        self.graphDisplayFrameMinY = self.calculationFrame.origin.y + self.graphDisplayMarginY;
        
        self.graphDisplayFrameMaxX = self.calculationFrame.origin.x + self.frameWidth - self.graphDisplayMarginX;
        self.graphDisplayFrameMaxY = self.calculationFrame.origin.y + self.frameHeight - self.graphDisplayMarginY;
        
        self.xRatioDisplayToData = self.graphDisplayFrameWidth / self.xSpan;
        self.yRatioDisplayToData = self.graphDisplayFrameHeight / self.ySpan;
        
        self.fullFrameWidthDataSpanX = self.xSpan / kGraphXAxisRatio;
        self.fullFrameHeightDataSpanY = self.ySpan / kGraphYAxisRatio;
        
        self.fullFrameWidthDataMarginX = ((self.fullFrameWidthDataSpanX - self.xSpan) / 2.0);
        self.fullFrameHeightDataMarginY = ((self.fullFrameHeightDataSpanY - self.ySpan) / 2.0);
        
        self.xGridDataValueMin = self.minDataPointX - self.fullFrameWidthDataMarginX;
        self.xGridDataValueMax = self.maxDataPointX + self.fullFrameWidthDataMarginX;
        
        self.yGridDataValueMin = self.minDataPointY - self.fullFrameHeightDataMarginY;
        self.yGridDataValueMax = self.maxDataPointY + self.fullFrameHeightDataMarginY;
        
        self.scratchDataCalculated = YES;
    }
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
        
        [self updateExtremaForPointWithXValue:x yValue:y];
    }
}

- (void)clear
{
    _dataPoints = [NSMutableArray new];
    
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
    
    _calculationFrame = CGRectZero;
    
    _frameWidth = 0.0;
    _frameHeight = 0.0;
    _graphDisplayFrameWidth = 0.0;
    _graphDisplayFrameHeight = 0.0;
    _graphDisplayMarginX = 0.0;
    _graphDisplayMarginY = 0.0;
    _graphDisplayFrameMinX = 0.0;
    _graphDisplayFrameMinY = 0.0;
    _graphDisplayFrameMaxX = 0.0;
    _graphDisplayFrameMaxY = 0.0;
    _xRatioDisplayToData = 0.0;
    _yRatioDisplayToData = 0.0;
    _fullFrameWidthDataSpanX = 0.0;
    _fullFrameHeightDataSpanY = 0.0;
    _fullFrameWidthDataMarginX = 0.0;
    _fullFrameHeightDataMarginY = 0.0;
    _xGridDataValueMin = 0.0;
    _xGridDataValueMax = 0.0;
    _yGridDataValueMin = 0.0;
    _yGridDataValueMax = 0.0;
    
    _scratchDataCalculated = NO;
}

- (void)setCalculationFrame:(CGRect)calculationFrame
{
    _calculationFrame = calculationFrame;
    
    [self doScratchCalculations];
}

- (NSBezierPath*)createGridPathForFrame
{
    if( CGRectEqualToRect(self.calculationFrame, CGRectZero) )
    {
        return nil;
    }
    
    if( !self.scratchDataCalculated )
    {
        [self doScratchCalculations];
    }
    
    NSBezierPath* thePath = [NSBezierPath bezierPath];
    
    CGFloat xGridDataValue = self.xMinIntervalPoint;
    
    while( xGridDataValue <= self.xGridDataValueMax )
    {
        CGFloat frameX = self.calculationFrame.origin.x + ((xGridDataValue - self.xGridDataValueMin) * self.xRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( frameX, self.calculationFrame.origin.y)];
        [thePath lineToPoint: CGPointMake( frameX, self.calculationFrame.origin.y + self.frameHeight)];
        
        xGridDataValue += self.xInterval;
    }
    
    xGridDataValue = self.xMinIntervalPoint - self.xInterval;
    
    while( xGridDataValue >= self.xGridDataValueMin )
    {
        CGFloat frameX = self.calculationFrame.origin.x + ((xGridDataValue - self.xGridDataValueMin) * self.xRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( frameX, self.calculationFrame.origin.y)];
        [thePath lineToPoint: CGPointMake( frameX, self.calculationFrame.origin.y + self.frameHeight)];
        
        xGridDataValue -= self.xInterval;
    }
    
    CGFloat yGridDataValue = self.yMinIntervalPoint;
    
    while( yGridDataValue <= self.yGridDataValueMax )
    {
        CGFloat frameY = self.calculationFrame.origin.y + ((yGridDataValue - self.yGridDataValueMin) * self.yRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( self.calculationFrame.origin.x, frameY )];
        [thePath lineToPoint: CGPointMake( self.calculationFrame.origin.x + self.frameWidth, frameY )];
        
        yGridDataValue += self.yInterval;
    }
    
    yGridDataValue = self.yMinIntervalPoint - self.yInterval;
    
    while( yGridDataValue >= self.yGridDataValueMin )
    {
        CGFloat frameY = self.calculationFrame.origin.y + ((yGridDataValue - self.yGridDataValueMin) * self.yRatioDisplayToData);
        [thePath moveToPoint: CGPointMake( self.calculationFrame.origin.x, frameY )];
        [thePath lineToPoint: CGPointMake( self.calculationFrame.origin.x + self.frameWidth, frameY )];
        
        yGridDataValue -= self.yInterval;
    }
    
    return thePath;
}

- (NSArray*)getSortedArrayScaledToFrame
{
    if( CGRectEqualToRect(self.calculationFrame, CGRectZero) )
    {
        return nil;
    }
    
    if( !self.scratchDataCalculated )
    {
        [self doScratchCalculations];
    }
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    for( id item in self.dataPoints )
    {
        NSDictionary *itemDict = (NSDictionary*)item;
        
        CGFloat xDataPoint = ((NSNumber*)((NSDictionary*)itemDict)[kXValKey]).floatValue;
        CGFloat yDataPoint = ((NSNumber*)((NSDictionary*)itemDict)[kYValKey]).floatValue;
        
        CGFloat xFramePoint = self.graphDisplayMarginX + ((xDataPoint - self.minDataPointX) * self.xRatioDisplayToData);
        CGFloat yFramePoint = self.graphDisplayMarginY + ((yDataPoint - self.minDataPointY) * self.yRatioDisplayToData);
        
        NSMutableDictionary *spotDictionary = [itemDict mutableCopy];
        spotDictionary[kXCoordinateKey] = [NSNumber numberWithFloat:xFramePoint];
        spotDictionary[kYCoordinateKey] = [NSNumber numberWithFloat:yFramePoint];
        
        [mutableArray addObject:spotDictionary];
    }

    return [NSArray arrayWithArray:mutableArray];
}

- (CGPoint)getMinimumConglomeratePoint
{
    return CGPointMake( self.minDataPointX, self.minDataPointY );
}

- (NSArray*)getSortedArray
{
    return [NSArray arrayWithArray:self.dataPoints];
}

@end

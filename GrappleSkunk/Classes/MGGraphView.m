//
//  MGGraphView.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "MGGraphView.h"
#import "SpotControlView.h"
#import "AppDelegate.h"
#import "DataPointDictionaryKeys.h"

@interface MGGraphView ()

//@property (strong, nonatomic) NSView *gridView;
//@property (strong, nonatomic) NSView *lineView;
@property (strong, nonatomic) SpotControlView *spotView;

@end

@implementation MGGraphView

- (void)commonInit_MGGraphView
{
    //_gridView = [[NSView alloc] initWithFrame:self.bounds];
    //_lineView = [[NSView alloc] initWithFrame:self.bounds];
    _spotView = [[SpotControlView alloc] initWithFrame:self.bounds];
    
    //[self addSubview:self.gridView];
    //[self addSubview:self.lineView];
    [self addSubview:self.spotView];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit_MGGraphView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit_MGGraphView];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    if ([self inLiveResize])
    {
        self.spotView.frame = self.bounds;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kRequestGraphRecalcNotification
         object:self];
    }
    
    if( self.theGridPath != nil )
    {
        [self.theGridPath setLineWidth:1.0];
        [[NSColor blackColor] set];
        [self.theGridPath stroke];
    }
}

#pragma mark - Graph Drawing

- (void)setTheGridPath:(NSBezierPath *)theGridPath
{
    _theGridPath = theGridPath;
    
    self.needsDisplay = YES;
}

- (void)addDataPoints:(NSArray*)dataPointsArray
{
    for( id item in dataPointsArray )
    {
        NSDictionary *itemDict = (NSDictionary*)item;
        
        CGFloat xFramePoint = ((NSNumber*)((NSDictionary*)itemDict)[kXCoordinateKey]).floatValue;
        CGFloat yFramePoint = ((NSNumber*)((NSDictionary*)itemDict)[kYCoordinateKey]).floatValue;
        
        NSPoint spotPoint = CGPointMake(xFramePoint, yFramePoint);
        [self.spotView addSpot:spotPoint  withDataDictionary:itemDict];
    }
}

- (void)clearDataPoints
{
    [self.spotView removeAllSpots];
}

@end

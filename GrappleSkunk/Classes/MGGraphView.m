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
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleWindowDecodedNotification)
     name:kMainWindowDecodedNotification
     object:nil];
    
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
         postNotificationName:kRedrawExistingDataNotification
         object:self];
    }
    
    if( self.theGridPath != nil )
    {
        [self.theGridPath setLineWidth:1.0];
        [[NSColor lightGrayColor] set];
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
    BOOL addPointsForRedraw = [AppDelegate sharedAppDelegate].inRedraw;
    
    for( id item in dataPointsArray )
    {
        NSDictionary *itemDict = (NSDictionary*)item;
        
        CGFloat xFramePoint = ((NSNumber*)((NSDictionary*)itemDict)[kXCoordinateKey]).floatValue;
        CGFloat yFramePoint = ((NSNumber*)((NSDictionary*)itemDict)[kYCoordinateKey]).floatValue;
        
        NSPoint arbitraryStartPoint = CGPointMake(50.0, 50.0);
        NSPoint spotPoint = CGPointMake(xFramePoint, yFramePoint);
        
        if( addPointsForRedraw )
        {
            [self.spotView addSpot:spotPoint  withRadius:kDefaultRadius withDataDictionary:itemDict];
        }
        else
        {
            [self.spotView addMovingSpotAtPoint:arbitraryStartPoint forDestinationPoint:spotPoint withRadius:kDefaultRadius withDataDictionary:itemDict];
        }
    }
    
    [self animateSpots];
    
    if( addPointsForRedraw )
    {
        [AppDelegate sharedAppDelegate].inRedraw = NO;
    }
}

- (void)animateSpots
{
    [self.spotView animateSpots];
}

- (void)clearDataPoints
{
    [self.spotView removeAllSpots];
}

-(void)handleWindowDecodedNotification
{
    self.spotView.frame = self.bounds;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kGraphDataChangedNotification
     object:self];
}

@end

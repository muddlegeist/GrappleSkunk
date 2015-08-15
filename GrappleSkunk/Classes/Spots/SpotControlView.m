//
//  SpotControlView.mm
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "SpotControlView.h"
#import "SpotViewEntity.h"

@implementation SpotControlView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        _spots = [[NSMutableArray alloc] init];
		
		// Set up tracking areas so we can use mouseEntered and mouseExited
		int options = NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow | NSTrackingInVisibleRect;
		NSTrackingArea *ta;
		ta = [[NSTrackingArea alloc] initWithRect:NSZeroRect
										  options:options
											owner:self
										 userInfo:nil];
		[self addTrackingArea:ta];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor blackColor] setStroke];
	[[NSColor clearColor] setFill];
	
	[NSBezierPath fillRect:dirtyRect];
    
    for( id item in self.spots )
    {
        [(SpotViewEntity*)item draw];
    }
}

- (void)addSpot:(NSPoint)pt withDataDictionary:(NSDictionary*)spotDictionary
{
	SpotViewEntity* newSpot = [SpotViewEntity new];
	
	newSpot.viewPoint = pt;
    newSpot.spotData = spotDictionary;
	
	[self.spots addObject:newSpot];
}

- (void)addSpot:(NSPoint)pt withRadius:(CGFloat)radius withDataDictionary:(NSDictionary*)spotDictionary
{
	SpotViewEntity* newSpot = [[SpotViewEntity alloc] initWithRadius:radius];
	
	newSpot.viewPoint = pt;
    newSpot.spotData = spotDictionary;
	
	[self.spots addObject:newSpot];
}

- (void)removeSpot:(SpotViewEntity*)victimSpot
{
    [self.spots removeObject:victimSpot];
}

- (void)removeAllSpots
{
    [self.spots removeAllObjects];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
	[super mouseEntered:theEvent];
	//[[self window] setAcceptsMouseMovedEvents:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
	[super mouseEntered:theEvent];
	//[[self window] setAcceptsMouseMovedEvents:NO];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
	BOOL redraw = NO;
	
	NSPoint eventPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
    for( id item in self.spots )
    {
        SpotViewEntity* entity = (SpotViewEntity*)item;
        
        if( [entity isHit:eventPoint] )
        {
            [entity setEntityState:overState];
            redraw = YES;
        }
        else
        {
            if( [entity entityState] != defaultState )
            {
                [entity setEntityState:defaultState];
                redraw = YES;
            }
        }
    }
	
	if( redraw )
	{
		[self setNeedsDisplay:YES];
	}
}


@end

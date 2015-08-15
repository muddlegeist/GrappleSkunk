//
//  SpotViewEntity.mm
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "SpotViewEntity.h"

static CGFloat kDefaultRadius = 5.0;

float DistanceBetweenPoints(NSPoint pt1, NSPoint pt2)
{
    float ptxd = pt1.x - pt2.x;
    float ptyd = pt1.y - pt2.y;
    return sqrtf( ptxd*ptxd + ptyd*ptyd );
}

@implementation SpotViewEntity

- (id)init
{
	return [self initWithRadius:kDefaultRadius];
}

- (id)initWithRadius: (CGFloat)r
{
	self = [super init];
	
    if ( self )
	{
        _radius = r;
    }
	
	return self;
}

-(BOOL) isHit:(NSPoint)pt
{
    float distance = DistanceBetweenPoints( self.viewPoint, pt );
    
    return( distance <= self.radius );
}

-(void) draw
{
    switch( self.entityState )
    {
        case defaultState:
            [self drawDefault];
            break;
            
        case overState:
            [self drawMouseOver];
            break;
            
        case downState:
            [self drawMouseDown];
            break;
            
        case disabledState:
            [self drawDisabled];
            break;
    }
}

-(void) drawDefault
{
	[[NSColor blackColor] setFill];
	
	NSBezierPath * drawPath = [NSBezierPath bezierPath];
	[drawPath setLineWidth: 1];
	
	NSRect circleRect;
	
	circleRect.size.width = circleRect.size.height = 2.0 * self.radius;
	circleRect.origin.x = self.viewPoint.x - self.radius;
	circleRect.origin.y = self.viewPoint.y - self.radius;
	
	[drawPath appendBezierPathWithOvalInRect: circleRect];
	
	[drawPath fill];
}

-(void) drawMouseOver
{
	[[NSColor blackColor] setStroke];
	
	NSBezierPath * drawPath = [NSBezierPath bezierPath];
	[drawPath setLineWidth: 2];
	
	NSRect circleRect;
	
	circleRect.size.width = circleRect.size.height = 2.0 * self.radius;
	circleRect.origin.x = self.viewPoint.x - self.radius;
	circleRect.origin.y = self.viewPoint.y - self.radius;
	
	[drawPath appendBezierPathWithOvalInRect: circleRect];
	
	[drawPath stroke];
}

-(void) drawMouseDown
{
	[[NSColor blackColor] setStroke];
	[[NSColor colorWithDeviceRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0] setFill ];
	
	NSBezierPath * drawPath = [NSBezierPath bezierPath];
	[drawPath setLineWidth: 2];
	
	NSRect circleRect;
	
	circleRect.size.width = circleRect.size.height = 2.0 * self.radius;
	circleRect.origin.x = self.viewPoint.x - self.radius;
	circleRect.origin.y = self.viewPoint.y - self.radius;
	
	[drawPath appendBezierPathWithOvalInRect: circleRect];
	
	[drawPath fill];
	[drawPath stroke];
}

-(void) drawDisabled
{
	[[NSColor colorWithDeviceRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.4] setFill ];
	
	NSBezierPath * drawPath = [NSBezierPath bezierPath];
	[drawPath setLineWidth: 1];
	
	NSRect circleRect;
	
	circleRect.size.width = circleRect.size.height = 2.0 * self.radius;
	circleRect.origin.x = self.viewPoint.x - self.radius;
	circleRect.origin.y = self.viewPoint.y - self.radius;
	
	[drawPath appendBezierPathWithOvalInRect: circleRect];
	
	[drawPath fill];
}

@end

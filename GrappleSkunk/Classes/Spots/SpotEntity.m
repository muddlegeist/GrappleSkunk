//
//  SpotEntity.mm
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "SpotEntity.h"
#import "NSBezierPath+QuartzPath.h"
#import "PathFactory.h"
#import "GrappleSkunkConstants.h"

float DistanceBetweenPoints(NSPoint pt1, NSPoint pt2)
{
    float ptxd = pt1.x - pt2.x;
    float ptyd = pt1.y - pt2.y;
    return sqrtf( ptxd*ptxd + ptyd*ptyd );
}

@implementation SpotEntity

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

- (void)setEntityState:(EntityStateType)entityState
{
    _entityState = entityState;
    
    [self preparePathLayer];
}

- (void)setPathLayer:(CAShapeLayer *)pathLayer
{
    _pathLayer = pathLayer;
    
    [self preparePathLayer];
}



- (void)preparePathLayer
{
    self.pathLayer.path = [[self createPath] quartzPath];
    
    [self draw];
}

- (void)draw
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
    self.pathLayer.strokeColor = [NSColor blackColor].CGColor;
    self.pathLayer.fillColor = [NSColor blackColor].CGColor;
    self.pathLayer.opacity = 1.0;
    self.pathLayer.lineWidth = 1.0;
}

-(void) drawMouseOver
{
    self.pathLayer.strokeColor = [NSColor blackColor].CGColor;
    self.pathLayer.fillColor = [NSColor whiteColor].CGColor;
    self.pathLayer.opacity = 1.0;
    self.pathLayer.lineWidth = 2.0;
}

-(void) drawMouseDown
{
    self.pathLayer.strokeColor = [NSColor blackColor].CGColor;
    self.pathLayer.fillColor = [NSColor redColor].CGColor;
    self.pathLayer.opacity = 1.0;
    self.pathLayer.lineWidth = 2.0;
}

-(void) drawDisabled
{
    self.pathLayer.strokeColor = [NSColor clearColor].CGColor;
    self.pathLayer.fillColor = [NSColor colorWithDeviceRed: 1.0 green: 1.0 blue: 1.0 alpha: 0.4].CGColor;
    self.pathLayer.opacity = 1.0;
    self.pathLayer.lineWidth = 0.0;
}

- (NSBezierPath*)createPath
{
    NSBezierPath * drawPath = [PathFactory createCircularPathOfRadius:self.radius atPoint:self.viewPoint];
    
    return drawPath;
}


@end

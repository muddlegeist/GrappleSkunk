//
//  ViewEntity.mm
//  SpotControl
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "ViewEntity.h"


@implementation ViewEntity

- (id)init
{
	self = [super init];
	
	return self;
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
	[self doesNotRecognizeSelector:_cmd];
}

-(void) drawMouseOver
{
	[self doesNotRecognizeSelector:_cmd];
}

-(void) drawMouseDown
{
	[self doesNotRecognizeSelector:_cmd];
}

-(void) drawDisabled
{
	[self doesNotRecognizeSelector:_cmd];
}

@end

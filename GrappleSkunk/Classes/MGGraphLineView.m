//
//  MGGraphLineView.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/16/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "MGGraphLineView.h"
#import "GrappleSkunkConstants.h"
#import "NSBezierPath+QuartzPath.h"
#import "AppDelegate.h"

static NSString * const kAnimationKey = @"shapeAnimation";

@interface MGGraphLineView ()

@property (strong, nonatomic) NSBezierPath* path1;
@property (strong, nonatomic) NSBezierPath* path2;
@property (strong, nonatomic) CAShapeLayer* pathLayer;

@end

@implementation MGGraphLineView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit_MGGraphLineView
{
    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(doAnimation)
     name:kDoGraphLineAnimationNotification
     object:nil];
    
    self.wantsLayer = YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit_MGGraphLineView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit_MGGraphLineView];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"frame"]) {
        // do your stuff, or better schedule to run later using performSelector:withObject:afterDuration:
        [self createThePaths];
    }
}

- (void)setTheGraphPoints:(NSArray*)theGraphPoints
{
    _theGraphPoints = theGraphPoints;

    [self createThePaths];
}

- (void)createThePaths
{
    if( !self.theGraphPoints || self.theGraphPoints.count == 0 )
    {
        return;
    }
    
    if( self.pathLayer != nil )
    {
        self.pathLayer.path = nil;
    }
    
    CGRect viewBounds = self.bounds;
    CGFloat skunkWidth = viewBounds.size.width * kSkunkWidthPercent;
    CGFloat skunkHeight = viewBounds.size.height * kSkunkHeightPercent;
    CGFloat skunkTopMargin = viewBounds.size.height * kSkunkTopMarginPercent;
    
    CGRect theSkunkCenterscreenFrame = CGRectMake(viewBounds.origin.x + (viewBounds.size.width/2.0)/* - (skunkWidth/2.0)*/, viewBounds.origin.y + viewBounds.size.height - skunkTopMargin - skunkHeight, skunkWidth, skunkHeight);
    
    CGPoint originPoint = CGPointMake(theSkunkCenterscreenFrame.origin.x + 10.0, theSkunkCenterscreenFrame.origin.y + theSkunkCenterscreenFrame.size.height/2.0);
    
    NSInteger pointCount = self.theGraphPoints.count;
    
    self.path1 = [NSBezierPath new];
    [self.path1 moveToPoint:originPoint];
    for( NSInteger i = 1; i < pointCount; i++ )
    {
        [self.path1 lineToPoint:CGPointMake(originPoint.x + i, originPoint.y)];
    }
    
    self.path2 = nil;
    
    for( id item in self.theGraphPoints )
    {
        NSValue *valueItem = (NSValue*)item;
        
        NSPoint aPoint = [valueItem pointValue];
        
        if( self.path2 == nil )
        {
            self.path2 = [NSBezierPath new];
            [self. path2 moveToPoint:aPoint];
        }
        else
        {
            [self.path2 lineToPoint:aPoint];
        }
    }
    
    if( self.pathLayer == nil )
    {
        self.pathLayer = [CAShapeLayer layer];
     
        self.pathLayer.strokeColor = [NSColor greenColor].CGColor;
        self.pathLayer.fillColor = [NSColor clearColor].CGColor;
        self.pathLayer.opacity = 1.0;
        self.pathLayer.lineWidth = 3.0;
        
        [self.layer addSublayer:self.pathLayer];
    }
}

- (void)doAnimation
{
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    theAnimation.fromValue = (__bridge id) [self.path1 quartzPath];
    theAnimation.toValue = (__bridge id) [self.path2 quartzPath];
    
    theAnimation.repeatCount = 0;
    
    theAnimation.duration = 1.0;
    theAnimation.autoreverses = NO;
    theAnimation.fillMode = kCAFillModeForwards;
    
    [self.pathLayer addAnimation:theAnimation forKey:kAnimationKey];
    
    self.pathLayer.path = [self.path2 quartzPath];
    
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

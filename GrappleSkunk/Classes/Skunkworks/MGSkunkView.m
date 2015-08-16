//
//  MGSkunkView.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/16/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "MGSkunkView.h"
#import "GrappleSkunkConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface MGSkunkView ()

@property (assign, nonatomic) CGRect theSkunkOffscreenFrame1;
@property (assign, nonatomic) CGRect theSkunkOffscreenFrame2;
@property (assign, nonatomic) CGRect theSkunkCenterscreenFrame;
@property (strong, nonatomic) NSImageView* theSkunkView;
@property (assign, nonatomic) NSInteger animationIndex;

@end

@implementation MGSkunkView

- (void)commonInit_MGSkunkView
{
    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    self.wantsLayer = YES;
    
    [self createTheSkunk];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit_MGSkunkView];
    }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit_MGSkunkView];
    }
    return self;
}

- (void)createTheSkunk
{
    CGRect viewBounds = self.bounds;
    CGFloat skunkWidth = viewBounds.size.width * kSkunkWidthPercent;
    CGFloat skunkHeight = viewBounds.size.height * kSkunkHeightPercent;
    CGFloat skunkTopMargin = viewBounds.size.height * kSkunkTopMarginPercent;
    
    self.theSkunkOffscreenFrame1 = CGRectMake(viewBounds.origin.x - skunkWidth - 1.0, viewBounds.origin.y + viewBounds.size.height - skunkTopMargin - skunkHeight, skunkWidth, skunkHeight);
    
    self.theSkunkOffscreenFrame2 = CGRectMake(viewBounds.origin.x + viewBounds.size.width + 1.0, viewBounds.origin.y + viewBounds.size.height - skunkTopMargin - skunkHeight, skunkWidth, skunkHeight);
    
    self.theSkunkCenterscreenFrame = CGRectMake(viewBounds.origin.x + (viewBounds.size.width/2.0) - (skunkWidth/2.0), viewBounds.origin.y + viewBounds.size.height - skunkTopMargin - skunkHeight, skunkWidth, skunkHeight);
    
    if( !self.theSkunkView )
    {
        self.theSkunkView = [[NSImageView alloc] initWithFrame:self.theSkunkOffscreenFrame1];
        self.theSkunkView.wantsLayer = YES;
        self.theSkunkView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
        self.theSkunkView.image = [NSImage imageNamed:@"skunk-clip-art-skunk-6.png"];
        
        self.theSkunkView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [self addSubview:self.theSkunkView];
    }
    else
    {
        self.theSkunkView.frame = self.theSkunkOffscreenFrame1;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"frame"]) {
        // do your stuff, or better schedule to run later using performSelector:withObject:afterDuration:
        [self createTheSkunk];
    }
}

- (void)initialAnimation
{
    self.animationIndex = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3.0f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setFromValue:[NSValue valueWithPoint:self.self.theSkunkOffscreenFrame1.origin]];
    [animation setToValue:[NSValue valueWithPoint:self.theSkunkCenterscreenFrame.origin]];
    
    [self.theSkunkView.layer addAnimation:animation forKey:@"position"];
}

- (void)secondaryAnimation
{
    self.animationIndex = 1;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3.0f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setFromValue:[NSValue valueWithPoint:self.self.theSkunkCenterscreenFrame.origin]];
    [animation setToValue:[NSValue valueWithPoint:self.theSkunkOffscreenFrame2.origin]];
    
    [self.theSkunkView.layer addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if( flag )
    {
        NSLog(@"ANIMATION COMPLETED: SUCCESS");
        
        if( self.animationIndex == 0 )
        {
            self.theSkunkView.frame = self.theSkunkCenterscreenFrame;
            [self secondaryAnimation];
        }
        else if( self.animationIndex == 1 )
        {
            self.theSkunkView.frame = self.theSkunkOffscreenFrame1;
        }
    }
    else
    {
        NSLog(@"ANIMATION COMPLETED: FAILURE");
    }
}

- (void)animationCompleted
{
    //self.theSkunkView.frame = self.theSkunkOffscreenFrame1;
    NSLog(@"ANIMATION COMPLETED");
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

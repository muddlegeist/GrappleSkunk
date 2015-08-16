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
#import "AppDelegate.h"

#define ARC4RANDOM_MAX      0x100000000

typedef enum { kInitialAnimation, kSecondaryAnimation, kGiantPart1, kGiantPart2 } CompletedAnimationType;

@interface MGSkunkView ()

@property (assign, nonatomic) CGRect theSkunkOffscreenFrame1;
@property (assign, nonatomic) CGRect theSkunkOffscreenFrame2;
@property (assign, nonatomic) CGRect theSkunkCenterscreenFrame;
@property (strong, nonatomic) NSImageView* theSkunkView;
@property (assign, nonatomic) CGRect theGiantSkunkOffscreenFrame;
@property (assign, nonatomic) CGRect theGiantSkunkCenterscreenFrame;
@property (strong, nonatomic) NSImageView* theGiantSkunkView;
@property (assign, nonatomic) CompletedAnimationType animationType;
@property (assign, nonatomic) BOOL okForGiantVisit;

@end

@implementation MGSkunkView

- (void)commonInit_MGSkunkView
{
    [self addObserver:self forKeyPath:@"frame" options:0 context:nil];
    
    self.wantsLayer = YES;
    
    self.okForGiantVisit = NO;
    
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
    self.okForGiantVisit = NO;
    
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
    
    self.theGiantSkunkOffscreenFrame = CGRectMake(viewBounds.origin.x + viewBounds.size.width + 1.0, viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height);
    
    self.theGiantSkunkCenterscreenFrame = CGRectMake(viewBounds.origin.x + (viewBounds.size.width * kGiantSkunkPercent) + 1.0, viewBounds.origin.y, viewBounds.size.width, viewBounds.size.height);
    
    if( !self.theGiantSkunkView )
    {
        self.theGiantSkunkView = [[NSImageView alloc] initWithFrame:self.theGiantSkunkOffscreenFrame];
        self.theGiantSkunkView.wantsLayer = YES;
        self.theGiantSkunkView.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
        self.theGiantSkunkView.image = [NSImage imageNamed:@"skunk-clip-art-skunk-6.png"];
        
        self.theGiantSkunkView.imageScaling = NSImageScaleProportionallyUpOrDown;
        [self addSubview:self.theGiantSkunkView];
    }
    else
    {
        self.theGiantSkunkView.frame = self.theGiantSkunkOffscreenFrame;
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
    self.okForGiantVisit = NO;
    
    self.animationType = kInitialAnimation;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3.0f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setFromValue:[NSValue valueWithPoint:self.theSkunkOffscreenFrame1.origin]];
    [animation setToValue:[NSValue valueWithPoint:self.theSkunkCenterscreenFrame.origin]];
    
    [self.theSkunkView.layer addAnimation:animation forKey:@"position"];
}

- (void)secondaryAnimation
{
    self.animationType = kSecondaryAnimation;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3.0f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setFromValue:[NSValue valueWithPoint:self.theSkunkCenterscreenFrame.origin]];
    [animation setToValue:[NSValue valueWithPoint:self.theSkunkOffscreenFrame2.origin]];
    
    [self.theSkunkView.layer addAnimation:animation forKey:@"position"];
}

- (void)giantAnimation1
{
    if( !self.okForGiantVisit )
    {
        return;
    }
    
    self.animationType = kGiantPart1;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 5.0f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animation setFromValue:[NSValue valueWithPoint:self.theGiantSkunkOffscreenFrame.origin]];
    [animation setToValue:[NSValue valueWithPoint:self.theGiantSkunkCenterscreenFrame.origin]];
    
    [self.theGiantSkunkView.layer addAnimation:animation forKey:@"position"];
}

- (void)giantAnimation2
{
    self.animationType = kGiantPart2;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 5.0f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [animation setFromValue:[NSValue valueWithPoint:self.theGiantSkunkCenterscreenFrame.origin]];
    [animation setToValue:[NSValue valueWithPoint:self.theGiantSkunkOffscreenFrame.origin]];
    
    [self.theGiantSkunkView.layer addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if( flag )
    {
        if( self.animationType == kInitialAnimation )
        {
            self.theSkunkView.frame = self.theSkunkCenterscreenFrame;
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kDoGraphLineAnimationNotification
             object:self];
            
            [self secondaryAnimation];
        }
        else if( self.animationType == kSecondaryAnimation )
        {
            self.theSkunkView.frame = self.theSkunkOffscreenFrame2;
            
            [self scheduleGiantSkunkVisit];
        }
        else if( self.animationType == kGiantPart1 )
        {
            self.theGiantSkunkView.frame = self.theGiantSkunkCenterscreenFrame;
            
            [self giantAnimation2];
        }
        else if( self.animationType == kGiantPart2 )
        {
            self.theGiantSkunkView.frame = self.theGiantSkunkOffscreenFrame;
            
            [self scheduleGiantSkunkVisit];
        }
    }
}

- (void)scheduleGiantSkunkVisit
{
    self.okForGiantVisit = YES;
    
    CGFloat secondsInterval = kGiantVisitMaxSeconds - kGiantVisitMinSeconds;
    CGFloat randomTimeSeconds = kGiantVisitMinSeconds + (((double)arc4random() / ARC4RANDOM_MAX) * secondsInterval);
    
    MGSkunkView* __weak weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, randomTimeSeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        MGSkunkView* strongself = weakSelf;
        [strongself giantAnimation1];
    });
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end

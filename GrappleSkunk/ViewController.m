//
//  ViewController.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleDataChangedNotification)
     name:kGraphDataChangedNotification
     object:nil];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self.theGraphView.layer setNeedsLayout];
    [self.theGraphView.layer setNeedsDisplay];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Notification Handling

-(void)handleDataChangedNotification
{
    CGRect graphFrame = self.theGraphView.bounds;
    
    NSBezierPath *theGridPath = [[AppDelegate sharedAppDelegate].gsEngine getGridPathForFrame:graphFrame];
    
    self.theGraphView.theGridPath = theGridPath;
    [self.theGraphView clearDataPoints];
    [self.theGraphView addDataPoints:[[AppDelegate sharedAppDelegate].gsEngine getSortedArrayScaledToFrame:graphFrame]];
}

@end

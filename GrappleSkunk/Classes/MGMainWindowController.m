//
//  MGMainWindowController.m
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/15/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import "MGMainWindowController.h"
#import "AppDelegate.h"

@interface MGMainWindowController ()

@end

@implementation MGMainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark - NSWindowDelegate

//- (void)windowDidResize:(NSNotification *)notification
//{
//}

//the spot view layer was not being properly sized with the window restoration
- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kMainWindowDecodedNotification
     object:self];
}

@end

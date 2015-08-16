//
//  AppDelegate.h
//  GrappleSkunk
//
//  Created by Muddlegeist on 8/14/15.
//  Copyright (c) 2015 Muddlegeist. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GrappleSkunkEngine.h"

extern NSString* const kGraphDataChangedNotification;
extern NSString* const kRequestGraphRecalcNotification;
extern NSString* const kMainWindowDecodedNotification;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) GrappleSkunkEngine* gsEngine;

+ (AppDelegate*) sharedAppDelegate;

@end


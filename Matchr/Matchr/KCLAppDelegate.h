//
//  KCLAppDelegate.h
//  Matchr
//
//  Created by James Bellamy on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PeerAdvertise;

@interface KCLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) PeerAdvertise *advertise;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

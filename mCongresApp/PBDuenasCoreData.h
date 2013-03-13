//
//  PBDuenasCoreData.h
//  SoloRequestParse
//
//  Created by Arturo Sanhueza on 04-02-13.
//  Copyright (c) 2013 Arturo Sanhueza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PBDuenasCoreData : NSObject

+ (id)sharedInstance;

- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)masterManagedObjectContext;
- (NSManagedObjectContext *)backgroundManagedObjectContext;
- (NSManagedObjectContext *)newManagedObjectContext;
- (void)saveMasterContext;
- (void)saveBackgroundContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

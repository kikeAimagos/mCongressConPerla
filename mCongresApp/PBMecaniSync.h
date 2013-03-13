//
//  PBMecaniSync.h
//  SoloRequestParse
//
//  Created by Arturo Sanhueza on 04-02-13.
//  Copyright (c) 2013 Arturo Sanhueza. All rights reserved.
//

#import <Foundation/Foundation.h>

//pareciera que este metodo crea o actualiza, según corresponda, un NSManagedObject basado en un registro desde los archivos traídos desde parse, y alojados en los JSONResponses

typedef enum {
    PBObjectSynced = 0,
    PBObjectCreated,
    PBObjectDeleted,
} PBObjectSyncStatus;

@interface PBMecaniSync : NSObject
@property (atomic, readonly) BOOL syncInProgress;
+ (PBMecaniSync *)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync;
- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;

@end

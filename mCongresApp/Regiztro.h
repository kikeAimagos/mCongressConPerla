//
//  Regiztro.h
//  mCongres
//
//  Created by Arturo Sanhueza on 02-03-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Regiztro : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * contenidoPerla;


@end

//
//  Congreso.h
//  mCongres
//
//  Created by Arturo Sanhueza on 02-03-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//poco

@interface Congreso : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSString * cargoExpositor;
@property (nonatomic, retain) NSNumber * syncStatus;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * detalle1Exposicion;
@property (nonatomic, retain) NSString * detalle2Exposicion;
@property (nonatomic, retain) NSString * detalle3Exposicion;
@property (nonatomic, retain) NSString * detalle4Exposicion;
@property (nonatomic, retain) NSString * detalle5Exposicion;
@property (nonatomic, retain) NSString * empresaExpositor;
@property (nonatomic, retain) NSString * fechaHoraConferencia;
@property (nonatomic, retain) NSData * fotografiaExpositor;
@property (nonatomic, retain) NSString * nombreExpositor;
@property (nonatomic, retain) NSString * sesionexposicion;
@property (nonatomic, retain) NSString * tipoActividad;
@property (nonatomic, retain) NSString * tituloExposicion;
@property (nonatomic, retain) NSNumber * idConferencia;
@property (nonatomic, retain) NSDate * fechaHoraComparar;
@property (nonatomic, retain) NSNumber * sesionExposicion;
@end

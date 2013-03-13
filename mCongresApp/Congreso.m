//
//  Congreso.m
//  mCongres
//
//  Created by Arturo Sanhueza on 02-03-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import "Congreso.h"
@implementation Congreso

@dynamic createdAt;
@dynamic objectId;
@dynamic cargoExpositor;
@dynamic syncStatus;
@dynamic updatedAt;
@dynamic detalle1Exposicion;
@dynamic detalle2Exposicion;
@dynamic detalle3Exposicion;
@dynamic detalle4Exposicion;
@dynamic detalle5Exposicion;
@dynamic empresaExpositor;
@dynamic fechaHoraConferencia;
@dynamic fotografiaExpositor;
@dynamic nombreExpositor;
@dynamic sesionexposicion;
@dynamic tipoActividad;
@dynamic tituloExposicion;
@dynamic idConferencia;
@dynamic fechaHoraComparar;
@dynamic sesionExposicion;



- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.cargoExpositor, @"cargoExpositor",
                                    self.detalle1Exposicion, @"detalle1Exposicion",
                                    self.detalle2Exposicion, @"detalle2Exposicion",
                                    self.detalle3Exposicion, @"detalle3Exposicion",
                                    self.detalle4Exposicion, @"detalle4Exposicion",
                                    self.detalle5Exposicion, @"detalle5Exposicion",
                                    self.empresaExpositor, @"empresaExpositor",
                                    self.fechaHoraConferencia, @"fechaHoraConferencia",
                                    self.fotografiaExpositor, @"fotografiaExpositor",
                                    self.nombreExpositor, @"nombreExpositor",
                                    self.sesionexposicion, @"sesionexposicion",
									self.sesionExposicion, @"sesionExposicion",
                                    self.tipoActividad, @"tipoActividad",
                                    self.tituloExposicion, @"tituloExposicion",
                                    self.idConferencia, @"idConferencia",
									self.fechaHoraComparar,@"fechaHoraComparar",
                                    nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:jsonDictionary
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    if (!jsonData) {
        NSLog(@"Error creaing jsonData: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonDictionary;
}

@end

//
//  Regiztro.m
//  mCongres
//
//  Created by Arturo Sanhueza on 02-03-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import "Regiztro.h"


@implementation Regiztro

@dynamic createdAt;
@dynamic objectId;
@dynamic nombre;
@dynamic syncStatus;
@dynamic updatedAt;
@dynamic email;
@dynamic contenidoPerla;


- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.nombre, @"nombre",
                                    self.email, @"email",
                                    self.contenidoPerla, @"contenidoPerla",
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

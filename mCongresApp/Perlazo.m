//
//  Perlazo.m
//  mCongres
//
//  Created by Arturo Sanhueza on 02-03-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import "Perlazo.h"


@implementation Perlazo

@dynamic objectId;
@dynamic createdAt;
@dynamic syncStatus;
@dynamic updatedAt;
@dynamic perlazoSync;

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.perlazoSync, @"perlazoSync",
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

//
//  PBAFParseApiCliente.h
//  SoloRequestParse
//
//  Created by Arturo Sanhueza on 04-02-13.
//  Copyright (c) 2013 Arturo Sanhueza. All rights reserved.
//

#import "AFHTTPClient.h"

@interface PBAFParseApiCliente : AFHTTPClient

+ (PBAFParseApiCliente *)sharedClient;

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate;
- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;
- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId;

@end

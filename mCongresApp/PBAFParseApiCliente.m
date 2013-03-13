//
//  PBAFParseApiCliente.m
//  SoloRequestParse
//
//  Created by Arturo Sanhueza on 04-02-13.
//  Copyright (c) 2013 Arturo Sanhueza. All rights reserved.
//

#import "PBAFParseApiCliente.h"
#import "AFJSONRequestOperation.h"


// Acá creamos estas 3 variables estáticas que básicamente van a dar la información necesaria para que usemos determinada app de parse. la APIURL, APLICATIONID Y LA RESTAPIKEY respectivamente, para así poder comunicarnos con ellas.

static NSString * const kSDFParseAPIBaseURLString = @"https://api.parse.com/1/";
static NSString * const kSDFParseAPIApplicationId = @"wt95Vjvz0XqP7hI1Rjg47BKcHhQQcgzn7UXtdBzN";
static NSString * const kSDFParseAPIKey = @"iUcflzSJf0R39Wj9lcOenGBVSFtwSdMkyLWwdiqI";

@implementation PBAFParseApiCliente



// En este lugar vamos a implementar la + "huea que ponga en el momento", que usa un GCD para crear una nueva instancia de la clase y luego almacenarla, dejándola así en una variable estática.


//(Si no saben que chucha es un GCD, como yo en el momento en que hice esta huea, vean la definición acá:
//(  http://cocoaenespanol.blogspot.com/2012_04_01_archive.html. )



+ (PBAFParseApiCliente *)sharedClient {
    static PBAFParseApiCliente *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PBAFParseApiCliente alloc] initWithBaseURL:[NSURL URLWithString:kSDFParseAPIBaseURLString]];
    });
    return sharedClient;
}

//Ahora dejamos en claro que vamos a usar código de tipo JSON , y luego instanciamos las APPID, y RESTAPIKEY, que nos entrga parse.

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setParameterEncoding:AFJSONParameterEncoding];
        [self setDefaultHeader:@"X-Parse-Application-Id" value:kSDFParseAPIApplicationId];
        [self setDefaultHeader:@"X-Parse-REST-API-Key" value:kSDFParseAPIKey];
    }
    return self;
}
// Esta Clase retornará una NSMutableURLRequest, la cual se usa para traer un objeto de parse, según la api key que estemos usando, con el el nombre de la clase "EL-NOMBRE-DE-LA-CLASE" y presentará un NSDictionary con parámetros.

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    return request;
}

//Esta huea devolverá una NSMutableURLRequest que se usa pa traer registros desde la API-PARSE actualizados después de una Fecha específica.Este método también crea un diccionario con parametros y llama el método GETRequestForClass( es la huea que esta justo arriba), pa así de ésa manera reaprovechar el request hecho anteriormente.

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate {
    NSMutableURLRequest *request = nil;
    NSDictionary *paramters = nil;
//    NSMutableDictionary *aa = [NSMutableDictionary dictionary];
//    [aa setValue:@"1" forKey:@"limit"];
    if (updatedDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.'999Z'"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSString *jsonString = [NSString
                                stringWithFormat:@"{\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"%@\"}}}",
                                [dateFormatter stringFromDate:updatedDate]];
        paramters = [NSDictionary dictionaryWithObject:jsonString forKey:@"where"];
    }
    
    request = [self GETRequestForClass:className parameters:paramters];
    
    return request;
    //Terminada de implementar ésta clase tenemos, nuestro cliente AFNetworking está listo para ser usado.
    
}


//implementaremos this huea, para poder subir nuestros registro creados a nivel local al servidor.
//lo que hace este mariconazo es que trae una className y un NSDictionary con una cagasón de parametros, los cuales deben cumplir las hueas que queramos subir al servidor.

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"POST" path:[NSString stringWithFormat:@"classes/%@", className] parameters:parameters];
    return request;
}

//Este es el método que se usa para eliminar objetos en el servidor, luego de que se elimina a nivel local.

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {
    NSMutableURLRequest *request = nil;
    request = [self requestWithMethod:@"DELETE" path:[NSString stringWithFormat:@"classes/%@/%@", className, objectId] parameters:nil];
    return request;
}
@end

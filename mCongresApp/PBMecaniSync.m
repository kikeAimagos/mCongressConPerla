//
//  PBMecaniSync.m
//  SoloRequestParse
//
//  Created by Arturo Sanhueza on 04-02-13.
//  Copyright (c) 2013 Arturo Sanhueza. All rights reserved.
//

#import "PBMecaniSync.h"
#import "PBDuenasCoreData.h"
#import "PBAFParseApiCliente.h"
#import "AFHTTPRequestOperation.h"
#import "NSManagedObject+JSON.h"

//Estas dos variables constantes serán necesarias para cuando queramos saber si nuestra sincronización inicial ha sido llevada a cabo( la primera variable), o si una sincronización que no sea la primera haya sido finalizada(la otra variable), y podemos encontrarlas en la el método mostRecentUpdatedAtDateForEntityWithName.


NSString * const kSDSyncEngineInitialCompleteKey = @"SDSyncEngineInitialSyncCompleted";
NSString * const kSDSyncEngineSyncCompletedNotificationName = @"SDSyncEngineSyncCompleted";

@interface PBMecaniSync ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation PBMecaniSync


//En función de sincronizar datos entre Core Data y Parse usaremos una estrategia, en donde las sub-clases de NSManagedObjects serán registradas con SDSyncEngine.
// ES decir el syncEngine, manejara los procesos para poder tomar datos desde parse y hacer las hueas que queramos con ellos.

@synthesize syncInProgress = _syncInProgress;

@synthesize registeredClassesToSync = _registeredClassesToSync;
@synthesize dateFormatter = _dateFormatter;

// aquí se añade éste método para acceder a la instancia del singleton, es decir que sólo de aquí y desde aquí se podrán hacer modificaciones en nuestro determinado objeto.??

//está es la definición de singleton, según eikipedia para el que no sabe que es :http://es.wikipedia.org/wiki/Singleton

+ (PBMecaniSync *)sharedEngine {
    static PBMecaniSync *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[PBMecaniSync alloc] init];
    });
    return sharedEngine;
}

//Este método registra dentro de una clase, una subclase, sólo si ésta ya no ha sido registrada. Tmabién revisa, si el objecto es una sub-clase del NSManagedObject.

- (void)registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        } else {
            NSLog(@"No se pudo registrar esta huea %@ porque ya esta registrada saco de hueas", NSStringFromClass(aClass));
        }
    } else {
        NSLog(@"Cagó mi amigo %@ no es una sub-clase de NSManagedObject", NSStringFromClass(aClass));
    }
}
// este método va a revisar si la sincro esta en progreso, si no es así, establece la property syncInProgress. A continuación, usa un GCD para iniciar un bloque asincrónico que básicamente no hace otra huea que llamar nuestra función downloadDataFOrRegisteredObjects.

- (void)startSync {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        });
    }
}
// Ejecutará las operaciones a realizarse en caso de que la sincronización se finit.
- (void)executeSyncCompletedOperations {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setInitialSyncCompleted];
        NSError *error = nil;
        [[PBDuenasCoreData sharedInstance] saveBackgroundContext];
        if (error) {
            NSLog(@"Error saving background context after creating objects on server: %@", error);
        }
        
        [[PBDuenasCoreData sharedInstance] saveMasterContext];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kSDSyncEngineSyncCompletedNotificationName
         object:nil];
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = NO;
        [self didChangeValueForKey:@"syncInProgress"];
    });
}

- (BOOL)initialSyncComplete {
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSDSyncEngineInitialCompleteKey] boolValue];
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:kSDSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//La Finalidad de ésta mierda es gestionar que sólo se traigan los registros nuevos desde parse en función de optimizar nuestra APP.
// PARA lograr esta huea, nos guiaremos según nuesto atributo "updatedAt" que tenemos en nuestras Entidades, y éste se encargará de traer sólos los registros que hayan sido modificados después de la fecha que él indique.

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setSortDescriptors:[NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    [request setFetchLimit:1];
    [[[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext] executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];
    
    return date;
}
// Esta hueonía es re-importante, y es la que toma los datos que hemos ido registrando en nuestros Objetos JSONResponses y los guarda, modifica y/o elimina, si se requiere.
- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete {
    NSMutableArray *operations = [NSMutableArray array];
    
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        NSMutableURLRequest *request = [[PBAFParseApiCliente sharedClient]
                                        GETRequestForAllRecordsOfClass:className
                                        updatedAfterDate:mostRecentUpdatedDate];
        AFHTTPRequestOperation *operation = [[PBAFParseApiCliente sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                //esta acción escribe los datos en archivos creados en el disco, en formato property List.
                [self writeJSONResponse:responseObject toDiskForClassWithName:className];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request for class %@ failed with error: %@", className, error);
        }];
        
        [operations addObject:operation];
    }
    
    [[PBAFParseApiCliente sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        
        if (!toDelete) {
            [self processJSONDataRecordsIntoCoreData];
        } else {
            [self processJSONDataRecordsForDeletion];
        }
    }];
}
//Nuestro amiguito aquí va a tomar los datos que que le pidamos desde los JSONResponses, y va a guardarlos dentro de core data

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext];
    for (NSString *className in self.registeredClassesToSync) {
        if (![self initialSyncComplete]) {             //importa todos los datos bajados a Core Data para la sincro inicial, si es la primera sincro, entonces hay que traer los datos JSON desde el disco
            
            // para iterar sobre la clase actual, o crear un nuevo NSManahedOjbect
            NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
            NSArray *records = [JSONDictionary objectForKey:@"results"];
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:className forRecord:record];
            }
        } else {
            //documentación que venía por defecación, de ahí la traduzco
            
            
            
            
            // Otherwise you need to do some more logic to determine if the record is new or has been updated.
            // First get the downloaded records from the JSON response, verify there is at least one object in
            // the data, and then fetch all records stored in Core Data whose objectId matches those from the JSON response.
            //
            
            NSArray *downloadedRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
            if ([downloadedRecords lastObject]) {
                
                //
                // Now you have a set of objects from the remote service and all of the matching objects
                // (based on objectId) from your Core Data store. Iterate over all of the downloaded records
                // from the remote service.
                //
                
                NSArray *storedRecords = [self managedObjectsForClass:className sortedByKey:@"objectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
                int currentIndex = 0;
                
                //
                // If the number of records in your Core Data store is less than the currentIndex, you know that
                // you have a potential match between the downloaded records and stored records because you sorted
                // both lists by objectId, this means that an update has come in from the remote service
                //
                
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;
                    if ([storedRecords count] > currentIndex) {
                        storedManagedObject = [storedRecords objectAtIndex:currentIndex];
                    }
                    
                    if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                        [self updateManagedObject:[storedRecords objectAtIndex:currentIndex] withRecord:record];
                    } else {
                        [self newManagedObjectWithClassName:className forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unable to save context for class %@", className);
            }
        }];
        
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    //modificación que le hice a ésta huea, que consiste más que nada en que cada vez que traiga datos de parse, va a eliminar los datos antiguos de core data, para poner los más nuevos. Esta huea la hice, dandole valor YES, al boleano "toDeleteLocalRecords:(BOOL)".
    //Cabe destacar que la huea descrita anteriormente funcioan únicamente para el simulator 5.1, los otros simuladores no entienden la huea, los que lean esta mierda, por fa ayudenme a cachar por que puede ser.
    
    [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
}

//Es el encagado de los proceso de eliminar los datos que se requieran. 

- (void)processJSONDataRecordsForDeletion {
    NSManagedObjectContext *managedObjectContext = [[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext];
    for (NSString *className in self.registeredClassesToSync) {
        NSArray *JSONRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
        if ([JSONRecords count] > 0) {
            NSArray *storedRecords = [self
                                      managedObjectsForClass:className
                                      sortedByKey:@"objectId"
                                      usingArrayOfIds:[JSONRecords valueForKey:@"objectId"]
                                      inArrayOfIds:NO];
            
            [managedObjectContext performBlockAndWait:^{
                for (NSManagedObject *managedObject in storedRecords) {
                    [managedObjectContext deleteObject:managedObject];
                }
                NSError *error = nil;
                BOOL saved = [managedObjectContext save:&error];
                if (!saved) {
                    NSLog(@"Unable to save context after deleting records for class %@ because %@", className, error);
                }
            }];
        }
        
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    
    [self postLocalObjectsToServer];
}
//Aquí se acepta y un registro, con esta información se creará un nuevo NSManagedOBject en el backgroundManagedObjectContext.

- (void)newManagedObjectWithClassName:(NSString *)className forRecord:(NSDictionary *)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext]];
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:newManagedObject];
    }];
    [record setValue:[NSNumber numberWithInt:PBObjectSynced] forKey:@"syncStatus"];
}
//Acepta un NSMangedObject y un registro, con esto podresmo acutalizar el NSManagedObject que usemos con los registro que establezcamos, en el backgroundManagedObjectContext.


- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(NSDictionary *)record {
    [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setValue:obj forKey:key forManagedObject:managedObject];
    }];
}


//Este método acepta un value,key, and managedObject. si la key = a createdAT o UpdatedAt, los convertiremos a formato NSDates. si la key es un NSDictionary tendremos que revisar el _type key para poder determinar el tipo de dato traído desde Parse . si es de tipo Date, lo transformaremos de un NSString  un NSdate. Si es un archivo , vamos a tener que huevear un poco más ( si queremos trabajar con imagenes ésta huea es necesaria).

- (void)setValue:(id)value forKey:(NSString *)key forManagedObject:(NSManagedObject *)managedObject {
    if ([key isEqualToString:@"createdAt"] || [key isEqualToString:@"updatedAt"]) {
        NSDate *date = [self dateUsingStringFromAPI:value];
        [managedObject setValue:date forKey:key];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value objectForKey:@"__type"]) {
            NSString *dataType = [value objectForKey:@"__type"];
            if ([dataType isEqualToString:@"Date"]) {
                NSString *dateString = [value objectForKey:@"iso"];
                NSDate *date = [self dateUsingStringFromAPI:dateString];
                [managedObject setValue:date forKey:key];
            } else if ([dataType isEqualToString:@"File"]) {
                NSString *urlString = [value objectForKey:@"url"];
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *request = [NSURLRequest requestWithURL:url];
                NSURLResponse *response = nil;
                NSError *error = nil;
                NSData *dataResponse = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
                [managedObject setValue:dataResponse forKey:key];
            } else {
                NSLog(@"Unknown Data Type Received");
                [managedObject setValue:nil forKey:key];
            }
        }
    } else {
        [managedObject setValue:value forKey:key];
    }
}

//Esla función que sirve en caso de que queramos agregar o modificar un objeto desde nuestra aplicación local, al servidor.

- (void)postLocalObjectsToServer {
    NSMutableArray *operations = [NSMutableArray array];
    for (NSString *className in self.registeredClassesToSync) {
        NSArray *objectsToCreate = [self managedObjectsForClass:className withSyncStatus:PBObjectCreated];
        for (NSManagedObject *objectToCreate in objectsToCreate) {
            NSDictionary *jsonString = [objectToCreate JSONToCreateObjectOnServer];
            NSMutableURLRequest *request = [[PBAFParseApiCliente sharedClient] POSTRequestForClass:className parameters:jsonString];
            
            AFHTTPRequestOperation *operation = [[PBAFParseApiCliente sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success creation: %@", responseObject);
                NSDictionary *responseDictionary = responseObject;
                NSDate *createdDate = [self dateUsingStringFromAPI:[responseDictionary valueForKey:@"createdAt"]];
                [objectToCreate setValue:createdDate forKey:@"createdAt"];
                [objectToCreate setValue:[responseDictionary valueForKey:@"objectId"] forKey:@"objectId"];
                [objectToCreate setValue:[NSNumber numberWithInt:PBObjectSynced] forKey:@"syncStatus"];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failed creation: %@", error);
            }];
            [operations addObject:operation];
        }
    }
    
    [[PBAFParseApiCliente sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"Completed %d of %d create operations", numberOfCompletedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        if ([operations count] > 0) {
            NSLog(@"Creation of objects on server compelete, updated objects in context: %@", [[[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext] updatedObjects]);
            [[PBDuenasCoreData sharedInstance] saveBackgroundContext];
            NSLog(@"SBC After call creation");
        }
        
        [self deleteObjectsOnServer];
        
    }];
}

//Elimina los objetos que a nivel local sean eliminados en el servidor.

- (void)deleteObjectsOnServer {
    NSMutableArray *operations = [NSMutableArray array];
    for (NSString *className in self.registeredClassesToSync) {
        NSArray *objectsToDelete = [self managedObjectsForClass:className withSyncStatus:PBObjectDeleted];
        for (NSManagedObject *objectToDelete in objectsToDelete) {
            NSMutableURLRequest *request = [[PBAFParseApiCliente sharedClient]
                                            DELETERequestForClass:className
                                            forObjectWithId:[objectToDelete valueForKey:@"objectId"]];
            
            AFHTTPRequestOperation *operation = [[PBAFParseApiCliente sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Success deletion: %@", responseObject);
                [[[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext] deleteObject:objectToDelete];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Failed to delete: %@", error);
            }];
            
            [operations addObject:operation];
        }
    }
    
    [[PBAFParseApiCliente sharedClient] enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        if ([operations count] > 0) {
            NSLog(@"Deletion of objects on server compelete, updated objects in context: %@", [[[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext] updatedObjects]);
        }
        
        [self executeSyncCompletedOperations];
    }];
}

//retorna un NSArray de NSManagedObjects para una para la className que se especifique, donde donde su estado de sincro (syncStatus), tomará el valor específico, que se le indique.
- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(PBObjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

// Trae un NSArray de NSManagedObjects para la className que se especifique, ordenados por su key, usnado un array de objectIds, y se puede descifrar los objetos que se repiten, o los que no.

- (NSArray *)managedObjectsForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [[PBDuenasCoreData sharedInstance] backgroundManagedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (objectId IN %@)", idArray];
    }
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:
                                      [NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

//En disfunción erectil de la traducción de los registros de el o los Objectos JSON a NSManagedObjects necesitaremos implementar un par de hueas .Es decir, para empezar necesitaremos trducir los valores JSON a Ojetillo-C; el método que vayamos a usar, depende del servicio remoto con el cual estemos trabajando, que en nuestro caso es Parse, que es re-mariconazo en lo que concierne a sus tipos de datos.
// los datos que necesitamos específicamente son archivos y fechas.


//este método instcia las propedidades de nuestro formato de fecha.
- (void)initializeDateFormatter {
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}
// acá recibiremos una dato de tipoNSString, y devolveremos un objeto NSDate.
- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString {
    [self initializeDateFormatter];
    // NSDateFormatter no usa ISO 8601 (que parece que es el formato en el que nos entrga la fecha parse) así es que vamos a tener que entrar a picar acá, y hacer algunas modificaciones pa que sea compatibles los formatos de la fecha de parse y nuestras app.
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-5)];
    
    return [self.dateFormatter dateFromString:dateString];
}

//Este metodo recibe un NSDate, y lo transforma en un NSString

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date {
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    // remove Z
    dateString = [dateString substringWithRange:NSMakeRange(0, [dateString length]-1)];
    // add milliseconds and put Z back on
    dateString = [dateString stringByAppendingFormat:@".000Z"];
    
    return dateString;
}

#pragma mark - File Management
//estos 2 métodos devuleven las direcciones NSURL del disco en donde donde los archivos que traigamos desde parse se alojarán.

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)JSONDataRecordsDirectory{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:@"JSONRecords/" relativeToURL:[self applicationCacheDirectory]];
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:[url path]]) {
        [fileManager createDirectoryAtPath:[url path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return url;
}


// la presente huea tiene más relación con la aplicación y el servicio remoto ya que hará que, cada respuesta sea guardada en el disco con el nombre respectivo de su clase.


- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    if (![(NSDictionary *)response writeToFile:[fileURL path] atomically:YES]) {
        NSLog(@"Error saving response to disk, will attempt to remove NSNull values and try again.");
        // Ya que en el disco no se pueden serializar objetos nulos , porque dichas hueas en realidad no son nada, crearemos a continuación una huea que se va a dedicar a eliminar todos los  datos nulos.
        NSArray *records = [response objectForKey:@"results"];
        NSMutableArray *nullFreeRecords = [NSMutableArray array];
        for (NSDictionary *record in records) {
            NSMutableDictionary *nullFreeRecord = [NSMutableDictionary dictionaryWithDictionary:record];
            [record enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [nullFreeRecord setValue:nil forKey:key];
                }
            }];
            [nullFreeRecords addObject:nullFreeRecord];
        }
        
        NSDictionary *nullFreeDictionary = [NSDictionary dictionaryWithObject:nullFreeRecords forKey:@"results"];
        
        if (![nullFreeDictionary writeToFile:[fileURL path] atomically:YES]) {
            NSLog(@"Traté de guardar la huea en el disco, pero no pude, siento decepcionarlo señor Karadimaricon: %@", response);
        }
    }
}
// para cuando los archivos de las "respuestas" de JSON que hemos guardado en el disco, ya no sean necesarios, crearemos en función de que el funcionamiento de nuestra app sea el mejor posible, éste métodos que los hará cagar.

- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className {
    NSURL *url = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    NSError *error = nil;
    BOOL deleted = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
    if (!deleted) {
        NSLog(@"No se puede borrar el regitro JSON en %@, Porque: %@", url, error);
    }
}

//Esta huea recupera los archivos desde el disco.

- (NSDictionary *)JSONDictionaryForClassWithName:(NSString *)className {
    NSURL *fileURL = [NSURL URLWithString:className relativeToURL:[self JSONDataRecordsDirectory]];
    return [NSDictionary dictionaryWithContentsOfURL:fileURL];
}
//Para traer la sólo  la información en la que estemos interesados, implementaremos la siguiente huea que va a llamar el método que implementamos justo arriba (JSONDictionaryForClassWithName), y devolverá un NSARRAY de todos los registros en respuesta de un orden específico de una key.
- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortedByKey:(NSString *)key {
    NSDictionary *JSONDictionary = [self JSONDictionaryForClassWithName:className];
    NSArray *records = [JSONDictionary objectForKey:@"results"];
    return [records sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                 [NSSortDescriptor sortDescriptorWithKey:key ascending:NO]]];
}
@end

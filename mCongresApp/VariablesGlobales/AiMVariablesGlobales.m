//
//  AiMVariablesGlobales.m
//  PlantillamCONGRES
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import "AiMVariablesGlobales.h"

@implementation AiMVariablesGlobales

@synthesize AltaSignIn , UserEmailSave,UserNameSave;
@synthesize TargetaCharlaSelecionada,SesionSelecionada,BlogAimagos;


static AiMVariablesGlobales *UnicaInstancia = nil;

/* Metodo para inicilizar el Singleton */

+(AiMVariablesGlobales *) VariablesSingletonObject
{
    /*en este metodo si se puede dar el caso de que se mande llamar mucho
    tienes que ocuparte de la concurrencia, pero creo que no es tu caso*/
    
    if(UnicaInstancia==nil)
        UnicaInstancia=[[AiMVariablesGlobales alloc] init];//seria la unica ve que lo creamos
    
    return UnicaInstancia;
}

@end

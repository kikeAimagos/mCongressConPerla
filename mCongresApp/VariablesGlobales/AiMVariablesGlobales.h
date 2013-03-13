//
//  AiMVariablesGlobales.h
//  PlantillamCONGRES
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AiMVariablesGlobales : NSObject
{
    BOOL AltaSignIn;
    int *SesionSelecionada;
    int *TargetaCharlaSelecionada;
    
}
@property(nonatomic)BOOL AltaSignIn;
@property(nonatomic , strong)NSString *UserNameSave;
@property(nonatomic , strong)NSString *UserEmailSave;
@property(nonatomic )int *SesionSelecionada;
@property(nonatomic )int *TargetaCharlaSelecionada;
@property(nonatomic )BOOL *BlogAimagos;
@property(nonatomic )BOOL *Iphone5;

+(AiMVariablesGlobales *) VariablesSingletonObject;


@end

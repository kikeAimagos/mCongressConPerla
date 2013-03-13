//
//  AiMMapaViewController.m
//  mCongres
//
//  Created by luis Gonzalez on 01-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import "AiMMapaViewController.h"
#import "AiMVariablesGlobales.h"

@interface AiMMapaViewController ()

@end

@implementation AiMMapaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    self.trackedViewName = [Variables.UserNameSave stringByAppendingFormat: @" Mapa"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark Rotacion Pantalla
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}

@end

//
//  AiMAboutViewController.m
//  mCongres
//
//  Created by luis Gonzalez on 01-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//
#import "MFSideMenu.h"
#import "AiMVariablesGlobales.h"
#import "AiMWebViewController.h"
#import "AiMAboutViewController.h"
#import "AiMVistaPerlaDetalleViewController.h"



@interface AiMAboutViewController ()

@end

@implementation AiMAboutViewController

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
    [self.navigationController.sideMenu setupSideMenuBarButtonItem];
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    self.trackedViewName = [Variables.UserNameSave stringByAppendingFormat: @" About"];
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
  
}

- (IBAction)EventoPerlaDetalle:(UIButton *)sender
{
    
    AiMVistaPerlaDetalleViewController *DetallePerla = [[AiMVistaPerlaDetalleViewController alloc]initWithNibName:@"AiMVistaPerlaDetalleViewController" bundle:Nil];
    [self.navigationController pushViewController:DetallePerla animated:YES];
    
}

#pragma -mark Rotacion Pantalla

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return NO;
    
}

- (IBAction)EventoWebAimagos:(UIButton *)sender
{
    
     AiMWebViewController *vistaWeb = [[AiMWebViewController alloc]initWithNibName:@"AiMWebViewController" bundle:Nil];
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    Variables.BlogAimagos = FALSE;
    
    [self.navigationController pushViewController:vistaWeb animated:YES];
}

- (IBAction)EventoBlogAimagos:(UIButton *)sender {
    AiMWebViewController *vistaWeb = [[AiMWebViewController alloc]initWithNibName:@"AiMWebViewController" bundle:Nil];
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    Variables.BlogAimagos = TRUE;
    
    [self.navigationController pushViewController:vistaWeb animated:YES];
}
@end

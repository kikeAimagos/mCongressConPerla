//
//  AiMWebViewController.m
//  mCongres
//
//  Created by luis Gonzalez on 07-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//


#import "MFSideMenu.h"
#import "AiMWebViewController.h"
#import "AiMVariablesGlobales.h"

@interface AiMWebViewController ()

@end

@implementation AiMWebViewController
@synthesize TextoPerla ,WebAimagos ,url;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.sideMenu setupSideMenuBarButtonItem];
	
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    if(Variables.BlogAimagos == FALSE)
    {
        url       = [NSURL URLWithString:@"http://www.aimagos.com"];
    }
		else
		{
			url       = [NSURL URLWithString:@"http://blog.aimagos.com/"];
		}
    
    NSURLRequest *loadURL   = [[NSURLRequest alloc] initWithURL:url];
    [WebAimagos loadRequest:loadURL];
    self.title = [WebAimagos stringByEvaluatingJavaScriptFromString:@"document.title"];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTextoPerla:nil];
    [self setWebAimagos:nil];
    [super viewDidUnload];
}
- (IBAction)EventoPerlaDetalle:(UIButton *)sender {
    
    AiMVistaPerlaDetalleViewController *DetallePerla = [[AiMVistaPerlaDetalleViewController alloc]initWithNibName:@"AiMVistaPerlaDetalleViewController" bundle:Nil];
    
    [self.navigationController pushViewController:DetallePerla animated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}

@end

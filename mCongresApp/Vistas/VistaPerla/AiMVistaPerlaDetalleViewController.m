//
//  AiMVistaPerlaDetalleViewController.m
//  mCongres
//
//  Created by luis Gonzalez on 04-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//
#import "MFSideMenu.h"
#import "AiMVistaPerlaDetalleViewController.h"


@interface AiMVistaPerlaDetalleViewController ()

@end

@implementation AiMVistaPerlaDetalleViewController

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
    self.title = @"Perla";
    // Do any additional setup after loading the view from its nib.
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

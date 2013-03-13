//
//  AiMSideViewController.h
//  mCongres
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "AiMHomeViewController.h"
#import "AiMMapaViewController.h"
#import "AiMSeccionViewController.h"
#import "AiMAboutViewController.h"
#import "AiMVistaPerlaDetalleViewController.h"


@interface AiMSideViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, assign) MFSideMenu                *sideMenu;
@property (nonatomic, strong) NSArray                   *IconoList;
@property (nonatomic ,strong) NSArray                   *MenuList;
@property (nonatomic ,strong) AiMHomeViewController     *VistaHome;
@property (nonatomic ,strong) AiMMapaViewController     *VistaMapa;
@property (nonatomic ,strong) AiMSeccionViewController  *VistaPrimeraSesion;
@property (nonatomic ,strong) AiMSeccionViewController  *VistaSegundaSesion;
@property (nonatomic ,strong) AiMSeccionViewController  *VistaTerceraSesion;
@property (nonatomic ,strong) AiMSeccionViewController  *VistaCuartaSesion;
@property (nonatomic, strong) AiMAboutViewController    *About;

- (IBAction)EventoDetallePerla:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextView *TextViewPerla;


@end

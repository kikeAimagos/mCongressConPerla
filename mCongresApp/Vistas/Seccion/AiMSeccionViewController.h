//
//  AiMSeccionViewController.h
//  mCongres
//
//  Created by luis Gonzalez on 01-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AiMCell.h"
#import "Congreso.h"
#import "iCarousel.h"
#import "GAITrackedViewController.h"


@class iCarousel;

@interface AiMSeccionViewController : GAITrackedViewController<iCarouselDataSource,iCarouselDelegate,
UITableViewDataSource,UITableViewDelegate >


@property (assign, nonatomic) IBOutlet AiMCell *customCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet iCarousel *VistaCarouselSesion;

@property(nonatomic)int CantidadDeTargetasCarousel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *managerDelObjetoEnCOntexto;
@property (nonatomic, strong) NSManagedObjectContext *managerDeObjetosUsuarios;

@property (nonatomic, strong) NSString *identificadorPaLaEntity;

@property (nonatomic, strong) NSArray *arraySesion1;
@property (nonatomic, strong) NSArray *arraySesion2;
@property (nonatomic, strong) NSArray *arraySesion3;
@property (nonatomic, strong) NSArray *arraySesion4;
@property (nonatomic, strong) NSArray *arrayTotalSesiones;


- (IBAction)EventoSeleccionVistaDetalle:(UIButton *)sender;

- (IBAction)EventoPerlaDetalle:(UIButton *)sender;



@end

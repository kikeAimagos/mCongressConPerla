//
//  AiMDetalleViewController.h
//  mCongres
//

//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AiMVariablesGlobales.h"
#import "GAITrackedViewController.h"
#import "DetalleCell.h"

@interface AiMDetalleViewController : GAITrackedViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) IBOutlet DetalleCell *customCell;
@property (strong, nonatomic) AiMDetalleViewController *viewController;
@property (strong, nonatomic) IBOutlet UILabel *labelPico;
@property (strong, nonatomic) NSManagedObjectID *adminObjetoId;
@property (strong, nonatomic) IBOutlet UIImageView *imagen;
@property (strong, nonatomic) IBOutlet UITableView *tablaVieDetalle;

@end

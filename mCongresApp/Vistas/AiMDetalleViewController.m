//
//  AiMDetalleViewController.m
//  mCongres
//
//  Copyright (c) 2013 Aimagos. All rights reserved.
//
#import "Congreso.h"
#import "Perlazo.h"
#import "MFSideMenu.h"
#import "DetalleCell.h"
#import "PBMecaniSync.h"
#import "PBDuenasCoreData.h"
#import "AiMHomeViewController.h"
#import "AiMDetalleViewController.h"
#import "AiMSeccionViewController.h"
#import "AiMVistaPerlaDetalleViewController.h"






enum AIMtipoDato {
    AIMDatosCongreso
};

//typedef enum {
//    Detalle = 0,
//    DetalleUno = 1,
//    DetalleDos = 2,
//    DetalleTres = 3,
//    DetalleCuatro = 4
//} AimCongresoCell;

@interface AiMDetalleViewController ()

@property (nonatomic,strong) NSManagedObject *managerObjeto;
@property (nonatomic, strong) NSManagedObjectContext *contexto;
@property(nonatomic,strong)NSManagedObjectContext *cagado;
@property (nonatomic,strong) NSString *nombreDeLaEntity;
@property(nonatomic,strong) NSArray *array;
@property (nonatomic,strong) IBOutlet UITextView *textoPaLaheua;


@property enum AIMtipoDato tipoDato;

@end

@implementation AiMDetalleViewController
@synthesize  labelPico;
@synthesize adminObjetoId;
@synthesize tablaVieDetalle;
@synthesize imagen;
@synthesize managerObjeto;
@synthesize contexto;
@synthesize tipoDato;
@synthesize customCell,textoPaLaheua,nombreDeLaEntity,array,cagado;


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
    
    self.contexto = [[PBDuenasCoreData sharedInstance] newManagedObjectContext];
    self.cagado = [[PBDuenasCoreData sharedInstance] newManagedObjectContext];
    self.managerObjeto = [contexto objectWithID:self.adminObjetoId];
    [self cargardatoscoredataperla];
    [self pencaToDie];
    [[PBMecaniSync sharedEngine] startSync];
    [self.navigationController.sideMenu setupSideMenuBarButtonItem];
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    self.trackedViewName = [Variables.UserNameSave stringByAppendingFormat: @" Detalle Charla"];
    labelPico.text = [[NSString alloc]
					  initWithFormat:@" detalle charla %d de la sesion %d",
					  Variables.TargetaCharlaSelecionada, Variables.SesionSelecionada ];
}

- (void)cargardatoscoredataperla {
    self.cagado = [[PBDuenasCoreData sharedInstance]
									   newManagedObjectContext];
    [self.cagado performBlockAndWait:^{
        [self.cagado reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc]
								   initWithEntityName:self.nombreDeLaEntity];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor
									  sortDescriptorWithKey:@"createdAt" ascending:NO]]];
        [request setPredicate:[NSPredicate
							   predicateWithFormat:@"syncStatus != %d", PBObjectDeleted]];
        self.array = [self.cagado executeFetchRequest:request error:&error];
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)pencaToDie {

    if ([self.nombreDeLaEntity isEqualToString:@"Perlazo"]) {
        Perlazo *perla = [self.array lastObject];
        self.textoPaLaheua.text = perla.perlazoSync;
        
    }


}


- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   	
	
	static NSString *simpleTableIdentifier = @"CeldaDetalle";
	
    DetalleCell *cell = (DetalleCell *)[tableView
										dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
		{
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"celdaDetalle" owner:self
												   options:nil];
        cell = [nib objectAtIndex:0];
		}
    Congreso *congreso = (Congreso *)self.managerObjeto;
	
	cell.detalle4.text = congreso.detalle4Exposicion;
    cell.nombreExp.text = congreso.nombreExpositor;
	cell.fechaExp.text = congreso.fechaHoraConferencia;
    cell.detalle1.text = congreso.detalle1Exposicion;
	cell.detalle2.text = congreso.detalle2Exposicion;
	cell.detalle3.text = congreso.detalle3Exposicion;
	cell.titulopresentacion.text = congreso.tituloExposicion;
	cell.compania.text = congreso.empresaExpositor;
	
	if (congreso.fotografiaExpositor != nil) {
        UIImage *image = [UIImage imageWithData:congreso.fotografiaExpositor];
        cell.imagen.image = image;
    }     return cell;
	}

	
	
	
	
	
	
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger )tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (IBAction)EventoPerlaDetalle:(UIButton *)sender {
    
    AiMVistaPerlaDetalleViewController *DetallePerla = [[AiMVistaPerlaDetalleViewController alloc]
														initWithNibName:@"AiMVistaPerlaDetalleViewController"
														bundle:Nil];
    [self.navigationController pushViewController:DetallePerla animated:YES];
}

#pragma -mark Rotacion Pantalla
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    
    return NO;
}

@end
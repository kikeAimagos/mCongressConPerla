//
//  AiMHomeViewController.m
//  mCongres
//
//  Copyright (c) 2013 Aimagos. All rights reserved.
//


#import "GAI.h"
#import "AiMCell.h"
#import "Perlazo.h"
#import "Regiztro.h"
#import "Congreso.h"
#import "MFSideMenu.h"
#import "PBMecaniSync.h"
#import "PBDuenasCoreData.h"
#import "AiMVariablesGlobales.h"
#import "AiMHomeViewController.h"
#import "AiMDetalleViewController.h"
#import "AiMDetalleViewController.h"
#import "AiMVistaPerlaDetalleViewController.h"

@interface AiMHomeViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation AiMHomeViewController;




@synthesize items;
@synthesize perlaTexto;

@synthesize arrayConferencias;
@synthesize arrayPerlas;
@synthesize arrayUsuarios;
@synthesize stringPaLaEntity;
@synthesize nombreDelaEntity;
@synthesize managedObjectContext;

@synthesize identificadorPaLaEntity; //congreso

@synthesize customCell;
@synthesize numeroTarjetas;
@synthesize actualizar;  //boton actualizar
@synthesize tableView =_tableView;
@synthesize managerDelObjetoEnCOntexto;

@synthesize manejadorDeObjetosRegistro;
@synthesize fotografiaExpositorEEM; //en este momento
@synthesize nombreExpositorEEM;   //en este momento
@synthesize tituloConferenciaEEM;   //en este momento
@synthesize fechaHoraEEM;   //en este momento
//@synthesize spiner; //indicador avance
@synthesize NombreSignIn;
@synthesize EmailSignIn;
@synthesize SignInView;
@synthesize spiner;
@synthesize spinerlogin;
@synthesize arrayTotalSesiones;


#pragma -mark Viewdidload
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PBMecaniSync sharedEngine] startSync];
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    NSString *nombreVista = [Variables.UserNameSave stringByAppendingFormat: @" Home"];
    self.trackedViewName = nombreVista;
    [self.navigationController.sideMenu setupSideMenuBarButtonItem];
	[spiner startAnimating];
	[spinerlogin startAnimating];
    [self sincronizadorPerlas];
	//self.managerDeObjetosUsuarios = [[PBDuenasCoreData sharedInstance]
//									 newManagedObjectContext];
//	self.managerDelObjetoEnCOntexto = [[PBDuenasCoreData sharedInstance]
//									 								 newManagedObjectContext];
//	[self loadRecordsFromCoreData];
	[self performSelector:@selector(doStuff:) withObject:self afterDelay:4.5];
	[self performSelector:@selector(doStuffo:) withObject:self afterDelay:4.5];
		// I do this because I'm in landscape mode
	[self.view addSubview:spiner];
	CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    spiner.transform = transform;
	
	   
}
-(void) doStuff:(id)aSender
{
    [spiner stopAnimating];
}
-(void) doStuffo:(id)aSender
{
    [spinerlogin stopAnimating];
}
#pragma mark -viewDidAppear

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    [self sincronizadorPerlas];
    [self.view addSubview:SignInView];
    [self checkSyncStatus];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted" object:nil
	 queue:nil usingBlock:^(NSNotification *note) {
         [self loadRecordsFromCoreData];
         [self.tableView reloadData];
                  
     }];
    [[PBMecaniSync sharedEngine] addObserver:self forKeyPath:@"syncInProgress"
                                     options:NSKeyValueObservingOptionNew context:nil];
    [[PBMecaniSync sharedEngine] startSync];

}




#pragma mark -metodos core data
- (void)loadRecordsFromCoreData {
    
    self.managedObjectContext = [[PBDuenasCoreData sharedInstance]
                                 newManagedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *identificadorPaLaEntity = [NSEntityDescription entityForName:@"Congreso"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:identificadorPaLaEntity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"fechaHoraComparar"
                                        ascending:YES];
	arrayConferencias = @[sortDescriptor];
	[fetchRequest setSortDescriptors:arrayConferencias];
	
	NSError *errorArrayConferencias;
	self.arrayConferencias = [context executeFetchRequest:fetchRequest
													 error:&errorArrayConferencias];
    
    }
    
- (void)cargardatoscoredataperla {
    self.managerDelObjetoEnCOntexto = [[PBDuenasCoreData sharedInstance]
									   newManagedObjectContext];
    [self.managedObjectContext performBlockAndWait:^{
        [self.managedObjectContext reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc]
								   initWithEntityName:self.nombreDelaEntity];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor
									  sortDescriptorWithKey:@"createdAt" ascending:YES]]];
        [request setPredicate:[NSPredicate
							   predicateWithFormat:@"syncStatus != %d", PBObjectDeleted]];
        self.arrayPerlas = [self.managedObjectContext executeFetchRequest:request error:&error];
    }];
}

- (void)cargardatoscoredatausuarios {
    self.managerDeObjetosUsuarios = [[PBDuenasCoreData sharedInstance]
									 newManagedObjectContext];

    [self.managerDeObjetosUsuarios performBlockAndWait:^{
        [self.managerDeObjetosUsuarios reset];
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc]
								   initWithEntityName:self.stringPaLaEntity];
        [request setSortDescriptors:[NSArray arrayWithObject:
                                     [NSSortDescriptor
									  sortDescriptorWithKey:@"createdAt" ascending:YES]]];
        [request setPredicate:[NSPredicate
							   predicateWithFormat:@"syncStatus != %d", PBObjectDeleted]];
        self.arrayUsuarios = [self.managerDeObjetosUsuarios
							  executeFetchRequest:request error:&error];
    }];
}

//nuevo Arturo
-(void)sincronizadorPerlas
{
    if ([self.nombreDelaEntity isEqualToString:@"Perlazo"]) {
        Perlazo *perlaNueva = [self.arrayUsuarios lastObject];
        self.perlaTexto.text = perlaNueva.perlazoSync;
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker sendEventWithCategory:@"Actividad"
                            withAction:@"buttonPress"
                             withLabel:@"Recive Perla"
                             withValue:nil];
    }
}




- (void)checkSyncStatus {
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}
- (IBAction)actualizarCuandoTocoElBotonMaricon:(id)sender {
    
    [[PBMecaniSync sharedEngine] startSync];
    [self sincronizadorPerlas];
}
- (IBAction)EventoPerlaDetalle:(UIButton *)sender {
    
    AiMVistaPerlaDetalleViewController *DetallePerla = [[AiMVistaPerlaDetalleViewController alloc]initWithNibName:@"AiMVistaPerlaDetalleViewController" bundle:Nil];
    [self.navigationController pushViewController:DetallePerla animated:YES];

}
#pragma mark -tabla y celda

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayConferencias count]  ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	static NSString *simpleTableIdentifier = @"CustomCellIdentifier";
	
    AiMCell *cell = (AiMCell *)[tableView dequeueReusableCellWithIdentifier:
								simpleTableIdentifier];
    
	if (cell == nil) {
		
        NSArray *nib = [[NSBundle mainBundle]
						loadNibNamed:@"AiMCell" owner:self
						options:nil];
        cell = [nib objectAtIndex:0];
	}

	[self loadRecordsFromCoreData];
	
    
	self.managedObjectContext = [[PBDuenasCoreData sharedInstance]
                                 newManagedObjectContext];
    NSManagedObjectContext *context = [self managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *identificadorPaLaEntity = [NSEntityDescription entityForName:@"Congreso"
															   inManagedObjectContext:context];
	[fetchRequest setEntity:identificadorPaLaEntity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"fechaHoraComparar"
                                        ascending:YES];
	arrayConferencias = @[sortDescriptor];
	[fetchRequest setSortDescriptors:arrayConferencias];
	
	NSError *errorArrayConferencias;
	self.arrayConferencias = [context executeFetchRequest:fetchRequest
													error:&errorArrayConferencias];
	Congreso *congreso = [self.arrayConferencias
						  objectAtIndex:indexPath.row];
    
    cell.nombreExpositor.text = congreso.nombreExpositor;
	cell.fecha.text = congreso.fechaHoraConferencia;
    cell.detalleX.text = congreso.tituloExposicion;
	if (congreso.fotografiaExpositor != nil) {
        UIImage *image = [UIImage imageWithData:congreso.fotografiaExpositor];
        cell.fotoExpositor.image = image;
    }
        
        
        
	return cell;

}

  //  }
/*este es el que hace toda la huea pa detalle, al menos en home view*/
        - (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell){
        AiMDetalleViewController *detailViewController = [[AiMDetalleViewController alloc] initWithNibName:@"AiMDetalleViewController" bundle:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Congreso *congreso = [self.arrayConferencias objectAtIndex:indexPath.row];
        detailViewController.adminObjetoId = congreso.objectID;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
	
}

- (IBAction)AccionPerlaDetalle:(UIButton *)sender{
	
}

#pragma -mark Metodos y variables para el SignIn
#pragma -mark Validacion de datos

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -sing in


- (IBAction)DetalleConferencia:(UIButton *)sender {
    AiMDetalleViewController *DetalleSpeaker = [[AiMDetalleViewController alloc]
												initWithNibName:@"AiMDetalleViewController" bundle:nil];
    AiMCell *cell = (AiMCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Congreso *congreso = [self.arrayConferencias objectAtIndex:indexPath.row];
    DetalleSpeaker.adminObjetoId = congreso.objectID;
    [self.navigationController pushViewController:DetalleSpeaker animated:YES];
}



- (void)viewDidUnload
{
	[self setActualizar:nil];
	[self setSpiner:nil];
	[self setSpinerlogin:nil];
	[super viewDidUnload];
}

- (IBAction)actualizar:(id)sender {
	[self loadRecordsFromCoreData];
	[self.tableView reloadData];
}
@end

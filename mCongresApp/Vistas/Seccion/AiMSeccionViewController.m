//
//  AiMSeccionViewController.m
//  mCongres
//
//  Created by luis Gonzalez on 01-03-13.
//  Copyright (c) 2013 Aimagos. All rights reserved.
//

#import "AiMCell.h"
#import "Congreso.h"
#import "MFSideMenu.h"
#import "PBMecaniSync.h"
#import "PBDuenasCoreData.h"
#import "AiMVariablesGlobales.h"
#import "AiMSeccionViewController.h"
#import "AiMDetalleViewController.h"
#import "AiMVistaPerlaDetalleViewController.h"

@interface AiMSeccionViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation AiMSeccionViewController

@synthesize VistaCarouselSesion; //no esta en uso = hay que dejarla
@synthesize CantidadDeTargetasCarousel; //no esta en uso
@synthesize customCell;  //celda adaptada
@synthesize tableView =_tableView;  //tabla adaptada
@synthesize managerDelObjetoEnCOntexto;   //igual al home
@synthesize identificadorPaLaEntity; //identificador que no me sirvio
@synthesize arraySesion1;  
@synthesize arraySesion2;
@synthesize arraySesion3;
@synthesize arraySesion4;
@synthesize arrayTotalSesiones;   //array ordenado por idConferencia
@synthesize managedObjectContext;   //igual al home
@synthesize managerDeObjetosUsuarios;   //igual al home



#pragma mark-viewDidLoad

- (void)viewDidLoad {
    
    [super viewDidLoad];
	self.managedObjectContext = [[PBDuenasCoreData sharedInstance]
									 newManagedObjectContext];
	
    self.managerDelObjetoEnCOntexto = [[PBDuenasCoreData sharedInstance]
									   newManagedObjectContext];
	
    self.managerDeObjetosUsuarios = [[PBDuenasCoreData sharedInstance]
									 newManagedObjectContext];
	
	[[PBMecaniSync sharedEngine] startSync];
	[self loadRecordsFromCoreData];
	
	self.tableView.rowHeight = 90;
    [self.navigationController.sideMenu setupSideMenuBarButtonItem];
    [VistaCarouselSesion setVertical:YES];
    CGSize offset = CGSizeMake(0.0f,-138);
    VistaCarouselSesion.contentOffset = offset;

    AiMVariablesGlobales *Variables =[AiMVariablesGlobales VariablesSingletonObject];
	
    NSString *nombreVista = [Variables.UserNameSave
							 stringByAppendingFormat: @" Sesión "];
	
    nombreVista = [nombreVista stringByAppendingFormat:
				   [NSString stringWithFormat:@"%d",
					(int*)Variables.SesionSelecionada]];

    self.trackedViewName = nombreVista;

}

#pragma mark-viewDidAppear


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkSyncStatus];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"SDSyncEngineSyncCompleted"
													  object:nil queue:nil
												  usingBlock:^(NSNotification *note) {
	[self loadRecordsFromCoreData];
	[self.tableView reloadData];
    
												  }
	 ];
    [[PBMecaniSync sharedEngine] addObserver:self
								  forKeyPath:@"syncInProgress"
									 options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark -core data y parse

- (void)checkSyncStatus {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object change:(NSDictionary *)change
					   context:(void *)context
{
    if ([keyPath isEqualToString:@"syncInProgress"]) {
        [self checkSyncStatus];
    }
}


#pragma mark -core data

- (void)loadRecordsFromCoreData {
	NSString *sesion1 = @"sesion1";
	NSString *sesion2 = @"sesion2";
	NSString *sesion3 = @"sesion3";
	NSString *sesion4 = @"sesion4";
	
	NSManagedObjectContext *context = [self managerDelObjetoEnCOntexto];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Congreso"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"fechaHoraComparar"
																   ascending:YES];
	arrayTotalSesiones = @[sortDescriptor];
	[fetchRequest setSortDescriptors:arrayTotalSesiones];
	
	NSError *errorArrayTotalSesiones;
	self.arrayTotalSesiones = [context executeFetchRequest:fetchRequest
													 error:&errorArrayTotalSesiones];
	if (arrayTotalSesiones == nil) {
	}
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:
							  @"sesionexposicion == %@", sesion1];
	
	NSPredicate *predicateSesion2 = [NSPredicate predicateWithFormat:
							  @"sesionexposicion == %@", sesion2];
	
	NSPredicate *predicateSesion3 = [NSPredicate predicateWithFormat:
									 @"sesionexposicion == %@", sesion3];
	
	NSPredicate *predicateSesion4 = [NSPredicate predicateWithFormat:
									 @"sesionexposicion == %@", sesion4];
	 
	
	[fetchRequest setPredicate:predicate];
	NSError *error;
	self.arraySesion1 = [context executeFetchRequest:fetchRequest error:&error];
	if (arraySesion1 == nil) {
			
	}
	[fetchRequest setPredicate:predicateSesion2];
	NSError *errorArraySesion2;
	self.arraySesion2 = [context executeFetchRequest:fetchRequest
											   error:&errorArraySesion2];
	if (arraySesion2 == nil) {
			
	}
	[fetchRequest setPredicate:predicateSesion3];
	NSError *errorArraySesion3;
	self.arraySesion3 = [context executeFetchRequest:fetchRequest
											   error:&errorArraySesion3];
	if (arraySesion3 == nil) {
			
	}
	[fetchRequest setPredicate:predicateSesion4];
	NSError *errorArraySesion4;
	self.arraySesion4 = [context executeFetchRequest:fetchRequest
											   error:&errorArraySesion4];
	if (arraySesion4 == nil) {
			
	}
}

#pragma mark -numberOfSectionsInTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
	}

#pragma mark -tableView numberOfRowsInSection

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
	
	AiMVariablesGlobales *Variables = [AiMVariablesGlobales
									   VariablesSingletonObject];
	
	if (Variables.SesionSelecionada == (int*)1){
		return 11;
	}
		else if (Variables.SesionSelecionada == (int*)2){
			return 6;
		}
			else if (Variables.SesionSelecionada == (int*)3) {
				return 10;
			}
				else  {
					return 8;
				}
	}

#pragma mark -tableView cellForRowAtIndexPath

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	AiMVariablesGlobales *Variables = [AiMVariablesGlobales
									   VariablesSingletonObject];
	
	static NSString *simpleTableIdentifier = @"CustomCellIdentifier";
	
    AiMCell *cell = (AiMCell *)[tableView dequeueReusableCellWithIdentifier:
								simpleTableIdentifier];
    
	if (cell == nil) {
		
        NSArray *nib = [[NSBundle mainBundle]
						loadNibNamed:@"AiMCell" owner:self
												   options:nil];
        cell = [nib objectAtIndex:0];
	}
		if (Variables.SesionSelecionada == (int*)1){
		
			Congreso *congreso = [self.arraySesion1
								  objectAtIndex:indexPath.row];
						
			cell.nombreExpositor.text = congreso.nombreExpositor;
			cell.fecha.text = congreso.fechaHoraConferencia;
			cell.detalleX.text = congreso.tituloExposicion;
			if (congreso.fotografiaExpositor != nil) {
				UIImage *image = [UIImage
								  imageWithData:congreso.fotografiaExpositor];
				cell.fotoExpositor.image = image;
			}
			return cell;
		}

			else if (Variables.SesionSelecionada == (int*)2) {
				
			
				Congreso *congreso2 = [self.arraySesion2
									   objectAtIndex:indexPath.row];
				
				
				cell.nombreExpositor.text = congreso2.nombreExpositor;
				cell.fecha.text = congreso2.fechaHoraConferencia;
				cell.detalleX.text = congreso2.tituloExposicion;
				if (congreso2.fotografiaExpositor != nil) {
					UIImage *image = [UIImage
									  imageWithData:congreso2.fotografiaExpositor];
					cell.fotoExpositor.image = image;
				}    return cell;
			}

					else if (Variables.SesionSelecionada == (int*)3) {
						
						Congreso *congreso3 = [self.arraySesion3 objectAtIndex:indexPath.row];
						
						cell.nombreExpositor.text = congreso3.nombreExpositor;
						cell.fecha.text = congreso3.fechaHoraConferencia;
						cell.detalleX.text = congreso3.tituloExposicion;
						if (congreso3.fotografiaExpositor != nil) {
							UIImage *image = [UIImage
											  imageWithData:congreso3.fotografiaExpositor];
							cell.fotoExpositor.image = image;
						}
						return cell;
					}
						else if (Variables.SesionSelecionada == (int*)4) {
							
							Congreso *congreso4 = [self.arraySesion4 objectAtIndex:
												   indexPath.row];
							
							cell.nombreExpositor.text = congreso4.nombreExpositor;
							cell.fecha.text = congreso4.fechaHoraConferencia;
							cell.detalleX.text = congreso4.tituloExposicion;
							if (congreso4.fotografiaExpositor != nil) {
								UIImage *image = [UIImage
												  imageWithData:congreso4.fotografiaExpositor];
								cell.fotoExpositor.image = image;
							}
						}
							return cell;
	}


#pragma mark -
#pragma mark iCarousel methods


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
	return NO;}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
		 reusingView:(UIView *)view{
	return NO;}
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{}


- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option
		withDefault:(CGFloat)value {
 	return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
	AiMVariablesGlobales *Variables = [AiMVariablesGlobales
									   VariablesSingletonObject];
    if(cell){
        AiMDetalleViewController *detailViewController = [[AiMDetalleViewController alloc] initWithNibName:@"AiMDetalleViewController" bundle:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        if (Variables.SesionSelecionada == (int*)1){
			Congreso *congreso = [self.arraySesion1 objectAtIndex:indexPath.row];
			detailViewController.adminObjetoId = congreso.objectID;
			[self.navigationController pushViewController:detailViewController animated:YES];

		}
		else if (Variables.SesionSelecionada == (int*)2){
			Congreso *congreso = [self.arraySesion2 objectAtIndex:indexPath.row];
			detailViewController.adminObjetoId = congreso.objectID;
			[self.navigationController pushViewController:detailViewController animated:YES];

		}
		else if (Variables.SesionSelecionada == (int*)3) {
			Congreso *congreso = [self.arraySesion3 objectAtIndex:indexPath.row];
			detailViewController.adminObjetoId = congreso.objectID;
			[self.navigationController pushViewController:detailViewController animated:YES];

		}
		else  {
			Congreso *congreso = [self.arraySesion4 objectAtIndex:indexPath.row];
			detailViewController.adminObjetoId = congreso.objectID;
			[self.navigationController pushViewController:detailViewController animated:YES];

		}

		
    }
	
}
- (IBAction)EventoSeleccionVistaDetalle:(UIButton *)sender {
    
    AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
    NSInteger index = [VistaCarouselSesion indexOfItemViewOrSubview:sender];
    Variables.TargetaCharlaSelecionada = (int*)index;

    AiMDetalleViewController *demoController = [[AiMDetalleViewController alloc]
                                                initWithNibName:@"AiMDetalleViewController"
                                                bundle:nil];
    
    [self.navigationController pushViewController:demoController animated:YES];

}

- (IBAction)EventoPerlaDetalle:(UIButton *)sender {
    
    AiMVistaPerlaDetalleViewController *DetallePerla = [[AiMVistaPerlaDetalleViewController alloc]initWithNibName:@"AiMVistaPerlaDetalleViewController" bundle:Nil];
    [self.navigationController pushViewController:DetallePerla animated:YES];
}

#pragma mark-viewDidUnload
- (void)viewDidUnload {
	
    [super viewDidUnload];
    self.VistaCarouselSesion = nil;
    }

@end

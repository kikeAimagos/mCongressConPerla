//
//  AiMSideViewController.m
//  mCongres
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import "AiMSideViewController.h"
#import "AiMVariablesGlobales.h"


@interface AiMSideViewController ()

@end

@implementation AiMSideViewController

@synthesize MenuList, VistaHome, IconoList;
@synthesize VistaMapa,VistaPrimeraSesion,VistaSegundaSesion,VistaTerceraSesion,VistaCuartaSesion,About;


- (void) viewDidLoad {
    [super viewDidLoad]; 
    MenuList =
	[[NSArray alloc]initWithObjects:@"Home", @"Primera Sesión",
	 @"Segunda Sesión",@"Tercera Sesión", @"Cuarta Sesión", @"Mapa 6ta Planta",@"About", nil ];
    
	IconoList =
	[[NSArray alloc]initWithObjects:@"home.png", @"sesion1.png",
	 @"sesion2.png", @"sesion3.png", @"sesion4.png", @"mapa.png", @"about.png", nil];
    
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return [NSString stringWithFormat:@"Columna %d ", section];
 }*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	
    return [MenuList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
							 CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"ArialMT" size:14];
    cell.textLabel.text = [MenuList objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:[IconoList
												objectAtIndex:indexPath.row]];

    return cell;
}



#pragma -mark- Altura tableview
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        VistaHome = [[AiMHomeViewController alloc]
					 initWithNibName:@"AiMHomeViewController" bundle:Nil];
		
        VistaHome.title = [MenuList objectAtIndex:indexPath.row];
        NSArray *controlador = [NSArray arrayWithObject:VistaHome];
        self.sideMenu.navigationController.viewControllers = controlador;

    }
		else if (indexPath.row == 5)
		{
			VistaMapa= [[AiMMapaViewController alloc]
						initWithNibName:@"AiMMapaViewController" bundle:Nil];
			VistaMapa.title = [MenuList objectAtIndex:indexPath.row];
			NSArray *controlador = [NSArray arrayWithObject:VistaMapa];
			self.sideMenu.navigationController.viewControllers = controlador;
		}
			else if (indexPath.row == 1)
			{
				
				VistaPrimeraSesion= [[AiMSeccionViewController alloc]
									 initWithNibName:@"AiMSeccionViewController" bundle:Nil];
				VistaPrimeraSesion.title = [MenuList objectAtIndex:indexPath.row];
				NSArray *controlador = [NSArray arrayWithObject:VistaPrimeraSesion];
				self.sideMenu.navigationController.viewControllers = controlador;
				
				/* Indicamos la Sesion Selecionada */
				
				AiMVariablesGlobales *Variables = [AiMVariablesGlobales
												   VariablesSingletonObject];
				Variables.SesionSelecionada = (int *)1;
				
			}
				else if (indexPath.row == 2)
				{
				   
					VistaSegundaSesion = [[AiMSeccionViewController alloc]
										  initWithNibName:@"AiMSeccionViewController" bundle:Nil];
					VistaSegundaSesion.title = [MenuList objectAtIndex:indexPath.row];
					NSArray *controlador = [NSArray arrayWithObject:VistaSegundaSesion];
					self.sideMenu.navigationController.viewControllers = controlador;
					
					/* Indicamos la Sesion Selecionada */
					
					AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
					Variables.SesionSelecionada = (int*)2;

					
				}
					else if (indexPath.row == 3)
					{
						
						VistaTerceraSesion = [[AiMSeccionViewController alloc]
											  initWithNibName:@"AiMSeccionViewController" bundle:Nil];
						VistaTerceraSesion.title = [MenuList objectAtIndex:indexPath.row];
						NSArray *controlador = [NSArray arrayWithObject:VistaTerceraSesion];
						self.sideMenu.navigationController.viewControllers = controlador;
						
						/* Indicamos la Sesion Selecionada */
						
						AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
						Variables.SesionSelecionada = (int*)3;
						   
					}
						else if (indexPath.row == 4)
						{
							
							VistaCuartaSesion = [[AiMSeccionViewController alloc]
												 initWithNibName:@"AiMSeccionViewController" bundle:Nil];
							VistaCuartaSesion.title = [MenuList objectAtIndex:indexPath.row];
							NSArray *controlador = [NSArray arrayWithObject:VistaCuartaSesion];
							self.sideMenu.navigationController.viewControllers = controlador;
							
							/* Indicamos la Sesion Selecionada */
							
							AiMVariablesGlobales *Variables = [AiMVariablesGlobales VariablesSingletonObject];
							Variables.SesionSelecionada = (int*)4;
							
						}


								else if (indexPath.row == 6)
								{
									About= [[AiMAboutViewController alloc]
											initWithNibName:@"AiMAboutViewController" bundle:Nil];
									About.title = [MenuList objectAtIndex:indexPath.row];
									NSArray *controlador = [NSArray arrayWithObject:About];
									self.sideMenu.navigationController.viewControllers = controlador;

								}
								   [self.sideMenu setMenuState:MFSideMenuStateHidden];
							}

- (IBAction)EventoDetallePerla:(UIButton *)sender {
    
    
    AiMVistaPerlaDetalleViewController *DetallePerla = [[AiMVistaPerlaDetalleViewController alloc]initWithNibName:@"AiMVistaPerlaDetalleViewController" bundle:Nil];
    
   
    NSArray *controlador = [NSArray arrayWithObject:DetallePerla];
    self.sideMenu.navigationController.viewControllers = controlador;
    [self.sideMenu setMenuState:MFSideMenuStateHidden];
    
}
@end

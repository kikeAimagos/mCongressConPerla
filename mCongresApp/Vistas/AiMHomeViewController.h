//
//  AiMHomeViewController.h
//  mCongres
//
//  Created by luis Gonzalez on 28-02-13.
//  Copyright (c) 2013 luis Gonzalez. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AiMCell.h"
#import "iCarousel.h"
#import "MFSideMenu.h"
#import "GAITrackedViewController.h"
#import "AiMVistaPerlaDetalleViewController.h"



@interface AiMHomeViewController :  GAITrackedViewController<iCarouselDataSource, iCarouselDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITextField *EmailSignIn;
    UITextField *NombreSignIn;
}

@property (assign, nonatomic) IBOutlet AiMCell *customCell;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


/* Labels de los titulos , no cambiara su texto, pero se instancian para poder customisarlos */
@property (nonatomic, assign) MFSideMenu *sideMenu;
@property (nonatomic, strong) NSManagedObject *manejadorDeObjetosRegistro;
@property (nonatomic, strong) NSArray *arrayConferencias;
@property (nonatomic, strong) NSArray *arrayPerlas;
@property (nonatomic, strong) NSArray *arrayTotalSesiones;
@property (nonatomic, strong) NSArray *arrayUsuarios;
@property (nonatomic, strong) NSString *nombreDelaEntity;
@property (nonatomic, strong) NSString *stringPaLaEntity;
@property (nonatomic, strong) NSString *identificadorPaLaEntity;
@property (strong, nonatomic) IBOutlet UITextView *perlaTexto;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectContext *managerDelObjetoEnCOntexto;
@property (nonatomic, strong) NSManagedObjectContext *managerDeObjetosUsuarios;
- (IBAction)actualizar:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinerlogin;

@property (weak, nonatomic) IBOutlet UIButton *actualizar;
@property(nonatomic)int numeroTarjetas;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spiner;

- (IBAction)saveButtonTouched:(id)sender;
- (IBAction)actualizarCuandoTocoElBotonMaricon:(id)sender;



/* textView y labels que deben sincronizarce para el Inthis Moment */



@property (strong, nonatomic) IBOutlet UIImageView *fotografiaExpositorEEM;
@property (strong, nonatomic) IBOutlet UITextView *tituloConferenciaEEM;
@property (strong, nonatomic) IBOutlet UILabel *fechaHoraEEM;
@property (strong, nonatomic) IBOutlet UILabel *nombreExpositorEEM;
/*implementacion de Icarousel */


/* text Field Perla */



/* Presentacion del detalle de infromacion */

- (IBAction)DetalleConferencia:(UIButton *)sender;

#pragma -mark Sign In

/*  Metodos para el Sign In de los usuarios su funcionamiento consta de
    evaluar una variable de tipo booleana  que  indicara si sus datos 
    an sido ingresado o no */


@property (strong, nonatomic) IBOutlet UITextField *NombreSignIn;
@property (strong, nonatomic) IBOutlet UITextField *EmailSignIn;
/* Sign In boton evento */
#pragma -mark SigIn
- (IBAction)AccionSignIn:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *HomeView;


#pragma -mark VistaPerlasDetalle
- (IBAction)AccionPerlaDetalle:(UIButton *)sender;


@property (strong, nonatomic) IBOutlet UIView *SignInView;
@property (strong, nonatomic) IBOutlet UIView *Homview;

@end

//
//  EscaneoProductoViewController.m
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/5/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "EscaneoProductoViewController.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "EscanerCodigoBarrasController.h"
#import "AgregarProductoViewController.h"
#import "AppDelegate.h"

NSString *const kEscaneoProductoAgregarSegue = @"BuscarProductoAgregarSegue";

@interface EscaneoProductoViewController ()

@property (weak, nonatomic) IBOutlet EscanerCodigoBarras *escanerCodigoBarras;
@property Producto *producto;
@property BOOL productoEncontrado;

- (IBAction)mostrarMenu:(id)sender;

@end

@implementation EscaneoProductoViewController

@synthesize escanerCodigoBarras = _escanerCodigoBarras;
@synthesize producto = _producto;


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.escanerCodigoBarras setDelegate:self];
    [self.escanerCodigoBarras crearEscanerConTexto:
     @"Apunte la cámara a un código de barras para insertar un producto"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _productoEncontrado = NO;
    [self.escanerCodigoBarras iniciarEscaner];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.escanerCodigoBarras detenerEscaner];
}


- (IBAction)mostrarMenu:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) mostrarMenuLateral];
}

- (void)codigoEncontrado:(NSString *)codigo {
    [self.escanerCodigoBarras detenerEscaner];
    NSLog(@"Código de barras %@", codigo);
    NSURLSessionTask *buscarProductoTask =
    [EscanerCodigoBarrasController buscarPorCodigoBarras:codigo
                                           estaAgregando:YES
                                               withBlock:^(Producto *resultado, NSError *error)
     {
         if (!error) {
             if (!_productoEncontrado) {
                 _productoEncontrado = YES;
                 _producto = resultado;
                 [self performSegueWithIdentifier:kEscaneoProductoAgregarSegue
                                           sender:self];
             }
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message:error.description delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
    
    if (!buscarProductoTask) {
        [self.escanerCodigoBarras iniciarEscaner];
    }
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:buscarProductoTask
                                                  delegate:nil];
    
    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)self.navigationItem.rightBarButtonItem.customView;
    [activityIndicatorView setAnimatingWithStateOfTask:buscarProductoTask];
}


#pragma mark - Navigacion


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:kEscaneoProductoAgregarSegue]) {
        AgregarProductoViewController *agregarProducto =
        (AgregarProductoViewController *)segue.destinationViewController;
        agregarProducto.producto = _producto;
    }
}

@end

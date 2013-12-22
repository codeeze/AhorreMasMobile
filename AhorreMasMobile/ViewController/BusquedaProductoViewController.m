//
//  ViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 11/26/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "BusquedaProductoViewController.h"
#import "AppDelegate.h"
#import "EscanerCodigoBarrasController.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "BuscarProductos.h"
#import "ResultadosBusquedaViewController.h"
#import "DetallesProductoViewController.h"
#import "Producto.h"
#import "NoResultadosViewController.h"

NSString * const kMostrarResultadosSegueID = @"MostrarResultadosSegue";
NSString * const kMostrarDetallesCodigoBarrasSegueID = @"MostrarDetallesCodigoBarrasSegue";
NSString * const kNoResultadosCodigoBarrasSegueID = @"NoResultadosCodigoBarrasSegue";

@interface BusquedaProductoViewController () {
    Producto *productoTemp;
    NSArray *arregloBusquedasRecientes;
    NSString *valorPorBuscar;
    NSString *codigoBarrasTemp;
    BOOL codigoEncontrado;
}

@property (weak, nonatomic) IBOutlet EscanerCodigoBarras *escanerCodigoBarras;
@property (weak, nonatomic) IBOutlet UITableView *tablaSugerencias;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *botonCancelarBusqueda;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tablaSugerenciaFondoConstraint;

- (IBAction)cancelarBusqueda:(id)sender;
- (IBAction)mostrarMenu:(id)sender;

@end

@implementation BusquedaProductoViewController

@synthesize escanerCodigoBarras = _escanerCodigoBarras;
@synthesize tablaSugerencias = _tablaSugerencias;
@synthesize botonCancelarBusqueda = _botonCancelarBusqueda;
@synthesize tablaSugerenciaFondoConstraint = _tablaSugerenciaFondoConstraint;

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.escanerCodigoBarras setDelegate:self];
    [self.escanerCodigoBarras crearEscaner];
    [self mostrarBarraBusquedaProductos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    codigoEncontrado = NO;
    [self.escanerCodigoBarras iniciarEscaner];
    arregloBusquedasRecientes = [BuscarProductos obtenerListaBusquedasRecientes];
    [_tablaSugerencias reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoVisible:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoInvisible:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.escanerCodigoBarras detenerEscaner];
    _tablaSugerenciaFondoConstraint.constant = 0.0f;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)mostrarMenu:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) mostrarMenuLateral];
}

- (void)tecladoVisible:(NSNotification *)notificacion {
    NSDictionary *infoNotificacion = [notificacion userInfo];
    CGSize tecladoTam = [[infoNotificacion objectForKey:UIKeyboardFrameEndUserInfoKey]
                         CGRectValue].size;
    _tablaSugerenciaFondoConstraint.constant += tecladoTam.height;
}

- (void)tecladoInvisible:(NSNotification *)notificacion {
    _tablaSugerenciaFondoConstraint.constant = 0.0f;
}

#pragma mark - EscanerCodigoBarrasDelegate methods

- (void)codigoEncontrado:(NSString *)codigo {
    [self.escanerCodigoBarras detenerEscaner];
    NSLog(@"Código de barras %@", codigo);
    
    NSURLSessionTask *buscarProductoTask =
    [EscanerCodigoBarrasController buscarPorCodigoBarras:codigo
                                           estaAgregando:NO
                                               withBlock:^(Producto *producto, NSError *error) {
        if (!error) {
            if (!codigoEncontrado) {
                if (producto) {
                    [self mostrarDetallesProducto:producto];
                    NSLog(@"Producto %@", producto);
                } else {
                    [self mostrarVistaSinResultados:codigo];
                }
                codigoEncontrado = YES;
            }
        } else {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Buscar Producto"
                                                             message:error.description
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alerta show];
            NSLog(@"Error %@", error);
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

#pragma mark - UISearchDisplayDelegate methods

- (void)mostrarBarraBusquedaProductos {
    [self.navigationItem setTitleView:self.searchDisplayController.searchBar];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.tablaSugerencias setHidden:NO];
    [self.navigationItem setRightBarButtonItem:self.botonCancelarBusqueda];
    [self.tablaSugerencias reloadData];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self.tablaSugerencias setHidden:YES];
    [self.navigationItem setRightBarButtonItem:nil];
}

- (IBAction)cancelarBusqueda:(id)sender {
    [self.searchDisplayController setActive:NO
                                   animated:YES];
    [self.searchDisplayController.searchBar setShowsSearchResultsButton:NO];
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *textoBusqueda = [searchBar.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [BuscarProductos agregarBusquedaReciente:textoBusqueda];
    [self mostrarListaProductos:textoBusqueda];
}

#pragma mark - UITableViewDataSource methods

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return @"Búsquedas recientes";
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger cantidadBusquedasRecientes = [arregloBusquedasRecientes count];
    return (cantidadBusquedasRecientes > 0) ? cantidadBusquedasRecientes : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *celdaSugerencia = [tableView dequeueReusableCellWithIdentifier:@"celdaSugerencia"];
    
    if ([arregloBusquedasRecientes count] > 0) {
        NSString *valorBusqueda = [arregloBusquedasRecientes objectAtIndex:indexPath.row];
        [celdaSugerencia.textLabel setText:valorBusqueda];
        [celdaSugerencia.textLabel setTextAlignment:NSTextAlignmentLeft];
        [celdaSugerencia setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [celdaSugerencia setUserInteractionEnabled:YES];
    } else {
        [celdaSugerencia.textLabel setText:@"No existen búsquedas recientes"];
        [celdaSugerencia.textLabel setTextAlignment:NSTextAlignmentCenter];
        [celdaSugerencia setAccessoryType:UITableViewCellAccessoryNone];
        [celdaSugerencia setUserInteractionEnabled:NO];
    }
    
    return celdaSugerencia;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self mostrarListaProductos:[arregloBusquedasRecientes objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Mostrar resultados methods

- (void)mostrarListaProductos:(NSString *)texto {
    if (![texto isEqualToString:@""]) {
        valorPorBuscar = texto;
        [self performSegueWithIdentifier:kMostrarResultadosSegueID
                                  sender:self];
    }
}

- (void)mostrarDetallesProducto:(Producto *)producto {
    productoTemp = producto;
    [self performSegueWithIdentifier:kMostrarDetallesCodigoBarrasSegueID
                              sender:self];
}

- (void)mostrarVistaSinResultados:(NSString *)codigoBarras {
    codigoBarrasTemp = codigoBarras;
    [self performSegueWithIdentifier:kNoResultadosCodigoBarrasSegueID
                              sender:self];
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:kMostrarResultadosSegueID]) {
        ResultadosBusquedaViewController *resultadosBusqueda =
        (ResultadosBusquedaViewController *)segue.destinationViewController;
        resultadosBusqueda.valorPorBuscar = valorPorBuscar;
    } else if ([segue.identifier isEqualToString:kMostrarDetallesCodigoBarrasSegueID]) {
        DetallesProductoViewController *detallesProducto =
        (DetallesProductoViewController *)segue.destinationViewController;
        detallesProducto.producto = productoTemp;
    } else if ([segue.identifier isEqualToString:kNoResultadosCodigoBarrasSegueID]) {
        NoResultadosViewController *sinResultados =
        (NoResultadosViewController *)segue.destinationViewController;
        sinResultados.codigoBarras = codigoBarrasTemp;
    }
}

@end

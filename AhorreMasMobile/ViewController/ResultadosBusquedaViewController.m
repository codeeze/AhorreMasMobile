//
//  ResultadosBusquedaViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/9/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "ResultadosBusquedaViewController.h"
#import "BuscarProductos.h"
#import "UIAlertView+AFNetworking.h"
#import "CeldaProducto.h"
#import "DetallesProductoViewController.h"

NSString * const kMostrarDetallesSegueID = @"MostrarDetallesSegue";

@interface ResultadosBusquedaViewController () {
    Producto *productoTemp;
}

@property (strong, nonatomic) NSArray *listaProductos;
@property (strong, nonatomic) UIRefreshControl *indicadorProgreso;

@end

@implementation ResultadosBusquedaViewController

@synthesize valorPorBuscar = _valorPorBuscar;
@synthesize listaProductos = _listaProductos;
@synthesize indicadorProgreso = _indicadorProgreso;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self empezarBusquedaPorTexto];
}

- (void)empezarBusquedaPorTexto {
    _indicadorProgreso = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_indicadorProgreso];
    [_indicadorProgreso beginRefreshing];
    
    NSURLSessionTask *buscarProductoTask =
    [BuscarProductos buscarPorTexto:_valorPorBuscar
                          withBlock:^(NSArray *arregloProductos, NSError *error) {
                              _listaProductos = arregloProductos;
                              
                              if (error) {
                                  UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Buscar Producto"
                                                                                   message:error.description
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil];
                                  [alerta show];
                                  NSLog(@"Error %@", error);
                              }
                              
                              [_indicadorProgreso endRefreshing];
                              [_indicadorProgreso removeFromSuperview];
                              [self.tableView reloadData];
                          }];
    
    if (!buscarProductoTask) {
        [_indicadorProgreso endRefreshing];
        [_indicadorProgreso removeFromSuperview];
    }
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:buscarProductoTask
                                                  delegate:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger cantidadProductos = 0;
    
    if (!_indicadorProgreso.refreshing) {
        cantidadProductos = ([_listaProductos count] > 0) ? [_listaProductos count] : 1;
    }
    
    return cantidadProductos;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = ([_listaProductos count] > 0) ? @"CeldaProducto" : @"CeldaNoResultados";
    UITableViewCell *celda = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                             forIndexPath:indexPath];
    
    if ([_listaProductos count] > 0) {
        Producto *producto = [_listaProductos objectAtIndex:indexPath.row];
        [(CeldaProducto *)celda mostrarInformacionProducto:producto];
    }
    
    return (CeldaProducto *)celda;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat altoCelda = 80.0f;
    
    if (!_indicadorProgreso.refreshing &&
        ([_listaProductos count] == 0)) {
        altoCelda = 300.0f;
    }
    
    return altoCelda;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    // Esto va a crear un footer invisible y oculta la división de las celdas vacias.
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    productoTemp = [_listaProductos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kMostrarDetallesSegueID
                              sender:self];    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:kMostrarDetallesSegueID]) {
        DetallesProductoViewController *detallesProducto =
        (DetallesProductoViewController *)segue.destinationViewController;
        detallesProducto.producto = productoTemp;
    }
}

@end

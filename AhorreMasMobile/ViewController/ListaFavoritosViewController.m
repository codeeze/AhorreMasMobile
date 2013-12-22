//
//  ListaFavoritosViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "ListaFavoritosViewController.h"
#import "AppDelegate.h"
#import "AgregarProductoListaFavoritosActivity.h"
#import "ListaFavoritos.h"
#import "UIAlertView+AFNetworking.h"
#import "CeldaDatosProducto.h"
#import "Producto.h"
#import "DetallesProductoViewController.h"

NSInteger const kSeccionesVistaListaFavoritos = 2;
NSInteger const kSeccionProductos = 0;
NSInteger const kSeccionDatosTotales = 1;
NSInteger const kSeccionDatosTotalesFilas = 3;
NSInteger const kSeccionDatosTotalesFilaValorMin = 0;
NSInteger const kSeccionDatosTotalesFilaValorMax = 1;
NSInteger const kSeccionDatosTotalesFilaDiferencia = 2;

NSString * const kMostrarDetallesFavoritoSegueID = @"MostrarDetallesFavoritoSegue";

@interface ListaFavoritosViewController () {
    NSMutableArray *arregloProductosFavoritos;
    Producto *productoTemp;
}

@property (strong, nonatomic) NSMutableArray *listaFavoritos;
@property (strong, nonatomic) UIRefreshControl *indicadorProgreso;
@property (assign, nonatomic) NSInteger diferenciaTotal;
@property (assign, nonatomic) float valorMaxTotal;
@property (assign, nonatomic) float valorMinTotal;

- (IBAction)mostrarMenu:(id)sender;
- (IBAction)editarListaFavoritos:(id)sender;

@end

@implementation ListaFavoritosViewController

@synthesize indicadorProgreso = _indicadorProgreso;
@synthesize listaFavoritos = _listaFavoritos;
@synthesize valorMaxTotal = _valorMaxTotal;
@synthesize valorMinTotal = _valorMinTotal;
@synthesize diferenciaTotal = _diferenciaTotal;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *preferenciasUsuario = [NSUserDefaults standardUserDefaults];
    NSArray *arregloListaFavoritos = [preferenciasUsuario objectForKey:kArregloListaFavoritosLlave];
    arregloProductosFavoritos = (arregloListaFavoritos) ?
    [arregloListaFavoritos mutableCopy] : [NSMutableArray array];
    
    if ([arregloProductosFavoritos count] > 0) {
        [self cargarDatosProductosFavoritos];
    }
}

- (void)cargarDatosProductosFavoritos {
    _indicadorProgreso = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_indicadorProgreso];
    [_indicadorProgreso beginRefreshing];
    
    NSURLSessionTask *listaFavoritosTask =
    [ListaFavoritos cargarDatosListaFavoritos:arregloProductosFavoritos
                                    withBlock:^(NSArray *arregloDatosProductos, NSError *error)
     {
         _listaFavoritos = [arregloDatosProductos mutableCopy];
         [self calcularTotales];
         
         if (error) {
             UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Detalles Producto"
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
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:listaFavoritosTask
                                                  delegate:nil];
}

- (IBAction)mostrarMenu:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) mostrarMenuLateral];
}

- (IBAction)editarListaFavoritos:(id)sender {
    if ([_listaFavoritos count] > 0) {
        if (![self.tableView isEditing]) {
            [self.tableView setEditing:YES animated:YES];
            [(UIBarButtonItem *)sender setTitle:@"Cancelar"];
        } else {
            [self.tableView setEditing:NO animated:YES];
            [(UIBarButtonItem *)sender setTitle:@"Editar"];
            [self calcularTotales];
            [self.tableView reloadData];
        }
    }
}

- (void)calcularTotales {
    _valorMinTotal = [self calcularValorMinTotal];
    _valorMaxTotal = [self calcularValorMaxTotal];
    _diferenciaTotal = [self calcularDiferenciaTotal];
}

- (float)calcularValorMinTotal {
    float valorMinTotal = 0.0f;
    
    for (Producto *producto in _listaFavoritos) {
        if (![producto.valorMin isKindOfClass:[NSNull class]]) {
            valorMinTotal += [producto.valorMin floatValue];
        }
    }
    
    return valorMinTotal;
}

- (float)calcularValorMaxTotal {
    float valorMaxTotal = 0.0f;
    
    for (Producto *producto in _listaFavoritos) {
        if (![producto.valorMin isKindOfClass:[NSNull class]]) {
            valorMaxTotal += [producto.valorMax floatValue];
        }
    }
    
    return valorMaxTotal;
}

- (NSInteger)calcularDiferenciaTotal {
    return (_valorMaxTotal - _valorMinTotal) / _valorMinTotal * 100;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger secciones = 0;
    
    if (!_indicadorProgreso.refreshing) {
        secciones = kSeccionesVistaListaFavoritos;
    }
    
    return secciones;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger cantColumnas = 0;
    
    if ([_listaFavoritos count] > 0) {
        if (section == kSeccionProductos) {
            cantColumnas = [_listaFavoritos count];
        } else if (section == kSeccionDatosTotales) {
            cantColumnas = kSeccionDatosTotalesFilas;
        }
    } else {
        cantColumnas = 1;
    }
    
    return cantColumnas;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat alto = 44.0f;
    
    if (([_listaFavoritos count] > 0) &&
        (indexPath.section == 0)) {
        alto = 130.0f;
    }
    
    return alto;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Productos" : @"Datos Totales";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *celda;
    
    if ([_listaFavoritos count] > 0) {
        if (indexPath.section == kSeccionProductos) {
            NSString *CeldaID = @"CeldaDatosProducto";
            celda = [tableView dequeueReusableCellWithIdentifier:CeldaID
                                                    forIndexPath:indexPath];
            Producto *producto = [_listaFavoritos objectAtIndex:indexPath.row];
            [(CeldaDatosProducto *)celda mostrarInformacionDatosProducto:producto];
        } else { //indexPath.section == kSeccionDatosTotales
            NSString *CeldaID = @"CeldaDatosGenerales";
            celda = [tableView dequeueReusableCellWithIdentifier:CeldaID
                                                    forIndexPath:indexPath];
            
            if (indexPath.row == kSeccionDatosTotalesFilaValorMin) {
                [celda.textLabel setText:@"Valor Mínimo"];
                [celda.detailTextLabel setText:[NSString stringWithFormat:@"₡%.2f", _valorMinTotal]];
            } else if (indexPath.row == kSeccionDatosTotalesFilaValorMax) {
                [celda.textLabel setText:@"Valor Máximo"];
                [celda.detailTextLabel setText:[NSString stringWithFormat:@"₡%.2f", _valorMaxTotal]];
            } else { //indexPath.row == kSeccionDatosTotalesFilaDiferencia
                [celda.textLabel setText:@"Valor Diferencia"];
                [celda.detailTextLabel setText:[NSString stringWithFormat:@"%ld%%", (long)_diferenciaTotal]];
            }
        }
    } else {
        NSString *CeldaID = @"CeldaNoDatos";
        celda = [tableView dequeueReusableCellWithIdentifier:CeldaID
                                                forIndexPath:indexPath];
        
        if (indexPath.section == kSeccionProductos) {
            [celda.textLabel setText:@"No se han agregado productos"];
        } else { //indexPath.section == kSeccionDatosTotales
            [celda.textLabel setText:@"No hay información disponible"];
        }
    }
    
    return celda;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSeccionProductos) {
        productoTemp = [_listaFavoritos objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:kMostrarDetallesFavoritoSegueID
                                  sender:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL puedeEditar = NO;
    
    if (indexPath.section == kSeccionProductos) {
        puedeEditar = YES;
    } else { //indexPath.section == kSeccionDatosTotales
        puedeEditar = NO;
    }
    
    return puedeEditar;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_listaFavoritos removeObjectAtIndex:indexPath.row];
        NSUserDefaults *preferenciasUsuario = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arregloListaFavoritos = [[preferenciasUsuario objectForKey:
                                                  kArregloListaFavoritosLlave] mutableCopy];
        [arregloListaFavoritos removeObjectAtIndex:indexPath.row];
        [preferenciasUsuario setObject:arregloListaFavoritos
                                forKey:kArregloListaFavoritosLlave];
        [preferenciasUsuario synchronize];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:kMostrarDetallesFavoritoSegueID]) {
        DetallesProductoViewController *detallesProducto =
        (DetallesProductoViewController *)segue.destinationViewController;
        detallesProducto.producto = productoTemp;
    }
}

@end

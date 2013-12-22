//
//  DetallesProductoViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "DetallesProductoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "BuscarProductos.h"
#import "Establecimiento.h"
#import "CeldaPrecioEstablecimiento.h"
#import "DetallesEstablecimientoViewController.h"
#import "Utilidades.h"
#import "ImagenCompletaViewController.h"
#import "AgregarProductoListaFavoritosActivity.h"

NSString * const kMostrarDetallesEstablecimientoSegueID = @"MostrarDetallesEstablecimientoSegue";
NSString * const kMostrarImagenCompletaSegueID = @"MostrarImagenCompletaSegue";

@interface DetallesProductoViewController () {
    Establecimiento *establecimientoTemp;
}

@property (weak, nonatomic) IBOutlet UIImageView *imagenProducto;
@property (weak, nonatomic) IBOutlet UILabel *descripcionProducto;
@property (weak, nonatomic) IBOutlet UILabel *marcaProducto;
@property (weak, nonatomic) IBOutlet UITableView *tablaPrecioEstablecimientos;
@property (weak, nonatomic) IBOutlet UIImageView *indicadorExpandir;
@property (strong, nonatomic) NSArray *listaPreciosEstablecimientos;
@property (strong, nonatomic) UIRefreshControl *indicadorProgreso;

- (IBAction)mostrarImagenCompleta:(id)sender;
- (IBAction)mostrarAccionesProducto:(id)sender;

@end

@implementation DetallesProductoViewController

@synthesize producto = _producto;
@synthesize imagenProducto = _imagenProducto;
@synthesize descripcionProducto = _descripcionProducto;
@synthesize marcaProducto = _marcaProducto;
@synthesize tablaPrecioEstablecimientos = _tablaPrecioEstablecimientos;
@synthesize listaPreciosEstablecimientos = _listaPreciosEstablecimientos;
@synthesize indicadorProgreso = _indicadorProgreso;
@synthesize indicadorExpandir = _indicadorExpandir;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cargarDatosProducto];
    
    _indicadorProgreso = [[UIRefreshControl alloc] init];
    [_tablaPrecioEstablecimientos addSubview:_indicadorProgreso];
    [_indicadorProgreso addTarget:self
                           action:@selector(cargarPreciosPorEstablecimiento)
                 forControlEvents:UIControlEventValueChanged];
    
    [self cargarPreciosPorEstablecimiento];
}

- (void)cargarDatosProducto {
    [_descripcionProducto setText:[NSString stringWithFormat:@"%@ %@ %d %@", _producto.nombre,
                                   _producto.modelo, (int)_producto.cantidad, _producto.unidadMedida]];
    [_marcaProducto setText:[NSString stringWithFormat:@"%@", _producto.marca]];
    
    if ([_producto.urlImagen isKindOfClass:[NSString class]] &&
        ![_producto.urlImagen isEqualToString:@""]) {
        NSURL *urlImagen = [NSURL URLWithString:_producto.urlImagen];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlImagen];
        [_imagenProducto setImageWithURLRequest:urlRequest
                               placeholderImage:[UIImage imageNamed:@"ImagenDescripcionTemporal"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image)
         {
             UIImage *imagenRecortada = [Utilidades imagenParaMostrarEnFotoCeldaConTamano:_imagenProducto.intrinsicContentSize
                                                                           imagenOriginal:image];
             [_imagenProducto setImage:imagenRecortada];
         }
                                        failure:nil];
    } else {
        [_indicadorExpandir setHidden:YES];
    }
}

- (void)cargarPreciosPorEstablecimiento {
    [_indicadorProgreso beginRefreshing];
    
    NSURLSessionTask *buscarPreciosEstablecimientoTask =
    [BuscarProductos buscarPreciosProductoEstablecimientos:_producto.productoID
                                                     withBlock:^(NSArray *arregloPreciosEstablecimientos, NSError *error)
     {
         _listaPreciosEstablecimientos = arregloPreciosEstablecimientos;
         
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
         [_tablaPrecioEstablecimientos reloadData];
     }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:buscarPreciosEstablecimientoTask
                                                  delegate:nil];
}

- (IBAction)mostrarImagenCompleta:(id)sender {
    if ([_producto.urlImagen isKindOfClass:[NSString class]] &&
        ![_producto.urlImagen isEqualToString:@""]) {
        [self performSegueWithIdentifier:kMostrarImagenCompletaSegueID
                                  sender:self];
    }
}

- (IBAction)mostrarAccionesProducto:(id)sender {
    NSString *descripcionProducto = [NSString stringWithFormat:@"%@ %@ %@ %d %@", _producto.nombre,
                                     _producto.modelo, _producto.marca, (int)_producto.cantidad, _producto.unidadMedida];
    NSArray *itemsAcciones = [NSArray arrayWithObjects:[NSNumber numberWithInteger:_producto.productoID],
                              descripcionProducto, _imagenProducto.image, nil];
    AgregarProductoListaFavoritosActivity *agregarProductoListaFavoritos =
    [[AgregarProductoListaFavoritosActivity alloc] init];
    
    UIActivityViewController *actividadesViewController =
    [[UIActivityViewController alloc] initWithActivityItems:itemsAcciones
                                      applicationActivities:@[agregarProductoListaFavoritos]];
    actividadesViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                                        UIActivityTypeAssignToContact,
                                                        UIActivityTypePrint,
                                                        UIActivityTypeCopyToPasteboard,
                                                        UIActivityTypeSaveToCameraRoll,
                                                        UIActivityTypeMail,
                                                        UIActivityTypeMessage];
    [self presentViewController:actividadesViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger cantidadEstablecimientos = 0;
    
    if (!_indicadorProgreso.refreshing) {
        cantidadEstablecimientos = ([_listaPreciosEstablecimientos count] > 0) ?
        [_listaPreciosEstablecimientos count] : 1;
    }
    
    return cantidadEstablecimientos;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    NSString *tituloCabecera = @"";
    
    if (!_indicadorProgreso.refreshing) {
        tituloCabecera = @"Precios por Establecimientos";
    }
    
    return tituloCabecera;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = ([_listaPreciosEstablecimientos count] > 0) ?
    @"CeldaPrecioEstablecimiento" : @"CeldaNoEstablecimientos";
    UITableViewCell *celda = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                             forIndexPath:indexPath];
    
    if ([_listaPreciosEstablecimientos count] > 0) {
        Establecimiento *establecimiento = [_listaPreciosEstablecimientos objectAtIndex:indexPath.row];
        [((CeldaPrecioEstablecimiento *)celda).nombreEstablecimiento setText:establecimiento.nombre];
        [((CeldaPrecioEstablecimiento *)celda).precioProducto setText:[NSString stringWithFormat:@"₡%.2f",
                                                                       [establecimiento.ultimoPrecio floatValue]]];
    }
    
    return celda;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat altoCelda = 50.0f;
    
    if (!_indicadorProgreso.refreshing &&
        ([_listaPreciosEstablecimientos count] == 0)) {
        altoCelda = 44.0f;
    }
    
    return altoCelda;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    // Esto va a crear un footer invisible y oculta la división de las celdas vacias.
    CGFloat alto = 0.0f;
    
    if (!_indicadorProgreso.refreshing) {
        alto = 0.01f;
    }
    
    return alto;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    establecimientoTemp = [_listaPreciosEstablecimientos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kMostrarDetallesEstablecimientoSegueID
                              sender:self];
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:kMostrarDetallesEstablecimientoSegueID]) {
        DetallesEstablecimientoViewController *detallesEstablecimiento =
        (DetallesEstablecimientoViewController *)segue.destinationViewController;
        detallesEstablecimiento.producto = _producto;
        detallesEstablecimiento.establecimiento = establecimientoTemp;
        detallesEstablecimiento.delegate = self;
    } else if ([segue.identifier isEqualToString:kMostrarImagenCompletaSegueID]) {
        ImagenCompletaViewController *imagenCompleta =
        (ImagenCompletaViewController *)segue.destinationViewController;
        imagenCompleta.urlImagen = _producto.urlImagen;
    }
}

@end

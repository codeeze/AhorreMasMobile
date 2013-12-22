//
//  DetallesEstablecimientoViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "DetallesEstablecimientoViewController.h"
#import "CeldaNombreEstablecimiento.h"
#import "CeldaDireccionEstablecimiento.h"
#import "AppDelegate.h"
#import "MenuMapaViewController.h"
#import "PCLineChartView.h"
#import "CeldaHistorialPrecios.h"
#import "BuscarProductos.h"
#import "UIAlertView+AFNetworking.h"
#import "HistorialPrecio.h"
#import "CeldaValorActual.h"
#import "CambiarPrecioViewController.h"

NSInteger const kSeccionesVistaDetallesEstablecimientos = 2;
NSInteger const kSeccionDetallesEstablecimientos = 0;
NSInteger const kSeccionHistorialPrecios = 1;
NSInteger const kSeccionDetallesEstablecimientosCeldas = 2;
NSInteger const kSeccionHistorialPreciosCeldas = 2;

NSInteger const kSeccionDetallesEstablecimientosCeldaNombre = 0;
NSInteger const kSeccionDetallesEstablecimientosCeldaDireccion = 1;

NSInteger const kSeccionHistorialPreciosCeldaValorActual = 0;
NSInteger const kSeccionHistorialPreciosCeldaHistorial = 1;

NSString * const kCambiarPrecioProductoSegueID = @"CambiarPrecioProductoSegue";

@interface DetallesEstablecimientoViewController () {
    PCLineChartView *grafico;
}

@property (strong, nonatomic) UIRefreshControl *indicadorProgreso;
@property (strong, nonatomic) NSArray *listaHistorialPrecios;

- (IBAction)mostrarMapa:(id)sender;

@end

@implementation DetallesEstablecimientoViewController

@synthesize producto = _producto;
@synthesize establecimiento = _establecimiento;
@synthesize indicadorProgreso = _indicadorProgreso;
@synthesize listaHistorialPrecios = _listaHistorialPrecios;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indicadorProgreso = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_indicadorProgreso];
    [_indicadorProgreso addTarget:self
                           action:@selector(cargarHistorialPrecios)
                 forControlEvents:UIControlEventValueChanged];
    
    [self cargarHistorialPrecios];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) agregarMenuMapa:_establecimiento];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) quitarMenuMapa];
    [_delegate cargarPreciosPorEstablecimiento];
}

- (void)cargarHistorialPrecios {
    [_indicadorProgreso beginRefreshing];
    
    NSURLSessionTask *buscarHistorialPreciosTask =
    [BuscarProductos buscarHistorialPreciosProducto:_producto.productoID
                                  enEstablecimiento:_establecimiento.establecimientoID
                                          withBlock:^(NSArray *arregloHistorialPrecios, NSError *error)
     {
         _listaHistorialPrecios = arregloHistorialPrecios;
         
         if (error) {
             UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Detalles Establecimiento"
                                                              message:error.description
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
             [alerta show];
             NSLog(@"Error %@", error);
         }
         
         [_indicadorProgreso endRefreshing];
         [self.tableView reloadData];
     }];
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:buscarHistorialPreciosTask
                                                  delegate:nil];
}

- (IBAction)mostrarMapa:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) mostrarMenuMapa];
}

- (void)mostrarHistorialPrecios:(CeldaHistorialPrecios *)celda {
    [grafico removeFromSuperview];
    grafico = [[PCLineChartView alloc] initWithFrame:CGRectMake(10.0f,0.0f,310.0f,300.0f)];
    [celda addSubview:grafico];
    [grafico setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    NSMutableArray *precios = [NSMutableArray arrayWithCapacity:[_listaHistorialPrecios count]];
    NSMutableArray *fechas = [NSMutableArray arrayWithCapacity:[_listaHistorialPrecios count]];
    
    for (HistorialPrecio *elemento in _listaHistorialPrecios) {
        [precios addObject:[NSDecimalNumber decimalNumberWithString:elemento.precio]];
        [fechas addObject:elemento.fechaCorta];
    }
    
    grafico.minValue = [[precios valueForKeyPath:@"@min.self"] floatValue];
    grafico.maxValue = [[precios valueForKeyPath:@"@max.self"] floatValue];
    
    NSInteger intervalo = 1;
    float valorMaxTemp = [[precios valueForKeyPath:@"@max.self"] floatValue];
    
    while (valorMaxTemp > 10) {
        intervalo *= 10;
        valorMaxTemp /= 10;
    }
    
    if (grafico.minValue == grafico.maxValue) {
        grafico.minValue -= intervalo;
        grafico.maxValue += intervalo;
    }
    
    grafico.interval = intervalo / 2;
    grafico.yLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    grafico.xLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    NSMutableArray *componentes = [NSMutableArray array];
    PCLineChartViewComponent *componente = [[PCLineChartViewComponent alloc] init];
    [componente setTitle:@""];
    [componente setPoints:precios];
    [componente setShouldLabelValues:NO];
    [componente setColour:PCColorOrange];
    [componentes addObject:componente];
    [grafico setComponents:componentes];
    [grafico setXLabels:fechas];
    [grafico setNeedsDisplay];
}

- (void)mostrarVistaCambiarPrecio {
    [self performSegueWithIdentifier:kCambiarPrecioProductoSegueID
                              sender:self];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger secciones = 0;
    
    if (!_indicadorProgreso.refreshing) {
        secciones = kSeccionesVistaDetallesEstablecimientos;
    }
    
    return secciones;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSInteger seccion = 0;
    
    if (section == kSeccionDetallesEstablecimientos) {
        seccion = kSeccionDetallesEstablecimientosCeldas;
    } else if (section == kSeccionHistorialPrecios) {
        seccion = kSeccionHistorialPreciosCeldas;
    }
    
    return seccion;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    NSString *titulo = @"";
    
    if (section == kSeccionDetallesEstablecimientos) {
        titulo = @"Establecimiento";
    } else if (section == kSeccionHistorialPrecios) {
        titulo = @"Historial de Precios";
    }
    
    return titulo;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *celda;
    
    if (indexPath.section == kSeccionDetallesEstablecimientos) {
        if (indexPath.row == kSeccionDetallesEstablecimientosCeldaNombre) {
            NSString *celdaID = @"CeldaNombreEstablecimiento";
            celda = [tableView dequeueReusableCellWithIdentifier:celdaID
                                                    forIndexPath:indexPath];
            [((CeldaNombreEstablecimiento *)celda).detalleCelda setText:_establecimiento.nombre];
        } else { //indexPath.row == kSeccionDetallesEstablecimientosCeldaDireccion
            NSString *celdaID = @"CeldaDireccionEstablecimiento";
           celda = [tableView dequeueReusableCellWithIdentifier:celdaID
                                                   forIndexPath:indexPath];
            [((CeldaDireccionEstablecimiento *)celda).detalleCelda setText:_establecimiento.direccion];
        }
    } else { //section == kSeccionHistorialPrecios)
        if (indexPath.row == kSeccionHistorialPreciosCeldaValorActual) {
            NSString *celdaID = @"CeldaValorActual";
            celda = [tableView dequeueReusableCellWithIdentifier:celdaID
                                                    forIndexPath:indexPath];
            [((CeldaValorActual *)celda).valorActual setText:
             [NSString stringWithFormat:@"₡%.2f", [_establecimiento.ultimoPrecio floatValue]]];
            [((CeldaValorActual *)celda).cambiarPrecio addTarget:self
                                                          action:@selector(mostrarVistaCambiarPrecio)
                                                forControlEvents:UIControlEventTouchUpInside];
        } else { //indexPath.row == kSeccionHistorialPreciosCeldaHistorial
            NSString *celdaID = @"CeldaHistorialPrecios";
            celda = [tableView dequeueReusableCellWithIdentifier:celdaID
                                                    forIndexPath:indexPath];
            [self mostrarHistorialPrecios:(CeldaHistorialPrecios *)celda];
        }
    }
    
    return celda;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat alto = 44.0f;
    
    if (indexPath.section == kSeccionDetallesEstablecimientos) {
        if (indexPath.row == kSeccionDetallesEstablecimientosCeldaNombre) {
            alto = 50.0f;
        } else { //indexPath.row == kSeccionDetallesEstablecimientosCeldaDireccion
            alto = 70.0f;
        }
    } else { //section == kSeccionHistorialPrecios)
        if (indexPath.row == kSeccionHistorialPreciosCeldaValorActual) {
            alto = 44.0f;
        } else { //indexPath.row == kSeccionHistorialPreciosCeldaHistorial
            alto = 300.0f;
        }
    }
    
    return alto;
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:kCambiarPrecioProductoSegueID]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CambiarPrecioViewController *cambiarPrecio = [navigationController.viewControllers objectAtIndex:0];
        cambiarPrecio.productoID = _producto.productoID;
        cambiarPrecio.establecimientoID = _establecimiento.establecimientoID;
        cambiarPrecio.delegate = self;
    }
}

@end

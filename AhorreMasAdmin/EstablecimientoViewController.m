//
//  EstablishmentSearchViewController.m
//  Precio Digital
//
//  Created by Javier Ramirez on 10/12/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "EstablecimientoViewController.h"
#import "FoursquareServicioWeb.h"
#import "EstablecimientoFoursquare.h"
#import <CoreLocation/CoreLocation.h>

NSString *const kEstablishmentNoElementsCellIdentifier = @"NoElementsCell";
NSString *const kEstablishmentCellIdentifier = @"EstablishmentSearchCell";

@interface EstablecimientoViewController ()

@property NSArray *resultadosEstablecimientos;
@property CLLocationManager *adminUbicacion;
@property BOOL estaBuscando;
@property NSArray *resultadosBusqueda;
@property (nonatomic) UIRefreshControl *indicadorProgreso;

@end

@implementation EstablecimientoViewController

@synthesize indicadorProgreso = _indicadorProgreso;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _indicadorProgreso = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_indicadorProgreso];
    [_indicadorProgreso beginRefreshing];

    _resultadosEstablecimientos = [NSArray array];
    _adminUbicacion = [[CLLocationManager alloc] init];
    _adminUbicacion.delegate = self;
    _adminUbicacion.distanceFilter = kCLDistanceFilterNone;
    _adminUbicacion.desiredAccuracy = kCLLocationAccuracyBest;
    [_adminUbicacion startUpdatingLocation];
}

- (void) cargarEstablecimientosFoursquareConUbicacion:(CLLocation *)ubicacion
{
    NSError *error;
    double latitud = ubicacion.coordinate.latitude;
    double longitud = ubicacion.coordinate.longitude;
    FoursquareServicioWeb *foursquareApi = [[FoursquareServicioWeb alloc] init];
    NSDictionary *diccionarioFoursquare = [foursquareApi lugaresConLatitud:latitud Longitud:longitud RetornandoError:&error];
    _resultadosEstablecimientos = [EstablecimientoFoursquare establecimientosFoursquareConDiccionario:diccionarioFoursquare];
    [_indicadorProgreso endRefreshing];
    [_indicadorProgreso removeFromSuperview];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger secciones = 0;
    if (!_indicadorProgreso.refreshing) {
        secciones = 1;
    }
    return secciones;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger filas = 0;
    if (!_indicadorProgreso.refreshing) {
        NSInteger resultados = 0;
        if (_estaBuscando) {
            resultados = [_resultadosBusqueda count];
        } else {
            resultados = [_resultadosEstablecimientos count];
        }
        
        //No hay resultados, se muestra un celda informandolo
        if (resultados == 0) {
            filas = 1;
        } else {
            filas = resultados;
        }
    }
    return filas;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray *resultsArray;
    if (_estaBuscando) {
        resultsArray = _resultadosBusqueda;
    } else {
        resultsArray = _resultadosEstablecimientos;
    }
    
    if ([resultsArray count] == 0) {
        cell = [self.tableView dequeueReusableCellWithIdentifier:kEstablishmentNoElementsCellIdentifier];
    } else {
        EstablecimientoFoursquare *establishment = [resultsArray objectAtIndex:indexPath.row];
        cell = [self.tableView dequeueReusableCellWithIdentifier:kEstablishmentCellIdentifier];
        cell.textLabel.text = establishment.nombre;
        cell.detailTextLabel.text = establishment.direccion;
    }
    
    return cell;
}


#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *ubicacion = [locations lastObject];
    [self cargarEstablecimientosFoursquareConUbicacion:ubicacion];
    [_adminUbicacion stopUpdatingLocation];
}


#pragma mark - UISearchDisplay Delegate


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if ([searchString isEqualToString:@""]) {
        _estaBuscando = NO;
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nombre CONTAINS[cd] %@", searchString];
        _resultadosBusqueda = [_resultadosEstablecimientos filteredArrayUsingPredicate:predicate];
        _estaBuscando = YES;
    }
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    _estaBuscando = NO;
    
    //Arregla el error de que la barra de busqueda desaparece
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [self.tableView insertSubview:self.searchDisplayController.searchBar aboveSubview:self.tableView];
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _estaBuscando = NO;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ((([_resultadosEstablecimientos count] != 0) && (!_estaBuscando)) ||
        (([_resultadosBusqueda count] != 0) && (_estaBuscando))){
        EstablecimientoFoursquare *establecimiento = [_resultadosEstablecimientos objectAtIndex:indexPath.row];
        [_delegate seleccionoEstablecimiento:establecimiento];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

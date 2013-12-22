//
//  MenuLateralViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 11/29/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "MenuLateralViewController.h"
#import "AppDelegate.h"

int const kCantidadCeldasMenuLateral = 4;
int const kMenuLateralCeldaBuscarProducto = 0;
int const kMenuLateralCeldaAgregarProducto = 1;
int const kMenuLateralCeldaListaProductos = 2;
int const kMenuLateralCeldaAcercaAyuda = 3;

@interface MenuLateralViewController ()

@end

@implementation MenuLateralViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return kCantidadCeldasMenuLateral;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identificador = @"celdaSecciones";
    UITableViewCell *celda = [tableView dequeueReusableCellWithIdentifier:identificador];
    
    if (indexPath.row == kMenuLateralCeldaBuscarProducto) {
        [celda.textLabel setText:@"Buscar Producto"];
    } else if (indexPath.row == kMenuLateralCeldaAgregarProducto) {
        [celda.textLabel setText:@"Agregar Producto"];
    } else if (indexPath.row == kMenuLateralCeldaListaProductos) {
        [celda.textLabel setText:@"Mi Lista Favoritos"];
    } else if (indexPath.row == kMenuLateralCeldaAcercaAyuda) {
        [celda.textLabel setText:@"Acerca De"];
    }
    
    return celda;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {
    // Esto va a crear un footer invisible y oculta la división de las celdas vacias.
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vista =
    [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
     instantiateViewControllerWithIdentifier:@"busquedaProductoViewController"];
    
    if (indexPath.row == kMenuLateralCeldaBuscarProducto) {
        vista = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
         instantiateViewControllerWithIdentifier:@"busquedaProductoViewController"];
    } else if (indexPath.row == kMenuLateralCeldaAgregarProducto) {
        vista = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                 instantiateViewControllerWithIdentifier:@"agregarProductoViewController"];
    } else if (indexPath.row == kMenuLateralCeldaListaProductos) {
        vista = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
         instantiateViewControllerWithIdentifier:@"listaFavoritosViewController"];
    } else if (indexPath.row == kMenuLateralCeldaAcercaAyuda) {
        vista = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                 instantiateViewControllerWithIdentifier:@"acercaDeViewController"];
    }
    
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) cambiarVistaFrontal:vista];
}

@end

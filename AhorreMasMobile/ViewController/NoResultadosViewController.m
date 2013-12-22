//
//  NoResultadosViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "NoResultadosViewController.h"
#import "AgregarProductoViewController.h"
#import "Producto.h"

NSString * const KAgregarProductoNoResultadoSegueID = @"agregarProductoNoResultadoSegue";

@interface NoResultadosViewController()

- (IBAction)agregarProducto:(id)sender;

@end

@implementation NoResultadosViewController

@synthesize codigoBarras = _codigoBarras;

- (IBAction)agregarProducto:(id)sender {
    [self performSegueWithIdentifier:KAgregarProductoNoResultadoSegueID
                              sender:self];
}

#pragma mark - Navigation methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    if ([segue.identifier isEqualToString:KAgregarProductoNoResultadoSegueID]) {
        Producto *producto = [[Producto alloc] initConCodigoBarras:_codigoBarras];
        AgregarProductoViewController *agregarProductoVista =
        (AgregarProductoViewController *)segue.destinationViewController;
        agregarProductoVista.producto = producto;
    }
}

@end

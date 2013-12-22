//
//  CambiarPrecioViewController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/17/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "CambiarPrecioViewController.h"
#import "ModificarPrecio.h"
#import "UIAlertView+AFNetworking.h"

@interface CambiarPrecioViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nuevoPrecio;

- (IBAction)cambiarPrecio:(id)sender;
- (IBAction)cancelar:(id)sender;

@end

@implementation CambiarPrecioViewController

@synthesize nuevoPrecio = _nuevoPrecio;
@synthesize productoID = _productoID;
@synthesize establecimientoID = _establecimientoID;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_nuevoPrecio becomeFirstResponder];
}

- (IBAction)cambiarPrecio:(id)sender {
    if (![_nuevoPrecio.text isEqualToString:@""]) {
        NSString *precio = [_nuevoPrecio.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
        NSURLSessionTask *modificarPrecioTask =[ModificarPrecio modificarPrecioProducto:_productoID
                                                                      enEstablecimiento:_establecimientoID
                                                                              conPrecio:precio
                                                                              withBlock:^(BOOL enviadoConExito, NSError *error)
        {
            if (error) {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Buscar Producto"
                                                                 message:error.description
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                [alerta show];
                NSLog(@"Error %@", error);
            }
            
            if (enviadoConExito) {
                [_delegate cargarHistorialPrecios];
                [_delegate.establecimiento setUltimoPrecio:precio];
                [self cancelar:nil];
            }
        }];
        
        [UIAlertView showAlertViewForTaskWithErrorOnCompletion:modificarPrecioTask
                                                      delegate:nil];
    }
}

- (IBAction)cancelar:(id)sender {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end

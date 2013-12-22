//
//  CeldaNoResultados.m
//  AhorreMasMobile
//
//  Created by Adalberto Cubillo on 12/19/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "CeldaNoResultados.h"
#import "AppDelegate.h"

@interface CeldaNoResultados()

- (IBAction)agregarProducto:(id)sender;

@end

@implementation CeldaNoResultados

- (IBAction)agregarProducto:(id)sender {
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) mostrarMenuLateral];
    
    [NSTimer scheduledTimerWithTimeInterval:0.7f
                            target:self
                          selector:@selector(mostrarAgregarProducto)
                          userInfo:nil
                           repeats:NO] ;
}

- (void)mostrarAgregarProducto {
    UIViewController *vista = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                               instantiateViewControllerWithIdentifier:@"agregarProductoViewController"];
    [((AppDelegate *)[[UIApplication sharedApplication] delegate]) cambiarVistaFrontal:vista];
}

@end

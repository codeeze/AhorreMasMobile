//
//  CeldaDatosProducto.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "CeldaDatosProducto.h"

@implementation CeldaDatosProducto

@synthesize descripcionProducto = _descripcionProducto;
@synthesize marcaProducto = _marcaProducto;
@synthesize valorMaximo = _valorMaximo;
@synthesize valorMinimo = _valorMinimo;
@synthesize diferencia = _diferencia;

- (void)mostrarInformacionDatosProducto:(Producto *)producto {
    [_descripcionProducto setText:[NSString stringWithFormat:@"%@ %@ %d %@", producto.nombre,
                                   producto.modelo, (int)producto.cantidad, producto.unidadMedida]];
    [_marcaProducto setText:[NSString stringWithFormat:@"%@", producto.marca]];
    
    if (![producto.valorMin isKindOfClass:[NSNull class]]) {
        [_valorMinimo setText:[NSString stringWithFormat:@"₡%.2f", [producto.valorMin floatValue]]];
    } else {
        [_valorMinimo setText:[NSString stringWithFormat:@"₡%.2f", 0.0f]];
    }
    
    if (![producto.valorMax isKindOfClass:[NSNull class]]) {
        [_valorMaximo setText:[NSString stringWithFormat:@"₡%.2f", [producto.valorMax floatValue]]];
    } else {
        [_valorMaximo setText:[NSString stringWithFormat:@"₡%.2f", 0.0f]];
    }
    
    if (![producto.valorMin isKindOfClass:[NSNull class]] &&
        ![producto.valorMax isKindOfClass:[NSNull class]]) {
        NSInteger diferencia = ([producto.valorMax floatValue] - [producto.valorMin floatValue]) /
        [producto.valorMin floatValue] * 100;
        [_diferencia setText:[NSString stringWithFormat:@"%ld%%", (long)diferencia]];
    } else {
        [_diferencia setText:@"0%"];
    }
}

@end

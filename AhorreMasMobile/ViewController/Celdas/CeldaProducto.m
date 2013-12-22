//
//  CeldaProducto.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/9/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "CeldaProducto.h"
#import "UIImageView+AFNetworking.h"

@implementation CeldaProducto

@synthesize imagenProducto = _imagenProducto;
@synthesize descripcionProducto = _descripcionProducto;
@synthesize marcaProducto = _marcaProducto;

- (void)mostrarInformacionProducto:(Producto *)producto {
    [_descripcionProducto setText:[NSString stringWithFormat:@"%@ %@ %d %@", producto.nombre,
                                   producto.modelo, (int)producto.cantidad, producto.unidadMedida]];
    [_marcaProducto setText:[NSString stringWithFormat:@"%@", producto.marca]];
    
    if ([producto.urlImagen isKindOfClass:[NSString class]] &&
        ![producto.urlImagen isEqualToString:@""]) {
        NSURL *urlImagen = [NSURL URLWithString:producto.urlImagen];
        [_imagenProducto setImageWithURL:urlImagen
                        placeholderImage:[UIImage imageNamed:@"ImagenTemporal"]];
        [self setNeedsLayout];
    }
}

@end

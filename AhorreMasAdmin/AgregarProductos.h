//
//  AgregarProductos.h
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RegistroPrecio;
@class Producto;

@interface AgregarProductos : NSObject

+ (NSURLSessionDataTask *)agregarProducto:(RegistroPrecio *)registroPrecio
                                               withBlock:(void (^)(NSError *error))block;
+ (NSURLSessionDataTask *)subirFotoProducto:(Producto *)producto
                                  withBlock:(void (^)(NSError *error))block;

@end

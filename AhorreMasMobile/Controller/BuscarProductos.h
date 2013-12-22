//
//  BuscarProductos.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/7/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuscarProductos : NSObject

+ (NSArray *)obtenerListaBusquedasRecientes;
+ (void)agregarBusquedaReciente:(NSString *)textoBusqueda;
+ (NSURLSessionDataTask *)buscarPorTexto:(NSString *)texto
                                      withBlock:(void (^)(NSArray *arregloProductos, NSError *error))block;
+ (NSURLSessionDataTask *)buscarPreciosProductoEstablecimientos:(NSInteger)productoID
                                                      withBlock:(void (^)(NSArray *arregloPreciosEstablecimientos,
                                                                          NSError *error))block;
+ (NSURLSessionDataTask *)buscarHistorialPreciosProducto:(NSInteger)productoID
                                       enEstablecimiento:(NSInteger)establecimientoID
                                               withBlock:(void (^)(NSArray *arregloHistorialPrecios,
                                                                   NSError *error))block;

@end

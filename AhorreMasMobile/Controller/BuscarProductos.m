//
//  BuscarProductos.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/7/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "BuscarProductos.h"
#import "ConexionServicioWeb.h"
#import "Producto.h"
#import "Establecimiento.h"
#import "HistorialPrecio.h"

NSString * const kArregloBusquedasRecientesLlave = @"busquedasRecientes";

@implementation BuscarProductos

+ (NSArray *)obtenerListaBusquedasRecientes {
    NSUserDefaults *preferenciasUsuario = [NSUserDefaults standardUserDefaults];
    NSArray *arregloBusquedasRecientes = [preferenciasUsuario objectForKey:kArregloBusquedasRecientesLlave];

    if (!arregloBusquedasRecientes) {
        arregloBusquedasRecientes = [NSArray array];
    }
    
    return arregloBusquedasRecientes;
}

+ (void)agregarBusquedaReciente:(NSString *)textoBusqueda {
    NSUserDefaults *preferenciasUsuario = [NSUserDefaults standardUserDefaults];
    NSArray *arregloBusquedasRecientes = [preferenciasUsuario objectForKey:kArregloBusquedasRecientesLlave];
    NSMutableArray *arregloActualizado = (arregloBusquedasRecientes) ?
    [arregloBusquedasRecientes mutableCopy] : [NSMutableArray array];
    [arregloActualizado removeObject:textoBusqueda];
    [arregloActualizado insertObject:textoBusqueda atIndex:0];
    [preferenciasUsuario setObject:arregloActualizado
                            forKey:kArregloBusquedasRecientesLlave];
    [preferenciasUsuario synchronize];
}

+ (NSURLSessionDataTask *)buscarPorTexto:(NSString *)texto
                               withBlock:(void (^)(NSArray *arregloProductos, NSError *error))block {
    NSDictionary *parametrosURL = @{@"texto":texto};
    
    return [[ConexionServicioWeb clienteCompartido] POST:@"index.php?webservices/buscar_productos_texto/"
                                             parameters:parametrosURL
                                                success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                NSError *error = nil;
                NSMutableArray *arregloProductos = [NSMutableArray array];
                
                if (estado == 0) {
                    NSArray *arregloDataJSON = [JSON valueForKeyPath:@"data"];
                    
                    for (NSDictionary *dataProducto in arregloDataJSON) {
                        Producto *producto = [[Producto alloc] initConAtributos:dataProducto];
                        [arregloProductos addObject:producto];
                    }
                } else {
                    NSString *mensaje = [JSON valueForKeyPath:@"mensaje"];
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:mensaje forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"AhorreMas web server error"
                                                code:100
                                            userInfo:errorDetail];
                    NSLog(@"%@", mensaje);
                }
                
                if (block) {
                    block(arregloProductos, error);
                }
            }
                                                failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) {
                    block([NSArray array], error);
                }
            }];
}

+ (NSURLSessionDataTask *)buscarPreciosProductoEstablecimientos:(NSInteger)productoID
                                                      withBlock:(void (^)(NSArray *arregloPreciosEstablecimientos,
                                                                          NSError *error))block {
    NSString *urlConProductoID = [NSString stringWithFormat:@"index.php?webservices/obtener_precios_establecimientos/%ld",
                                  (long)productoID];
    
    return [[ConexionServicioWeb clienteCompartido] GET:urlConProductoID
                                             parameters:nil
                                                success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                NSError *error = nil;
                NSMutableArray *arregloPreciosEstablecimientos = [NSMutableArray array];
                
                if (estado == 0) {
                    NSArray *arregloDataJSON = [JSON valueForKeyPath:@"data"];
                    
                    for (NSDictionary *dataEstablecimiento in arregloDataJSON) {
                        Establecimiento *establecimiento = [[Establecimiento alloc] initConAtributos:dataEstablecimiento];
                        [arregloPreciosEstablecimientos addObject:establecimiento];
                    }
                } else {
                    NSString *mensaje = [JSON valueForKeyPath:@"mensaje"];
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:mensaje forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"AhorreMas web server error"
                                                code:100
                                            userInfo:errorDetail];
                    NSLog(@"%@", mensaje);
                }
                
                if (block) {
                    block(arregloPreciosEstablecimientos, error);
                }
            }
                                                failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) {
                    block([NSArray array], error);
                }
            }];
}

+ (NSURLSessionDataTask *)buscarHistorialPreciosProducto:(NSInteger)productoID
                                       enEstablecimiento:(NSInteger)establecimientoID
                                               withBlock:(void (^)(NSArray *arregloHistorialPrecios,
                                                                   NSError *error))block {
    NSString *urlHistorialPrecio = [NSString stringWithFormat:@"index.php?webservices/obtener_historial_precios/%ld/%ld",
                                    (long)productoID, (long)establecimientoID];
    
    return [[ConexionServicioWeb clienteCompartido] GET:urlHistorialPrecio
                                             parameters:nil
                                                success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                NSError *error = nil;
                NSMutableArray *arregloHistorialPrecios = [NSMutableArray array];
                
                if (estado == 0) {
                    NSArray *arregloDataJSON = [JSON valueForKeyPath:@"data"];
                    
                    for (NSDictionary *dataPrecio in arregloDataJSON) {
                        HistorialPrecio *precio = [[HistorialPrecio alloc] initConAtributos:dataPrecio];
                        [arregloHistorialPrecios addObject:precio];
                    }
                } else {
                    NSString *mensaje = [JSON valueForKeyPath:@"mensaje"];
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:mensaje forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"AhorreMas web server error"
                                                code:100
                                            userInfo:errorDetail];
                    NSLog(@"%@", mensaje);
                }
                
                if (block) {
                    block(arregloHistorialPrecios, error);
                }
            }
                                                failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) {
                    block([NSArray array], error);
                }
            }];
}

@end

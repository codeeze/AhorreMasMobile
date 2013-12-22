//
//  ListaFavoritos.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/17/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "ListaFavoritos.h"
#import "ConexionServicioWeb.h"
#import "Producto.h"

@implementation ListaFavoritos

+ (NSURLSessionDataTask *)cargarDatosListaFavoritos:(NSArray *)arregloFavoritos
                                          withBlock:(void (^)(NSArray *arregloDatosProductos, NSError *error))block {
    NSDictionary *parametrosURL = @{@"productosIDs":[arregloFavoritos componentsJoinedByString:@","]};
    
    return [[ConexionServicioWeb clienteCompartido] POST:@"index.php?webservices/obtener_precios_min_max/"
                                              parameters:parametrosURL
                                                 success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                NSError *error = nil;
                NSMutableArray *arregloDatosProductos = [NSMutableArray array];
                
                if (estado == 0) {
                    NSArray *arregloDataJSON = [JSON valueForKeyPath:@"data"];
                    
                    for (NSDictionary *dataProducto in arregloDataJSON) {
                        Producto *producto = [[Producto alloc] initConAtributos:dataProducto];
                        [arregloDatosProductos addObject:producto];
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
                    block(arregloDatosProductos, error);
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

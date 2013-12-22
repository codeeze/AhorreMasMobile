//
//  AgregarProductos.m
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "AgregarProductos.h"
#import "ConexionServicioWeb.h"
#import "RegistroPrecio.h"
#import "Producto.h"
#import "Establecimiento.h"
#import "Utilidades.h"

@implementation AgregarProductos

+ (NSURLSessionDataTask *)agregarProducto:(RegistroPrecio *)registroPrecio
                                withBlock:(void (^)(NSError *error))block
{
    NSDictionary *parametrosURL = @{@"codigoBarras":registroPrecio.producto.codigoBarras,
                                    @"nombre":registroPrecio.producto.nombre,
                                    @"categoria":registroPrecio.producto.categoria,
                                    @"marca":registroPrecio.producto.marca,
                                    @"modelo":registroPrecio.producto.modelo,
                                    @"cantidad":[NSString stringWithFormat:@"%f", registroPrecio.producto.cantidad],
                                    @"unidadMedida":[NSString stringWithFormat:@"%i",
                                                     (int)[Utilidades idParaUnidadDeMedida:registroPrecio.producto.unidadMedida]],
                                    @"foursquareID":registroPrecio.establecimiento.foursquareID,
                                    @"nombreEstablecimiento":registroPrecio.establecimiento.nombre,
                                    @"direccionEstablecimiento":registroPrecio.establecimiento.direccion,
                                    @"latitud":registroPrecio.establecimiento.latitud,
                                    @"longitud":registroPrecio.establecimiento.longitud,
                                    @"precio":[NSString stringWithFormat:@"%f", registroPrecio.precio]
                                    };
    NSLog(@"%@", parametrosURL);
    
    return [[ConexionServicioWeb clienteCompartido] POST:@"index.php?webservices/registrar_producto_establecimiento_precio/"
                                              parameters:parametrosURL
                                                 success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                NSError *error = nil;
                
                if (estado == 0) {
                    NSDictionary *arregloDataJSON = [JSON valueForKeyPath:@"data"];
                    registroPrecio.producto.productoID = [[arregloDataJSON valueForKeyPath:@"id_producto"] integerValue];
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
                    block(error);
                }
            }
                                                 failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) {
                    block(error);
                }
            }];
}


+ (NSURLSessionDataTask *)subirFotoProducto:(Producto *)producto
                                withBlock:(void (^)(NSError *error))block
{
    NSData *fotoProducto = UIImageJPEGRepresentation(producto.imagen, 1.0f);
    NSDictionary *parametrosURL = @{@"productoID":[NSString stringWithFormat:@"%i", (int)producto.productoID]};
    
    return [[ConexionServicioWeb clienteCompartido] POST:@"index.php?webservices/registrar_imagen_producto/" parameters:parametrosURL constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
    {
        [formData appendPartWithFileData:fotoProducto name:@"imagen_producto" fileName:@"producto.jpeg" mimeType:@"image/jpeg"];
    }
                                                                         success:^(NSURLSessionDataTask * __unused task, id JSON)
                                    {
                                        NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                                        NSError *error = nil;
                                        
                                        if (estado != 0) {
                                            NSString *mensaje = [JSON valueForKeyPath:@"mensaje"];
                                            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                                            [errorDetail setValue:mensaje forKey:NSLocalizedDescriptionKey];
                                            error = [NSError errorWithDomain:@"AhorreMas web server error"
                                                                        code:100
                                                                    userInfo:errorDetail];
                                            NSLog(@"%@", mensaje);
                                        }
                                        
                                        if (block) {
                                            block(error);
                                        }
                                    }
                                                                         failure:^(NSURLSessionDataTask *__unused task, NSError *error)
                                    {
                                        if (block) {
                                            block(error);
                                        }
                                    }];
}

@end

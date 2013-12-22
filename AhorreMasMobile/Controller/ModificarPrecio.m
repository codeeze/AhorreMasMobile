//
//  ModificarPrecio.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/18/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "ModificarPrecio.h"
#import "ConexionServicioWeb.h"

@implementation ModificarPrecio

+ (NSURLSessionDataTask *)modificarPrecioProducto:(NSInteger)productoID
                                enEstablecimiento:(NSInteger)establecimientoID
                                        conPrecio:(NSString *)precio
                                        withBlock:(void (^)(BOOL enviadoConExito, NSError *error))block {
    NSDictionary *parametrosURL = @{@"productoID": [NSNumber numberWithLong:productoID],
                                    @"establecimientoID": [NSNumber numberWithLong:establecimientoID],
                                    @"precio": precio};
    
    return [[ConexionServicioWeb clienteCompartido] POST:@"index.php?webservices/registrar_precio_producto/"
                                              parameters:parametrosURL
                                                 success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                NSError *error = nil;
                BOOL enviadoConExito = NO;
                
                if (estado == 0) {
                    enviadoConExito = YES;
                } else {
                    NSString *mensaje = [JSON valueForKeyPath:@"mensaje"];
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:mensaje forKey:NSLocalizedDescriptionKey];
                    error = [NSError errorWithDomain:@"AhorreMas web server error"
                                                code:100
                                            userInfo:errorDetail];
                    enviadoConExito = NO;
                    NSLog(@"%@", mensaje);
                }
                
                if (block) {
                    block(enviadoConExito, error);
                }
            }
                                                 failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) {
                    block(NO, error);
                }
            }];
}

@end

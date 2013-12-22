//
//  EscanerCodigoBarrasController.m
//  AhorreMasMobile
//
//  Created by Adalberto on 12/5/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import "EscanerCodigoBarrasController.h"
#import "ConexionServicioWeb.h"

@implementation EscanerCodigoBarrasController

+ (NSURLSessionDataTask *)buscarPorCodigoBarras:(NSString *)codigoBarras
                                  estaAgregando:(BOOL)estaAgregando
                                      withBlock:(void (^)(Producto *producto, NSError *error))block {
    NSString *urlConCodigoBarras = [NSString stringWithFormat:@"index.php?webservices/buscar_productos_codigo_barras/%@", codigoBarras];
    
    return [[ConexionServicioWeb clienteCompartido] GET:urlConCodigoBarras
                                             parameters:nil
                                                success:^(NSURLSessionDataTask * __unused task, id JSON)
            {
                NSInteger estado = [[JSON valueForKeyPath:@"estado"] intValue];
                Producto *producto = nil;
                NSError *error = nil;
                
                if (estado == 0) {
                    NSArray *data = [JSON valueForKeyPath:@"data"];
                    
                    if ([data count] > 0) {
                        producto = [[Producto alloc] initConAtributos:[data objectAtIndex:0]];
                    } else if (estaAgregando) {
                        producto = [[Producto alloc] initConCodigoBarras:codigoBarras];
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
                    block(producto, error);
                }
            }
                                                failure:^(NSURLSessionDataTask *__unused task, NSError *error)
            {
                if (block) {
                    block(nil, error);
                }
            }];
}

@end

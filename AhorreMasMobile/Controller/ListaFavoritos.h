//
//  ListaFavoritos.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/17/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListaFavoritos : NSObject

+ (NSURLSessionDataTask *)cargarDatosListaFavoritos:(NSArray *)arregloFavoritos
                                          withBlock:(void (^)(NSArray *arregloDatosProductos, NSError *error))block;

@end

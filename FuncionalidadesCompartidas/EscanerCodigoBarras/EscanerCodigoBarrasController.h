//
//  EscanerCodigoBarrasController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/5/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Producto.h"

@interface EscanerCodigoBarrasController : NSObject

+ (NSURLSessionDataTask *)buscarPorCodigoBarras:(NSString *)codigoBarras
                                  estaAgregando:(BOOL)estaAgregando
                                      withBlock:(void (^)(Producto *producto, NSError *error))block;

@end

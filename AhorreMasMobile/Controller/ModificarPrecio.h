//
//  ModificarPrecio.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/18/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModificarPrecio : UITableViewCell

+ (NSURLSessionDataTask *)modificarPrecioProducto:(NSInteger)productoID
                                enEstablecimiento:(NSInteger)establecimientoID
                                        conPrecio:(NSString *)precio
                               withBlock:(void (^)(BOOL enviadoConExito, NSError *error))block;

@end

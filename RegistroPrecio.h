//
//  RegistroPrecio.h
//  AhorreMasMobile
//
//  Created by Javier Ramirez on 12/1/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Producto.h"
#import "Establecimiento.h"

@interface RegistroPrecio : NSObject

@property Producto *producto;
@property Establecimiento *establecimiento;
@property double precio;

@end

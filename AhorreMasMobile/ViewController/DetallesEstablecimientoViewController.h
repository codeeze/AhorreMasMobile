//
//  DetallesEstablecimientoViewController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Establecimiento.h"
#import "Producto.h"
#import "DetallesProductoViewController.h"

@interface DetallesEstablecimientoViewController : UITableViewController

@property (strong, nonatomic) Establecimiento *establecimiento;
@property (strong, nonatomic) Producto *producto;
@property (weak, nonatomic) DetallesProductoViewController *delegate;

- (void)cargarHistorialPrecios;

@end

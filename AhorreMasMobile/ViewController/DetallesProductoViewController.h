//
//  DetallesProductoViewController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Producto.h"

@interface DetallesProductoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> 

@property (strong, nonatomic) Producto *producto;

- (void)cargarPreciosPorEstablecimiento;

@end

//
//  CeldaDatosProducto.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/16/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Producto.h"

@interface CeldaDatosProducto : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descripcionProducto;
@property (weak, nonatomic) IBOutlet UILabel *marcaProducto;
@property (weak, nonatomic) IBOutlet UILabel *valorMinimo;
@property (weak, nonatomic) IBOutlet UILabel *valorMaximo;
@property (weak, nonatomic) IBOutlet UILabel *diferencia;

- (void)mostrarInformacionDatosProducto:(Producto *)producto;

@end

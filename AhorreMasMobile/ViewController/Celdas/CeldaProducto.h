//
//  CeldaProducto.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/9/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Producto.h"

@interface CeldaProducto : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagenProducto;
@property (weak, nonatomic) IBOutlet UILabel *descripcionProducto;
@property (weak, nonatomic) IBOutlet UILabel *marcaProducto;

- (void)mostrarInformacionProducto:(Producto *)producto;

@end

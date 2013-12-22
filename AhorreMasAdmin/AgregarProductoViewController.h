//
//  AgregarProductoViewController.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoriasViewController.h"
#import "Producto.h"
#import "EstablecimientoViewController.h"

@interface AgregarProductoViewController : UITableViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CategoriasViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, EstablecimientoViewControllerDelegate>

@property Producto *producto;

@end

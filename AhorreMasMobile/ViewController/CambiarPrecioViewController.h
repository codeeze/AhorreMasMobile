//
//  CambiarPrecioViewController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/17/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetallesEstablecimientoViewController.h"

@interface CambiarPrecioViewController : UIViewController

@property (assign, nonatomic) NSInteger productoID;
@property (assign, nonatomic) NSInteger establecimientoID;
@property (weak, nonatomic) DetallesEstablecimientoViewController *delegate;

@end

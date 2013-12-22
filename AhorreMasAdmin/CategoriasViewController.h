//
//  CategoriesViewController.h
//  Precio Digital
//
//  Created by Javier Ramirez on 10/12/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoriasViewControllerDelegate;

@interface CategoriasViewController : UITableViewController

@property (nonatomic, weak) id<CategoriasViewControllerDelegate> delegate;

@end

@protocol CategoriasViewControllerDelegate

- (void) seleccionoCategoria:(NSString *)categoria;

@end

//
//  ResultadosBusquedaViewController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/9/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultadosBusquedaViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSString *valorPorBuscar;

@end

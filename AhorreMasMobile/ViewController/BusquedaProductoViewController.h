//
//  ViewController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 11/26/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EscanerCodigoBarras.h"

@interface BusquedaProductoViewController : UIViewController <EscanerCodigoBarrasDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@end

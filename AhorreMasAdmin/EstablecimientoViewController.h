//
//  EstablishmentSearchViewController.h
//  Precio Digital
//
//  Created by Javier Ramirez on 10/12/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class EstablecimientoFoursquare;

@protocol EstablecimientoViewControllerDelegate;

@interface EstablecimientoViewController : UITableViewController<CLLocationManagerDelegate, UISearchBarDelegate>

@property (nonatomic, weak) id<EstablecimientoViewControllerDelegate> delegate;

@end

@protocol EstablecimientoViewControllerDelegate

@required
- (void) seleccionoEstablecimiento:(EstablecimientoFoursquare *)establecimiento;

@end

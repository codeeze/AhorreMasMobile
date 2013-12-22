//
//  MenuMapaViewController.h
//  AhorreMasMobile
//
//  Created by Adalberto on 12/10/13.
//  Copyright (c) 2013 Codeeze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Establecimiento.h"

@interface MenuMapaViewController : UIViewController <MKAnnotation>

@property (strong, nonatomic) Establecimiento *establecimiento;

@end

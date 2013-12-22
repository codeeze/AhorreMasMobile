//
//  PrecioCell.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kPrecioCellIdentifier;
extern NSInteger const kPrecioTextFieldTag;

@interface PrecioCell : UITableViewCell

@property IBOutlet UITextField *precioTextField;
@property IBOutlet UILabel *monedaLabel;

@end

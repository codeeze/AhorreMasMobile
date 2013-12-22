//
//  CantidadCell.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCantidadCellIdentifier;

extern NSInteger const kMedidaTextFieldTag;

@interface CantidadCell : UITableViewCell

@property IBOutlet UILabel *descripcionLabel;
@property IBOutlet UITextField *cantidadTextField;
@property IBOutlet UIButton *unidadButton;

@end

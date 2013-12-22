//
//  CodigoBarrasCell.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCodigoBarrasCellIdentifier;

@interface CodigoBarrasCell : UITableViewCell

@property IBOutlet UILabel *codigoBarrasLabel;
@property IBOutlet UILabel *descripcionLabel;

@end

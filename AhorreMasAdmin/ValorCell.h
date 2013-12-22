//
//  ValueCell.h
//  Precio Digital
//
//  Created by Adalberto on 10/10/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kValorCellIdentifier;

@interface ValorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

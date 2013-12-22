//
//  InfoProductoCell.h
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kInfoProductoCellIdentifier;

@interface InfoProductoCell : UITableViewCell

@property IBOutlet UILabel *descripcionLabel;
@property IBOutlet UITextField *respuestaTextField;

@end

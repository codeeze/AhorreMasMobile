//
//  CodigoBarrasCell.m
//  Ahorre Mas Admin
//
//  Created by Javier Ramirez on 11/19/13.
//  Copyright (c) 2013 Javier Ramirez. All rights reserved.
//

#import "CodigoBarrasCell.h"

NSString *const kCodigoBarrasCellIdentifier = @"CodigoBarrasCell";

@implementation CodigoBarrasCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

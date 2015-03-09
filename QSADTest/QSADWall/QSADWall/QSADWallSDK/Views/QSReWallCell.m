//
//  QSReWallCell.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-13.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSReWallCell.h"

@implementation QSReWallCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

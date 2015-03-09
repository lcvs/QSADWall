//
//  QSADWallCell.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSADWallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end

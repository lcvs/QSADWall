//
//  QSADWallViewController.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADWall.h"
#import "RedireUrl.h"
#import "QSMKNetworkOperation.h"

@interface QSADWallViewController : UITableViewController
{
    ADWall *_adWallEngine;
    QSMKNetworkOperation *_adWallOP;
    RedireUrl *_redireEngine;
    QSMKNetworkOperation *_redireOP;
}
@property (nonatomic,copy) NSString *appkey;
@property (nonatomic,copy) NSString *uuid;
@end

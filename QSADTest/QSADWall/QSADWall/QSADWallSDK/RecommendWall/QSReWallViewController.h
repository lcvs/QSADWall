//
//  QSReWallViewController.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-13.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReWall.h"
#import "RedireUrl.h"
#import "QSMKNetworkOperation.h"

@interface QSReWallViewController : UITableViewController
{
    ReWall *_reWallEngine;
    QSMKNetworkOperation *_reWallOP;
    RedireUrl *_redireEngine;
    QSMKNetworkOperation *_redireOP;
}
@property (nonatomic,copy) NSString *appkey;
@property (nonatomic,copy) NSString *uuid;
@end

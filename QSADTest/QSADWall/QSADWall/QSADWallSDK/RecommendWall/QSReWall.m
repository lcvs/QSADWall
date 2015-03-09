//
//  QSReWall.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-13.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSReWall.h"
#import "QSReWallViewController.h"
#import "QSKeychainManager.h"
#import "QSGlobalFunction.h"

NSString *_appkey;

@implementation QSReWall

+ (void)setAppKey:(NSString *)appkey{
    _appkey = appkey;
    [QSKeychainManager setKeychain:[QSGlobalFunction md5:[QSGlobalFunction getIDFA]] forIdentifier:@"QSADWall"];
}

+ (void)showReWall:(UIViewController *)viewControllView{
    NSString *uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    QSReWallViewController *qsreWall = [[QSReWallViewController alloc] init];
    qsreWall.appkey = _appkey;
    qsreWall.uuid = uuid;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qsreWall];
    [viewControllView presentViewController:nav animated:YES completion:nil];
}

@end

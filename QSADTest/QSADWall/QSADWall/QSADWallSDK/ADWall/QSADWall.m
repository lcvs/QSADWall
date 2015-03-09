//
//  QSADWall.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-12.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSADWall.h"
#import "QSADWallViewController.h"
#import "QSKeychainManager.h"
#import "QSGlobalFunction.h"

#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态

#define MyLog(...)

#endif

NSString *_appkey;

@implementation QSADWall

+ (void)setAppKey:(NSString *)appkey{
    _appkey = appkey;
    [QSKeychainManager setKeychain:[QSGlobalFunction md5:[QSGlobalFunction getIDFA]] forIdentifier:@"QSADWall"];
}

+ (void)showAdWall:(UIViewController *)viewControllView{
    NSString *uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    QSADWallViewController *qsadWall = [[QSADWallViewController alloc] init];
    qsadWall.appkey = _appkey;
    qsadWall.uuid = uuid;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qsadWall];
    [viewControllView presentViewController:nav animated:YES completion:nil];
}

+ (NSInteger)getCredits{
    NSInteger credits = 0;
    NSString *uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/credits/remained?appkey=%@&uuid=%@",_appkey,uuid]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received) {
        id result = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = (NSDictionary *)result;
            NSDictionary *statusDic = [dataDic objectForKey:@"status"];
            NSString *code = [statusDic objectForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [dataDic objectForKey:@"data"];
                credits = [[dic objectForKey:@"credits"] integerValue];
            }
        }
    }
    return credits;
}

+ (NSInteger)deductCredits:(NSInteger)credits{
    NSInteger deductCredits = 0;
    NSString *uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/credits/deduct?appkey=%@&uuid=%@&credits=%d",_appkey,uuid,credits]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received) {
        id result = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = (NSDictionary *)result;
            NSDictionary *statusDic = [dataDic objectForKey:@"status"];
            NSString *code = [statusDic objectForKey:@"code"];
            if ([code isEqualToString:@"0"]) {
                NSDictionary *dic = [dataDic objectForKey:@"data"];
                deductCredits = [[dic objectForKey:@"credits"] integerValue];
            }
        }
    }
    return deductCredits;
}

@end

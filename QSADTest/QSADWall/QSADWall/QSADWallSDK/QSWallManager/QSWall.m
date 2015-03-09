//
//  QSWall.m
//  QSADWall
//
//  Created by qianshenginfo on 14-8-14.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSWall.h"
#import "QSADWallViewController.h"
#import "QSReWallViewController.h"
#import "QSBanner.h"
#import "QSInsertScreen.h"
#import "QSKeychainManager.h"
#import "QSGlobalFunction.h"
#import "QSMKNetworkOperation.h"

NSString *_appkey;
NSString *_uuid;
BOOL banner = NO;
BOOL screen = NO;
BOOL tj_wall = NO;
BOOL jf_wall = NO;

#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态

#define MyLog(...)

#endif

@implementation QSWall

+ (void)setAppKey:(NSString *)appkey{
    _appkey = appkey;
    [QSKeychainManager setKeychain:[QSGlobalFunction md5:[QSGlobalFunction getIDFA]] forIdentifier:@"QSADWall"];
    _uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    [self managerQSWall];
    
    //NSLog(@"--------idfa:%@------md5:%@------uuid:%@----keyChain:%@",[GlobalFunction getIDFA],[GlobalFunction md5:[GlobalFunction getIDFA]],_uuid,[KeychainManager keychain:@"QSADWall"]?@"YES":@"NO");
}

+ (void)managerQSWall{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/display/show?appkey=%@&uuid=%@",_appkey,_uuid]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received) {
        id result = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDic = (NSDictionary *)result;
            NSDictionary *statusDic = [resultDic objectForKey:@"status"];
            NSString *code = [statusDic objectForKey:@"code"];
            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
            if ([code isEqualToString:@"0"]) {
                banner = [[dataDic objectForKey:@"banner"] boolValue];
                screen = [[dataDic objectForKey:@"screen"] boolValue];
                tj_wall = [[dataDic objectForKey:@"tj_wall"] boolValue];
                jf_wall = [[dataDic objectForKey:@"jf_wall"] boolValue];
            }
        }
    }
}

+ (void)showAdWall:(UIViewController *)viewControllView{
    if (jf_wall) {
        QSADWallViewController *qsadWall = [[QSADWallViewController alloc] init];
        qsadWall.appkey = _appkey;
        qsadWall.uuid = _uuid;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qsadWall];
        [viewControllView presentViewController:nav animated:YES completion:nil];
    }
}

+ (void)showReWall:(UIViewController *)viewControllView{
    if (tj_wall) {
        QSReWallViewController *qsreWall = [[QSReWallViewController alloc] init];
        qsreWall.appkey = _appkey;
        qsreWall.uuid = _uuid;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:qsreWall];
        [viewControllView presentViewController:nav animated:YES completion:nil];
    }
}

+ (void)showBannerWithFrame:(CGRect)rect toView:(UIView *)view{
    if (banner) {
        [QSBanner setAppkey:_appkey];
        QSBanner *banner = [[QSBanner alloc] initWithFrame:rect];
        [view addSubview:banner];
    }
}

+ (void)showInsertScreenWithFrame:(CGRect)rect toView:(UIView *)view{
    if (screen) {
        [QSInsertScreen setAppkey:_appkey];
        QSInsertScreen *insertScreen = [[QSInsertScreen alloc] initWithFrame:rect];
        [view addSubview:insertScreen];
    }
}

+ (NSInteger)getCredits{
    NSInteger credits = 0;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/credits/remained?appkey=%@&uuid=%@",_appkey,_uuid]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/credits/deduct?appkey=%@&uuid=%@&credits=%d",_appkey,_uuid,credits]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3];
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

+ (BOOL)banner{
    return banner;
}

+ (BOOL)screen{
    return screen;
}

+ (BOOL)jf_wall{
    return jf_wall;
}

+ (BOOL)tj_wall{
    return tj_wall;
}

@end

//
//  InsertScreen.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSInsertScreen.h"
#import "UIImageView+QSWebCache.h"
#import "QSGlobalFunction.h"
#import "QSKeychainManager.h"
#import "InsertScreen.h"
#import "RedireUrl.h"
#import "QSMKNetworkOperation.h"

NSString *_appkey;

#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态

#define MyLog(...)

#endif

@interface QSInsertScreen ()
{
    NSMutableDictionary *_insertScreenDic;
    NSString *_uuid;
    InsertScreen *_insertScreenEngine;
    QSMKNetworkOperation *_insertScreenOP;
    RedireUrl *_redireEngine;
    QSMKNetworkOperation *_redireOP;
}
@end

@implementation QSInsertScreen

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self insertScreen];
    }
    return self;
}

+ (void)setAppkey:(NSString *)appkey{
    _appkey = appkey;
    [QSKeychainManager setKeychain:[QSGlobalFunction md5:[QSGlobalFunction getIDFA]] forIdentifier:@"QSADWall"];
}

- (void)createInsertScreen{
    self.userInteractionEnabled = YES;
    [self sd_setImageWithURL:[NSURL URLWithString:[_insertScreenDic objectForKey:@"image"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(insertScreenClick:)];
    [self addGestureRecognizer:tap];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(260, 5, 35, 35);
    [button setBackgroundImage:[UIImage imageNamed:@"QSWallResource.bundle/guanbi.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnCloseClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

#pragma mark - 插屏广告

- (void)insertScreen{
    _uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    _insertScreenDic = [[NSMutableDictionary alloc] init];
    _insertScreenEngine = [[InsertScreen alloc] init];
    _insertScreenOP = [_insertScreenEngine getInsertScreenInfoWithUrlString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/screen/show?appkey=%@&uuid=%@",_appkey,_uuid]];
    [_insertScreenOP addCompletionHandler:^(QSMKNetworkOperation *completedOperation) {
        NSDictionary *JSON = [completedOperation responseJSON];
        NSDictionary * statusDic = [JSON objectForKey:@"status"];
        NSDictionary * dataDic = [JSON objectForKey:@"data"];
        NSString * code = [statusDic objectForKey:@"code"];
        if ([code isEqualToString:@"0"] && dataDic != nil) {
            _insertScreenDic = [dataDic mutableCopy];
            [self createInsertScreen];
        }
        
        MyLog(@"JSON = %@",JSON);
    } errorHandler:^(QSMKNetworkOperation *completedOperation, NSError *error) {
        MyLog(@"%@",[error localizedDescription]);
    }];
}

#pragma mark - 插屏广告回调

- (void)redirectUrl:(NSString *)appid{
    _redireEngine = [[RedireUrl alloc] init];
    _redireOP = [_redireEngine redirectWithUrlString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/screen/click?appkey=%@&mac=%@&idfa=%@&appid=%@&uuid=%@",_appkey,[QSGlobalFunction getMacAddress],[QSGlobalFunction getIDFA],appid,_uuid]];
    [_redireOP addCompletionHandler:^(QSMKNetworkOperation *completedOperation) {
        NSDictionary *JSON = [completedOperation  responseJSON];
        
        MyLog(@"JSON = %@",JSON);
    } errorHandler:^(QSMKNetworkOperation *completedOperation, NSError *error) {
        MyLog(@"%@",[error localizedDescription]);
    }];
}

- (void)btnCloseClick{
    self.hidden = YES;
}

- (void)insertScreenClick:(UITapGestureRecognizer *)tap{
    self.hidden = YES;
    NSString *redirectUrl = [_insertScreenDic objectForKey:@"redirect"];
    [self redirectUrl:[_insertScreenDic objectForKey:@"appid"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl]];
}

@end

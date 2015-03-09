//
//  GlobalFunction.h
//  AdSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSGlobalFunction : NSObject
//获取IDFA
+ (NSString *)getIDFA;

//获取用户IP地址
+ (NSString *)getIPAddress;

//获取mac地址
+ (NSString *)getMacAddress;

//得到16位小写md5
+ (NSString *)md5:(NSString *)string;
@end

//
//  KeychainManager.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-12.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSKeychainManager : NSObject

/**
 *  设置keychain
 */
+ (void)setKeychain:(NSString *)object forIdentifier:(NSString *)identifier;

/**
 *  重置keychain
 */
+ (void)resetKeychain:(NSString *)identifier;

/**
 *  获取keychain
 */
+ (NSString *)getKeychain:(NSString *)identifier;

/**
 *  是否存在keychain
 */
+ (BOOL)keychain:(NSString *)identifier;

@end

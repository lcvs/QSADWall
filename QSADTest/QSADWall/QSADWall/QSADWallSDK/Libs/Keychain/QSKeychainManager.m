//
//  KeychainManager.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-12.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSKeychainManager.h"
#import "QSKeychainItemWrapper.h"

@implementation QSKeychainManager

+ (void)setKeychain:(NSString *)object forIdentifier:(NSString *)identifier{
    QSKeychainItemWrapper *keyChain = [[QSKeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    //[keyChain resetKeychainItem];
    NSString *string = [keyChain objectForKey:(__bridge id)kSecAttrAccount];
    if ([string isEqualToString:@""]) {
        [keyChain setObject:object forKey:(__bridge id)kSecAttrAccount];
    }
}

+ (void)resetKeychain:(NSString *)identifier{
    QSKeychainItemWrapper *keyChain = [[QSKeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    [keyChain resetKeychainItem];
}

+ (NSString *)getKeychain:(NSString *)identifier{
    QSKeychainItemWrapper *keyChain = [[QSKeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    return [keyChain objectForKey:(__bridge id)kSecAttrAccount];
}

+ (BOOL)keychain:(NSString *)identifier{
    QSKeychainItemWrapper *keyChain = [[QSKeychainItemWrapper alloc] initWithIdentifier:identifier accessGroup:nil];
    NSString *string = [keyChain objectForKey:(__bridge id)kSecAttrAccount];
    if (string == nil) {
        return NO;
    }else{
        return YES;
    }
}


@end

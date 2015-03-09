//
//  QSADWall.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-12.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QSADWall : NSObject

/**
 *  设置QSADWall(积分墙)的唯一appKey
 */
+ (void)setAppKey:(NSString *)appkey;

/**
 *  显示积分墙
 */
+ (void)showAdWall:(UIViewController *)viewControllView;

/**
 *  查询积分
 */
+ (NSInteger)getCredits;

/**
 *  删除积分
 */
+ (NSInteger)deductCredits:(NSInteger)credits;

@end

//
//  QSWall.h
//  QSADWall
//
//  Created by qianshenginfo on 14-8-14.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QSWall : NSObject

/**
 *  设置QSWall的appKey
 */
+ (void)setAppKey:(NSString *)appkey;

/**
 *  显示积分墙
 */
+ (void)showAdWall:(UIViewController *)viewControllView;

/**
 *  显示推荐墙
 */
+ (void)showReWall:(UIViewController *)viewControllView;

/**
 *  显示广告条
 */
+ (void)showBannerWithFrame:(CGRect)rect toView:(UIView *)view;

/**
 *  显示插屏
 */
+ (void)showInsertScreenWithFrame:(CGRect)rect toView:(UIView *)view;

/**
 *  查询积分
 */
+ (NSInteger)getCredits;

/**
 *  删除积分
 */
+ (NSInteger)deductCredits:(NSInteger)credits;

/**
 *  是否隐藏banner条
 */
+ (BOOL)banner;

/**
 *  是否隐藏插屏广告
 */
+ (BOOL)screen;

/**
 *  是否隐藏积分墙
 */
+ (BOOL)jf_wall;

/**
 *  是否隐藏推荐墙
 */
+ (BOOL)tj_wall;

@end

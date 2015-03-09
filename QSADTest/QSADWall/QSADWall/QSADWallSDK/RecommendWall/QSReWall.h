//
//  QSReWall.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-13.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QSReWall : NSObject

/**
 *  设置QSReWall(推荐墙)的唯一appKey
 */
+ (void)setAppKey:(NSString *)appkey;

/**
 *  显示推荐墙
 */
+ (void)showReWall:(UIViewController *)viewControllView;

@end

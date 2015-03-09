//
//  ReWall.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-13.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSMKNetworkEngine.h"

@interface ReWall : QSMKNetworkEngine
-(QSMKNetworkOperation *)getReWallInfoWithUrlString:(NSString *)urlString;
@end

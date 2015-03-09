//
//  Banner.h
//  yhz
//
//  Created by qianshenginfo on 14-7-29.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSMKNetworkEngine.h"

@interface Banner : QSMKNetworkEngine
-(QSMKNetworkOperation *)getBannerInfoWithUrlString:(NSString *)urlString;
@end

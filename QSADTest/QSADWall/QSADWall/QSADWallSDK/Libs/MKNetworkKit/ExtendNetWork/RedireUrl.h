//
//  RedireUrl.h
//  yhz
//
//  Created by qianshenginfo on 14-7-29.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSMKNetworkEngine.h"

@interface RedireUrl : QSMKNetworkEngine
-(QSMKNetworkOperation *)redirectWithUrlString:(NSString *)urlString;
@end

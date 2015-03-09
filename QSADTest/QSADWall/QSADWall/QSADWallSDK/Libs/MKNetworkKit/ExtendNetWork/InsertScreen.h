//
//  InsertScreen.h
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSMKNetworkEngine.h"

@interface InsertScreen : QSMKNetworkEngine
-(QSMKNetworkOperation *)getInsertScreenInfoWithUrlString:(NSString *)urlString;
@end

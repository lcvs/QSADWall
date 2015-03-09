//
//  InsertScreen.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "InsertScreen.h"

@implementation InsertScreen
-(QSMKNetworkOperation *)getInsertScreenInfoWithUrlString:(NSString *)urlString{
    QSMKNetworkOperation *op = [self operationWithURLString:urlString];
    op.postDataEncoding=MKNKPostDataEncodingTypeJSON;
    [self enqueueOperation:op];
    return op;
}
@end

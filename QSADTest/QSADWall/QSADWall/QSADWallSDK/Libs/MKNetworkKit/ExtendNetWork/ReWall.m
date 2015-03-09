//
//  ReWall.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-13.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "ReWall.h"

@implementation ReWall
- (QSMKNetworkOperation *)getReWallInfoWithUrlString:(NSString *)urlString{
    QSMKNetworkOperation *op = [self operationWithURLString:urlString];
    op.postDataEncoding=MKNKPostDataEncodingTypeJSON;
    [self enqueueOperation:op];
    return op;
}
@end

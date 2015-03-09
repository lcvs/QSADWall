//
//  Banner.m
//  yhz
//
//  Created by qianshenginfo on 14-7-29.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "Banner.h"

@implementation Banner
- (QSMKNetworkOperation *)getBannerInfoWithUrlString:(NSString *)urlString{
    QSMKNetworkOperation *op = [self operationWithURLString:urlString];
    op.postDataEncoding=MKNKPostDataEncodingTypeJSON;
    [self enqueueOperation:op];
    return op;
}
@end

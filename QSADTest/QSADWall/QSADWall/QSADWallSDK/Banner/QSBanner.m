//
//  QSBanner.m
//  AdSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSBanner.h"
#import "UIImageView+QSWebCache.h"
#import "QSGlobalFunction.h"
#import "QSKeychainManager.h"
#import "Banner.h"
#import "RedireUrl.h"
#import "QSMKNetworkOperation.h"

NSString *_appkey;

#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态

#define MyLog(...)

#endif

@interface QSBanner ()
{
    NSMutableArray *_bannerArray;
    UIImageView *_imageView;
    UIPageControl *_pageControl;
    NSInteger _currentIndex;
    NSTimer *_timer;
    NSString *_uuid;
    Banner *_bannerEngine;
    QSMKNetworkOperation *_bannerOP;
    RedireUrl *_redireEngine;
    QSMKNetworkOperation *_redireOP;
}
@end

@implementation QSBanner

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self receiveBanner];
    }
    return self;
}

+ (void)setAppkey:(NSString *)appkey{
    _appkey = appkey;
    [QSKeychainManager setKeychain:[QSGlobalFunction md5:[QSGlobalFunction getIDFA]] forIdentifier:@"QSADWall"];
}

- (void)receiveBanner{
    _uuid = [QSKeychainManager getKeychain:@"QSADWall"];
    _bannerArray = [[NSMutableArray alloc] init];
    _bannerEngine = [[Banner alloc] init];
    _bannerOP = [_bannerEngine getBannerInfoWithUrlString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/banner/list?appkey=%@&uuid=%@",_appkey,_uuid]];
    [_bannerOP addCompletionHandler:^(QSMKNetworkOperation *completedOperation) {
        NSDictionary *JSON = [completedOperation responseJSON];
        NSDictionary * statusDic = [JSON objectForKey:@"status"];
        NSArray * dataArray = [JSON objectForKey:@"data"];
        NSString * code = [statusDic objectForKey:@"code"];
        if ([code isEqualToString:@"0"] && dataArray.count != 0) {
            _bannerArray = [dataArray mutableCopy];
            [self createBanner];
        }
        MyLog(@"JSON = %@",JSON);
    } errorHandler:^(QSMKNetworkOperation *completedOperation, NSError *error) {
        MyLog(@"%@",[error localizedDescription]);
    }];
}

- (void)redirectUrl:(NSString *)appid{
    _redireEngine = [[RedireUrl alloc] init];
    _redireOP = [_redireEngine redirectWithUrlString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/banner/click?appkey=%@&appid=%@&mac=%@&idfa=%@&uuid=%@",_appkey,appid,[QSGlobalFunction getMacAddress],[QSGlobalFunction getIDFA],_uuid]];
    [_redireOP addCompletionHandler:^(QSMKNetworkOperation *completedOperation) {
        NSDictionary *JSON = [completedOperation  responseJSON];
        
        MyLog(@"JSON = %@",JSON);
    } errorHandler:^(QSMKNetworkOperation *completedOperation, NSError *error) {
        MyLog(@"%@",[error localizedDescription]);
    }];
}

- (void)createBanner{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = self;
    self.contentSize = CGSizeMake(_bannerArray.count*[UIScreen mainScreen].bounds.size.width, 50);
    for (int i = 0; i < _bannerArray.count; i++) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        [self addSubview:_imageView];
        _imageView.tag = 500+i;
        NSDictionary *dic = [_bannerArray objectAtIndex:i];
        NSString *url = [dic objectForKey:@"imgUrl"];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        NSString *redirectUrl = [dic objectForKey:@"redirectUrl"];
        _imageView.userInteractionEnabled = YES;
        if (redirectUrl.length == 0) {
            _imageView.userInteractionEnabled = NO;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
        [_imageView addGestureRecognizer:tap];
    }
    //创建分页控制器
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 470, [UIScreen mainScreen].bounds.size.width, 30)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = _bannerArray.count;
    _pageControl.currentPage = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(moveScrollView) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint pt = scrollView.contentOffset;
    //当前页数
    _pageControl.currentPage = pt.x/[UIScreen mainScreen].bounds.size.width;
}

- (void)imageViewClick:(UITapGestureRecognizer *)tap{
    NSDictionary *dic = [_bannerArray objectAtIndex:tap.view.tag-500];
    NSString *redirectUrl = [dic objectForKey:@"redirectUrl"];
    [self redirectUrl:[dic objectForKey:@"appid"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl]];
}

- (void)moveScrollView{
    _currentIndex = _pageControl.currentPage;
    if (_currentIndex == _bannerArray.count-1) {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
        _currentIndex = -1;
    }
    _currentIndex ++;
    [self setContentOffset:CGPointMake(_currentIndex*[UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    _pageControl.currentPage = _currentIndex;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

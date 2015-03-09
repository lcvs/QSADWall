//
//  QSADWallViewController.m
//  QSADSDK
//
//  Created by qianshenginfo on 14-8-11.
//  Copyright (c) 2014年 qianshenginfo. All rights reserved.
//

#import "QSADWallViewController.h"
#import "QSADWallModel.h"
#import "QSADWallCell.h"
#import "UIImageView+QSWebCache.h"
#import "QSGlobalFunction.h"
#import "QSMJRefresh.h"

#ifdef DEBUG
//调试状态
#define MyLog(...) NSLog(__VA_ARGS__)

#else
//发布状态

#define MyLog(...)

#endif

@interface QSADWallViewController ()
{
    NSMutableArray *_dataArray;
    UIView *_bgView;
}
@end

NSString *_appkey;

@implementation QSADWallViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addHeaderWithTarget:self action:@selector(refreshView)];
    [self createNavigationBar];
    [self getAdWallInfo];
}

- (void)refreshView{
    [self getAdWallInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createNavigationBar{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 15);
    [button setBackgroundImage:[UIImage imageNamed:@"QSWallResource.bundle/boult.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonItem;
    self.navigationItem.title = @"免费得钻石";
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.29 green:0.82 blue:0.95 alpha:1]];
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
}

- (void)getAdWallInfo{
    _adWallEngine = [[ADWall alloc] init];
    _adWallOP = [_adWallEngine getADWallInfoWithUrlString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/jifenwall/list?appkey=%@&uuid=%@",_appkey,_uuid]];
    [_adWallOP addCompletionHandler:^(QSMKNetworkOperation *completedOperation) {
        [_dataArray removeAllObjects];
        NSDictionary *JSON = [completedOperation responseJSON];
        NSDictionary *statusDic = [JSON objectForKey:@"status"];
        NSArray *dataArray = [JSON objectForKey:@"data"];
        NSString *code = [statusDic objectForKey:@"code"];
        if ([code isEqualToString:@"0"] && dataArray.count != 0) {
            for (NSDictionary *dic in dataArray) {
                QSADWallModel *model = [[QSADWallModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        MyLog(@"JSON = %@",JSON);
        [self.tableView headerEndRefreshing];
    } errorHandler:^(QSMKNetworkOperation *completedOperation, NSError *error) {
        MyLog(@"%@",[error localizedDescription]);
        [self.tableView headerEndRefreshing];
    }];
}

- (void)redireUrl:(NSString *)appid{
    _redireEngine = [[RedireUrl alloc] init];
    _redireOP = [_redireEngine redirectWithUrlString:[NSString stringWithFormat:@"http://gameads.qianshenginfo.com/jifenwall/click?appkey=%@&mac=%@&idfa=%@&appid=%@&uuid=%@",_appkey,[QSGlobalFunction getMacAddress],[QSGlobalFunction getIDFA],appid,_uuid]];
    [_redireOP addCompletionHandler:^(QSMKNetworkOperation *completedOperation) {
        NSDictionary *JSON = [completedOperation responseJSON];
        MyLog(@"JSON = %@",JSON);
    } errorHandler:^(QSMKNetworkOperation *completedOperation, NSError *error) {
        MyLog(@"%@",[error localizedDescription]);
    }];
}

- (void)buttonItemClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSADWallCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QSADWallCell"];
    if (cell == nil) {
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"QSWallResource" withExtension:@"bundle"]];
        cell = [[bundle loadNibNamed:@"QSADWallCell" owner:self options:nil] lastObject];
    }
    QSADWallModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.appIcon]];
    cell.iconImageView.layer.masksToBounds = YES;
    cell.iconImageView.layer.cornerRadius = 10.0;
    cell.titleLabel.text = model.appName;
    cell.descLabel.text = model.desc;
    cell.bgImageView.backgroundColor = [UIColor orangeColor];
    cell.incomeLabel.numberOfLines = 2;
    cell.incomeLabel.textAlignment = NSTextAlignmentCenter;
    cell.incomeLabel.text = [NSString stringWithFormat:@"%@\n钻石",model.income];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QSADWallModel *model = [_dataArray objectAtIndex:indexPath.row];
    _bgView = [[UIView alloc] init];
    _bgView.frame = [UIScreen mainScreen].bounds;
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _bgView.userInteractionEnabled = YES;
    _bgView.alpha = 0.0;
    [self.navigationController.view addSubview:_bgView];
    if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) || ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft)) {
        _bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_bgView.frame.size.width-300)/2, (_bgView.frame.size.height-180)/2, 300, 180)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //imageView.center = _bgView.center;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 8;
    imageView.userInteractionEnabled = YES;
    [_bgView addSubview:imageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(260, 10, 24, 24);
    [button setBackgroundImage:[UIImage imageNamed:@"QSWallResource.bundle/ADWallClose.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [imageView addSubview:button];
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 320, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [imageView addSubview:lineLabel];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 50, 50)];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 10.0;
    iconImageView.backgroundColor = [UIColor clearColor];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:model.appIcon]];
    [imageView addSubview:iconImageView];
    UILabel *appNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 120, 50)];
    appNamelabel.text = model.appName;
    appNamelabel.font = [UIFont boldSystemFontOfSize:17];
    appNamelabel.backgroundColor = [UIColor clearColor];
    [imageView addSubview:appNamelabel];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 280, 40)];
    descLabel.textColor = [UIColor orangeColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = [UIFont boldSystemFontOfSize:15];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.adjustsFontSizeToFitWidth = YES;
    [imageView addSubview:descLabel];
    NSString *text = [NSString stringWithFormat:@"获取条件：%@",model.desc];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:15]} range:NSMakeRange(0, 5)];
    descLabel.attributedText = attributeString;
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.tag = indexPath.row;
    skipButton.frame = CGRectMake(0, 130, 320, 50);
    skipButton.backgroundColor = [UIColor orangeColor];
    [skipButton setTitle:[NSString stringWithFormat:@"免费赚取%@钻石",model.income] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipAppStore:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:skipButton];
    
    [UIView beginAnimations:@"ShowArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(showArrowDidStop:finished:context:)];
    // Make the animatable changes.
    _bgView.alpha = 1.0;
    // Commit the changes and perform the animation.
    [UIView commitAnimations];
}

- (void)closeAlertView{
    [UIView beginAnimations:@"HideArrow" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    _bgView.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)skipAppStore:(UIButton *)sender{
    QSADWallModel *model = [_dataArray objectAtIndex:sender.tag];
    [self redireUrl:model.appid];
    [self closeAlertView];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.itunes]];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
        _bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    if ((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
        _bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

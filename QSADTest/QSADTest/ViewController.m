//
//  ViewController.m
//  QSADTest
//
//  Created by 黎晨 on 15/3/9.
//  Copyright (c) 2015年 LC. All rights reserved.
//

#import "ViewController.h"
#import "QSWall.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [QSWall setAppKey:@"54113a3a7bec3"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)integerWall:(id)sender {
    [QSWall showAdWall:self];
}

- (IBAction)recommendWall:(id)sender {
    [QSWall showReWall:self];
}

- (IBAction)banner:(id)sender {
    [QSWall showBannerWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50) toView:self.view];
}

- (IBAction)insertScreen:(id)sender {
    [QSWall showInsertScreenWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-300)/2, ([UIScreen mainScreen].bounds.size.height-250)/2, 300, 250) toView:self.view];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

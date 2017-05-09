//
//  JDFunctionListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/7.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDFunctionListViewController.h"

@interface JDFunctionListViewController ()

@end

@implementation JDFunctionListViewController

- (void)viewDidLoad {//
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"签字效果",@"ClassName":@"JDSignListViewController"},
                           @{@"title":@"二维码扫描",@"ClassName":@"JDCodeImageViewController"},
                           @{@"title":@"touchID功能",@"ClassName":@"JDTouchIDViewController"},
                           @{@"title":@"APP评分功能功能",@"ClassName":@"JDAppStoreScoreViewController"},
                           @{@"title":@"浏览器封装",@"ClassName":@"JDWebBrowserViewController"},
                           @{@"title":@"摄像头处理功能",@"ClassName":@"JDCameraFuctionViewController"},

                           ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

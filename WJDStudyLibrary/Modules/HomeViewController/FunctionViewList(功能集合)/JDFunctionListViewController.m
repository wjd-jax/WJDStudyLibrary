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
                           @{@"title":@"引导页封装",@"ClassName":@"JDGuideTestViewController"},
                           @{@"title":@"系统新版本功能封装",@"ClassName":@"JDNewFunctionViewController"},
                           @{@"title":@"获取手机信息",@"ClassName":@"IPhoneInfoStoryboard"},
                           @{@"title":@"通讯录封装",@"ClassName":@"ContactsStoryboard"},
                           @{@"title":@"本地推送(闹钟)",@"ClassName":@"JDLocaNotificationViewController"},
                           @{@"title":@"加载动画",@"ClassName":@"JDLoadingDemoViewController"},

                           ];

}

 

@end

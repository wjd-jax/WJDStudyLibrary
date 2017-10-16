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
    self.dataSoureArray =@[@{@"title":@"签字效果",@"className":@"JDSignListViewController"},
                           @{@"title":@"二维码扫描",@"className":@"JDCodeImageViewController"},
                           @{@"title":@"touchID功能",@"className":@"JDTouchIDViewController"},
                           @{@"title":@"APP评分功能功能",@"className":@"JDAppStoreScoreViewController"},
                           @{@"title":@"浏览器封装",@"className":@"JDWebBrowserViewController"},
                           @{@"title":@"摄像头处理功能",@"className":@"JDCameraFuctionViewController"},
                           @{@"title":@"引导页封装",@"className":@"JDGuideTestViewController"},
                           @{@"title":@"系统新版本功能封装",@"className":@"JDNewFunctionViewController"},
                           @{@"title":@"获取手机信息",@"className":@"IPhoneInfoStoryboard"},
                           @{@"title":@"通讯录封装",@"className":@"ContactsStoryboard"},
                           @{@"title":@"本地推送(闹钟)",@"className":@"JDLocaNotificationViewController"},
                           @{@"title":@"加载动画",@"className":@"JDLoadingDemoViewController"},
                           @{@"title":@"系统分享功能",@"className":@"JDSocialShareTableViewController"},
                            @{@"title":@"Wifi文文件传输",@"className":@"JDWifiViewController"},

                           ];

}

 

@end

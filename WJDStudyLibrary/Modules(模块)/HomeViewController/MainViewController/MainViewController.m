//
//  MainViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "MainViewController.h"
#import "JDMainDataModel.h"
#import "JDAboutUsViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

  
    //
    self.navigationItem.title =@"IOS 知识库";
    self.dataSoureArray =@[
                           //用于测试的页面
                           @{@"title":@"临时页面",@"className":@"JDWifiViewController"},
                           @{@"title":@"视图效果",@"className":@"JDViewListViewController"},
                           @{@"title":@"功能集合(直接拿来用)",@"className":@"JDFunctionListViewController"},
                           @{@"title":@"自动布局",@"className":@"JDAutoLayoutViewController"},
                           @{@"title":@"网络封装",@"className":@"JDNetWorkingViewController"},
                           @{@"title":@"加密解密",@"className":@"JDEncryptionListViewController"},
                           @{@"title":@"图像处理",@"className":@"ImageProcessingStoryboard"},
                           @{@"title":@"动画效果",@"className":@"JDAnimationListViewController"},
                           @{@"title":@"自定义控件",@"className":@"JDCustomControlsViewController"},
                           @{@"title":@"学习网站",@"className":@"JDStudyWebListViewController"},
                           @{@"title":@"音视频播放",@"className":@""},
                           @{@"title":@"常用工具集合",@"className":@"JDCustomToolViewController"},

                           ];
    
    
    UIBarButtonItem *rightButton =[JDUtils createTextBarButtonWithTitle:@"关于" Target:self Action:@selector(aboutClick)];
    self.navigationItem.rightBarButtonItem =rightButton;
}



- (void)aboutClick {
    JDAboutUsViewController *avc =[[JDAboutUsViewController alloc]init];
    [self.navigationController pushViewController:avc animated:YES];
}

@end

//
//  MainViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "MainViewController.h"
#import "ArrayDataSource.h"
#import "JDMainDataModel.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
    self.title =@"IOS 知识库";
    self.dataSoureArray =@[
                           @{@"title":@"知识大全",@"ClassName":@"JDKnowledgeViewController"},
                           @{@"title":@"视图效果",@"ClassName":@"JDViewListViewController"},
                           @{@"title":@"功能集合",@"ClassName":@"JDFunctionListViewController"},
                           @{@"title":@"网络封装",@"ClassName":@"JDNetWorkingViewController"},
                           @{@"title":@"加密解密",@"ClassName":@"JDEncryptionListViewController"},
                           @{@"title":@"图像处理",@"ClassName":@"ImageProcessingStoryboard"},
                           @{@"title":@"动画效果",@"ClassName":@"JDAnimationListViewController"},
                           @{@"title":@"自定义控件",@"ClassName":@"JDCustomControlsViewController"},
                           @{@"title":@"临时页面",@"ClassName":@"JDGuideTestViewController"},

                           ];
    
}


@end

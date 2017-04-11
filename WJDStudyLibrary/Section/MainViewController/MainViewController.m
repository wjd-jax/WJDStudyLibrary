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
    
    self.dataSoureArray =@[@{@"title":@"知识大全",@"ClassName":@"JDKnowledgeViewController"},
                           @{@"title":@"视图效果",@"ClassName":@"JDViewListViewController"},
                           @{@"title":@"布局视图",@"ClassName":@"JDLayoutListViewController"},
                           @{@"title":@"小功能集合",@"ClassName":@"JDFunctionListViewController"},
                           @{@"title":@"网络封装",@"ClassName":@"JDNetWorkingViewController"},
                           @{@"title":@"临时页面",@"ClassName":@"JDTestViewController"}];
    
}


@end

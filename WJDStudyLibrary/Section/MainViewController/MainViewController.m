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

    self.dataSoureArray =@[@{@"title":@"知识大全",@"ClassName":@"JDKnowledgeViewController"},
                           @{@"title":@"视图效果",@"ClassName":@"JDViewListViewController"},
                           @{@"title":@"第三行",@"ClassName":@"第一行"}];
   
}


@end

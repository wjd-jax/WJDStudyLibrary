//
//  JDViewListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//


#import "JDViewListViewController.h"


@implementation JDViewListViewController



-(void)viewDidLoad
{
    [super viewDidLoad];

    self.dataSoureArray = @[@{@"title":@"自定义弹出视图",@"ClassName":@"JDPopViewController"},
                            @{@"title":@"引导页视图",@"ClassName":@"JDGuideViewController"},
                            @{@"title":@"布局视图",@"ClassName":@"JDLayoutListViewController"},
                            @{@"title":@"封装View引导页演示",@"ClassName":@"JDGuideDemoViewController"},
                            ];
}

@end


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

    self.dataSoureArray = @[@{@"title":@"弹出视图",@"ClassName":@"JDPopViewController"},
                            @{@"title":@"引导页视图",@"ClassName":@"JDGuideViewController"}
                            ];
}

@end

//
//  JDLayoutListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/7.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDLayoutListViewController.h"

@interface JDLayoutListViewController ()

@end

@implementation JDLayoutListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"浏览卡片",@"className":@"JDCardLayoutStoryboard"},
                           @{@"title":@"瀑布流布局视图",@"className":@"JDWaterFallLayoutViewController"}];

}

@end

//
//  JDCustomToolViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCustomToolViewController.h"

@interface JDCustomToolViewController ()

@end

@implementation JDCustomToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           //用于测试的页面
                           @{@"title":@"代码统计",@"className":@"CodeCountStoryboard"},
                           @{@"title":@"随机数",@"className":@"RealRandomStoryboard"},
                           ];
    
}



@end

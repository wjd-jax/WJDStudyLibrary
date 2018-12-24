//
//  JDAboutUsViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAboutUsViewController.h"

@interface JDAboutUsViewController ()

@end

IB_DESIGNABLE
@implementation JDAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

 

@end

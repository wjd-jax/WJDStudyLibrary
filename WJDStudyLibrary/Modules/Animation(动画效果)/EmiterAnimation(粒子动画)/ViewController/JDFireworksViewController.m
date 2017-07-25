//
//  JDFireworksViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/17.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDFireworksViewController.h"
#import "JDFireworksView.h"

@interface JDFireworksViewController ()

@end

@implementation JDFireworksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JDFireworksView *view =[[JDFireworksView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}

 

@end

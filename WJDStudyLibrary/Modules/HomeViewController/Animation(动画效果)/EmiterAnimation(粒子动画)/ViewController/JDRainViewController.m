//
//  JDRainViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/18.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDRainViewController.h"
#import "JDRainView.h"

@interface JDRainViewController ()

@end

@implementation JDRainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JDRainView *rainView =[[JDRainView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHT, SCREEN_HEIGHT-64)];
    [self.view addSubview:rainView];
}

 

@end

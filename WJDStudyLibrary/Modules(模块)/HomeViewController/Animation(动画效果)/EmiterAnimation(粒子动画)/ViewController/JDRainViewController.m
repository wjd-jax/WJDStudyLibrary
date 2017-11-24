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
    
    self.view.backgroundColor =[UIColor whiteColor];
    UIImageView *v =[JDUtils createImageViewWithFrame:self.view.bounds ImageName:@"bg_002"];
    [self.view addSubview:v];
//
    JDRainView *rainView =[[JDRainView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHT, SCREEN_HEIGHT-64)];
    rainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rainView];
}

 

@end

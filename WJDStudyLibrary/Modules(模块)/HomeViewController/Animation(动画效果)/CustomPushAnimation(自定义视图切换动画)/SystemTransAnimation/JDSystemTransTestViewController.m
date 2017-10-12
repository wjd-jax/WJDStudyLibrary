//
//  JDSystemTransTestViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDSystemTransTestViewController.h"

@interface JDSystemTransTestViewController ()

@end

@implementation JDSystemTransTestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIButton *button =[JDUtils createSystemButtonWithFrame:CGRectMake(0, 0, 100, 30) Target:self Action:@selector(backClick) Title:@"返回"];
    button.backgroundColor =[UIColor whiteColor];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];

    // Do any additional setup after loading the view.
}

- (void)backClick
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

 

@end

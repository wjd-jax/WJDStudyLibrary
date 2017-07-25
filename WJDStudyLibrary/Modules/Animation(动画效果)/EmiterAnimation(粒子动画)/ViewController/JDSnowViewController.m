//
//  JDSnowViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/17.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDSnowViewController.h"
#import "JDSnowView.h"

@interface JDSnowViewController ()

@end

@implementation JDSnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"下雪效果";
    JDSnowView *snow = [[JDSnowView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:snow];
    // Do any additional setup after loading the view.
}

 

@end

//
//  JDCAKeyframeAnimationViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCAKeyframeAnimationViewController.h"
#import "JDHeadView.h"

@interface JDCAKeyframeAnimationViewController ()

@end

@implementation JDCAKeyframeAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JDHeadView *headView =[[JDHeadView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    headView.backgroundColor =[UIColor whiteColor];
    headView.center =self.view.center;
    [self.view addSubview:headView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

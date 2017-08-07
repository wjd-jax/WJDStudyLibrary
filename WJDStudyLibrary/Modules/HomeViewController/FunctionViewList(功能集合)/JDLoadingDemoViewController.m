//
//  JDLoadingDemoViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDLoadingDemoViewController.h"
#import "JDLoadingView.h"

@interface JDLoadingDemoViewController ()

@end

@implementation JDLoadingDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JDLoadingView showView:self.view];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JDLoadingView hide];
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

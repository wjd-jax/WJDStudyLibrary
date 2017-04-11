//
//  JDSignViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/7.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDSignViewController.h"
#import "TZSignView.h"
@interface JDSignViewController ()

@end

@implementation JDSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"请手写会出轨迹";
    EAGLContext *context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    TZSignView *sign = [[TZSignView alloc] initWithFrame:self.view.bounds context:context];
    [self.view addSubview:sign];
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

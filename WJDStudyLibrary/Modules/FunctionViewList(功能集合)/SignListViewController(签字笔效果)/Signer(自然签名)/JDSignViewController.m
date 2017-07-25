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

 

@end

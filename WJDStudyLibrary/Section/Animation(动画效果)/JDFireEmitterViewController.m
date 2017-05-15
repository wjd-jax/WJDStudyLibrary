//
//  JDFireEmitterViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDFireEmitterViewController.h"
#import "JDFireEmitterView.h"

@interface JDFireEmitterViewController ()



@end

@implementation JDFireEmitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    JDFireEmitterView *fire =[[JDFireEmitterView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:fire];

}


@end

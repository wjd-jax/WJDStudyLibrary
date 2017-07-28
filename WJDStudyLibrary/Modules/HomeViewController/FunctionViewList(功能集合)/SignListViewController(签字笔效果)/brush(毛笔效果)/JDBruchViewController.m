//
//  JDBruchViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBruchViewController.h"
#import "AFBrushBoard.h"

@interface JDBruchViewController ()

@end

@implementation JDBruchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFBrushBoard *brushView =[[AFBrushBoard alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:brushView];
    // Do any additional setup after loading the view.
}

 

@end

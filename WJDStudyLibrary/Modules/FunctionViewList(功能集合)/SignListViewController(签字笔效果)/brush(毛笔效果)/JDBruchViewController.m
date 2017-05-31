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

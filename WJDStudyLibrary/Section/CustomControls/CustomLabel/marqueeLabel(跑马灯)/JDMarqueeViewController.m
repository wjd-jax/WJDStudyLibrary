//
//  JDMarqueeViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDMarqueeViewController.h"
#import "JDMarqueeView.h"

@interface JDMarqueeViewController ()

@end

@implementation JDMarqueeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JDMarqueeView *view =[[JDMarqueeView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHT, 44) andMessage:@"这是一个跑马灯很长哈哈哈哈--------------->>>>>>>"];
    [self.view addSubview:view];
    
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

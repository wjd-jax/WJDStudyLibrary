//
//  JDWaterWaveViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDWaterWaveViewController.h"
#import "JDWaterWaveView.h"

@interface JDWaterWaveViewController ()
{
    JDWaterWaveView *waterWaveView;
}
@end

@implementation JDWaterWaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    waterWaveView =[[JDWaterWaveView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHT, SCREEN_HEIGHT/2)];
    [self.view addSubview:waterWaveView];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [waterWaveView stopWave];
}
-(void)dealloc
{
    DLog(@"JDWaterWaveViewController.h界面释放了");
}

@end

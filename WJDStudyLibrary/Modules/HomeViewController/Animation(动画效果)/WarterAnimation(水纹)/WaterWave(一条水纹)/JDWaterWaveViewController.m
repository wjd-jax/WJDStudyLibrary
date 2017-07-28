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
    
    UISlider  *slider1 =[[UISlider alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(waterWaveView.frame)+50, SCREEN_WIDHT-70, 10)];
    [slider1 addTarget:self action:@selector(slider1Update:) forControlEvents:UIControlEventValueChanged];
    slider1.minimumValue =waterWaveView.waveSpeed;
    slider1.maximumValue =waterWaveView.waveSpeed*2;

    [self.view addSubview:slider1];
    
    UISlider  *slider2 =[[UISlider alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(slider1.frame)+50, SCREEN_WIDHT-70, 10)];
    slider2.minimumValue =waterWaveView.waveW;
    slider2.maximumValue =waterWaveView.waveW*2;

    [slider2 addTarget:self action:@selector(slider2Update:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider2];
    
    UISlider  *slider3 =[[UISlider alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(slider2.frame)+50, SCREEN_WIDHT-70, 10)];
    slider3.minimumValue =waterWaveView.waveA;
    slider3.maximumValue =waterWaveView.waveA*2;

    [slider3 addTarget:self action:@selector(slider3Update:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider3];
    
    UILabel *label1 =[JDUtils createLabelWithFrame:CGRectMake(0, 0, 50, 50) Font:14 Text:@"速度"];
    label1.centerY =slider1.centerY;
    UILabel *label2 =[JDUtils createLabelWithFrame:CGRectMake(0, 0, 50, 50) Font:14 Text:@"周期"];
    label2.centerY =slider2.centerY;
    UILabel *label3 =[JDUtils createLabelWithFrame:CGRectMake(0, 0, 50, 50) Font:14 Text:@"振幅"];
    label3.centerY =slider3.centerY;
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    
    
}

- (void)slider1Update:(UISlider *)slider {
    waterWaveView.waveSpeed =slider.value;
}

- (void)slider2Update:(UISlider *)slider {
    waterWaveView.waveW =slider.value;

}
- (void)slider3Update:(UISlider *)slider {
    waterWaveView.waveA =slider.value;

}


-(void)dealloc
{
    DLog(@"JDWaterWaveViewController.h界面释放了");
}

@end

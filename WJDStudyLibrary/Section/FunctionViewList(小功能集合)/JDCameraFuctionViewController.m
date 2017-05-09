//
//  JDCameraFuctionViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/9.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDCameraFuctionViewController.h"

@interface JDCameraFuctionViewController ()

@end

@implementation JDCameraFuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[@{@"title":@"OpenCV实时图像处理",@"ClassName":@"JDOpenCVCameraViewController"},
                           @{@"title":@"摄像头滤镜",@"ClassName":@"JDasdCodeImageViewController"},
                           @{@"title":@"人脸识别功能(CIDetector)",@"ClassName":@"JDTouchIDViewController"},
                           
                           ];
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

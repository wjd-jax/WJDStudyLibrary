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
    self.dataSoureArray =@[@{@"title":@"OpenCV实时图像处理",@"className":@"JDOpenCVCameraViewController"},
                           @{@"title":@"摄像头滤镜",@"className":@"JDasdCodeImageViewController"},
                           @{@"title":@"人脸识别功能(CIDetector)",@"className":@"JDFaceRecognitionViewController"},
                           @{@"title":@"OCR扫描",@"className":@"JDOCRViewController"},
                           
                           ];
}



@end

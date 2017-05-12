//
//  JDOpenCVCameraViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/9.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDOpenCVCameraViewController.h"
//#import <opencv2/opencv.hpp>
//#import "ios.h"
//#import "cap_ios.h"

//#import "highgui.hpp"
//#import "imgproc.hpp"
//#import "core.hpp"
//#import "objdetect.hpp"
//#import "types_c.h"

#import <stdio.h>
#import <iostream>


@interface JDOpenCVCameraViewController ()

@property(nonatomic,retain)UIImageView *imageView;

//@property cv::Mat cvImage;
//@property CvVideoCamera *videoCamera;

@end

@implementation JDOpenCVCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.videoCamera =[[CvVideoCamera alloc]initWithParentView:self.view] ;
//    self.videoCamera.delegate = self;
//    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
//    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
//    self.videoCamera.defaultFPS = 30;
//    [self.videoCamera start];

}

#pragma mark - CvVideoCameraDelegate
//-(void)processImage:(cv::Mat &)image {

//    cv::Mat gray;
//    cv::cvtColor(image, gray, CV_RGBA2GRAY);
//    cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2, 1.2);
//    cv::Mat edges;
//    cv::Canny(gray, edges, 0, 60);
//    image.setTo(cv::Scalar::all(255));
//    image.setTo(cv::Scalar(0,128,255,255), edges);
//    self.imageView.image = MatToUIImage(image);
    
//}
@end

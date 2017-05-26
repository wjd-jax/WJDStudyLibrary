//
//  JDOpenCVCameraViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/9.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDOpenCVCameraViewController.h"
#import "opencv2/opencv.hpp"
#import "opencv2/imgcodecs/ios.h"
#import "opencv2/videoio/cap_ios.h"

using namespace cv;

@interface JDOpenCVCameraViewController ()<CvVideoCameraDelegate>

@property(nonatomic,retain)UIImageView *imageView;

@property cv::Mat cvImage;
@property CvVideoCamera *videoCamera;

@end

@implementation JDOpenCVCameraViewController

- (void)open:(UISwitch *)sender {
    
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
       
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:YES completion:nil];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertC addAction:action];
    }else{
        [self.videoCamera start];

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView =[[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset640x480;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    //self.videoCamera.rotateVideo =YES; //设置是旋转
    self.videoCamera.defaultFPS = 30;
    [self performSelector:@selector(open:) withObject:nil afterDelay:0.1];
    
}

#pragma mark - CvVideoCameraDelegate
-(void)processImage:(cv::Mat &)image {

    cv::Mat gray;
    cv::cvtColor(image, gray, CV_RGBA2GRAY);
    cv::GaussianBlur(gray, gray, cv::Size(5,5), 1.2, 1.2);
    cv::Mat edges;
    cv::Canny(gray, edges, 0, 60);
    image.setTo(cv::Scalar::all(255));
    image.setTo(cv::Scalar(0,128,255,255), edges);
    
}
@end

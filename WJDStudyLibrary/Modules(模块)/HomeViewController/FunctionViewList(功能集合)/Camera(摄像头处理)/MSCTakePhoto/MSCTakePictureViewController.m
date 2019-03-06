//
//  MSCTakePictureViewController.m
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/22.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import "MSCTakePictureViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "MSCTakeFacePictureView.h"
#import "MSCTakeBacePictureView.h"
#import "MSCTakeDriverPictureView.h"
#import "MSCTakePictureView.h"

#import "MSCShowPictureViewController.h"

typedef void (^lightBlock)(void);

@interface MSCTakePictureViewController ()

/**用来获取相机设备的一些属性*/
@property (nonatomic, strong) AVCaptureDevice *device;

/**用来执行输入设备和输出设备之间的数据交换*/
@property (nonatomic, strong) AVCaptureSession *session;

/**输入设备，调用所有的输入硬件，例如摄像头、麦克风*/
@property (nonatomic, strong) AVCaptureDeviceInput *deviceInput;

/**照片流输出，用于输出图像*/
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;

/**镜头扑捉到的预览图层*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

/**session通过AVCaptureConnection连接AVCaptureStillImageOutput进行图片输出*/
@property (nonatomic, strong) AVCaptureConnection *connection;

/**记录屏幕的旋转方向*/
@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

/**闪光灯按钮*/
@property (nonatomic, weak) UIButton *lightButton;

/**闪光灯状态*/
@property (nonatomic, assign) NSInteger lightCameraState;

/**遮罩层层--身份证正面*/
@property (nonatomic, strong) UIView *maskView;

@end

@implementation MSCTakePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;

    //判断相机 是否可以使用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }

    //设置闪光灯的默认状态
    self.lightCameraState = 2;

    [self makeUI];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];

    if (self.session) {
        [self.session stopRunning];
    }
}

#pragma mark -UI界面布局及对象的初始化
- (void)makeUI {
    // 相机相关
    //PreView
    NSError *error;
    //创建会话层
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    //初始化session
    self.session = [[AVCaptureSession alloc] init];

    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }

    //初始化输入设备
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];

    //初始化照片输出对象
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];

    //输出设置,AVVideoCodecJPEG 输出jpeg格式图片
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];

    [self.imageOutput setOutputSettings:outputSettings];

    //判断输入输出设备是否可用
    if ([self.session canAddInput:self.deviceInput]) {
        [self.session addInput:self.deviceInput];
    }

    if ([self.session canAddOutput:self.imageOutput]) {
        [self.session addOutput:self.imageOutput];
    }

    if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
        [self flashLightModel:^{
          [self.device setFlashMode:AVCaptureFlashModeAuto];
        }];
    }

    /********************************************************************************/

    //设置图层的frame
    CGFloat ScreenW = self.view.frame.size.width;
    CGFloat ScreenH = self.view.frame.size.height;

    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    headView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:headView];

    if ([self isShowChangeCameraBtn]) {
        //切换镜头按钮
        UIButton *changeButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 60, 0, 60, 40)];
        [changeButton addTarget:self action:@selector(clickchangeButton) forControlEvents:UIControlEventTouchUpInside];
        [changeButton setImage:[UIImage imageNamed:@"camera-switch"] forState:UIControlStateNormal];
        [headView addSubview:changeButton];
    }

    //闪光灯
    UIButton *lightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, JD_StatusBarHeight, 80, 40)];
    [lightButton addTarget:self action:@selector(clickLightButton:) forControlEvents:UIControlEventTouchUpInside];
    [lightButton setImage:[UIImage imageNamed:@"mine_kaluli_flashlight"] forState:UIControlStateNormal];
    [lightButton setImage:[UIImage imageNamed:@"mine_kaluli_flashlight"] forState:UIControlStateSelected];
    [lightButton setImage:[UIImage imageNamed:@"mine_kaluli_flashlight"] forState:UIControlStateFocused];
    [lightButton setTitle:@" 自动" forState:UIControlStateNormal];
    [lightButton setTitleColor:[UIColor colorWithRed:0xff / 255.f green:0xbc / 255.f blue:0x2e / 255.f alpha:1] forState:UIControlStateNormal];
    lightButton.titleLabel.font = [UIFont systemFontOfSize:14];

    self.lightButton = lightButton;
    [headView addSubview:lightButton];

    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];

    /** 设置图层的填充样式
     *  AVLayerVideoGravityResize,       // 非均匀模式。两个维度完全填充至整个视图区域
     AVLayerVideoGravityResizeAspect,  // 等比例填充，直到一个维度到达区域边界
     AVLayerVideoGravityResizeAspectFill, // 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
     */
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.previewLayer.frame = CGRectMake(0, 44, ScreenW, ScreenH - 44 - 100);
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];

    CGFloat previewLayerY = CGRectGetMaxY(self.previewLayer.frame);

    // --- bottomView
    CGRect rect = CGRectMake(0, previewLayerY, ScreenW, ScreenH - previewLayerY);
    UIView *bottomView = [[UIView alloc] initWithFrame:rect];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];

    // 拍照按钮
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"mine_kaluli_take"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 60, 60);
    button.center = CGPointMake(bottomView.center.x, bottomView.bounds.size.height / 2.f);
    [button addTarget:self action:@selector(clickPHOTO) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:button];

    // 取消按钮
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 60, 40)];
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [bottomView addSubview:backButton];

    if (self.takePictureType == MSCTakePictureTypeFace) {
        self.maskView = [[MSCTakeFacePictureView alloc] initWithFrame:self.previewLayer.frame];
        [self.view addSubview:self.maskView];
        self.deviceOrientation = AVCaptureVideoOrientationLandscapeRight;
    } else if (self.takePictureType == MSCTakePictureTypeBack) {
        self.maskView = [[MSCTakeBacePictureView alloc] initWithFrame:self.previewLayer.frame];
        [self.view addSubview:self.maskView];
        self.deviceOrientation = AVCaptureVideoOrientationLandscapeRight;
    } else if (self.takePictureType == MSCTakePictureTypeDriver) {
        self.maskView = [[MSCTakeDriverPictureView alloc] initWithFrame:self.previewLayer.frame];
        [self.view addSubview:self.maskView];
        self.deviceOrientation = AVCaptureVideoOrientationLandscapeRight;
    } else {
        self.maskView = [[MSCTakePictureView alloc] initWithFrame:self.previewLayer.frame];
        [self.view addSubview:self.maskView];
        self.deviceOrientation = AVCaptureVideoOrientationPortrait;
    }
}

#pragma mark -返回按钮
- (void)clickBackButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -镜头切换
- (void)clickchangeButton {
    // 翻转
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    [UIView commitAnimations];

    NSArray *inputs = self.session.inputs;

    for (AVCaptureDeviceInput *input in inputs) {
        AVCaptureDevice *device = input.device;

        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newInput = nil;

            if (position == AVCaptureDevicePositionFront)
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            else
                newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];

            [self.session beginConfiguration];
            [self.session removeInput:input];
            [self.session addInput:newInput];
            [self.session commitConfiguration];
            break;
        }
    }
}

#pragma mark -相机状态
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];

    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }

    return nil;
}

#pragma mark - 闪光灯的状态
- (void)clickLightButton:(UIButton *)sender {
    if (self.lightCameraState < 0) {
        self.lightCameraState = 0;
    }

    self.lightCameraState++;

    if (self.lightCameraState >= 4) {
        self.lightCameraState = 1;
    }

    AVCaptureFlashMode mode;

    switch (self.lightCameraState) {
        case 1: {
            mode = AVCaptureFlashModeOn;
            [sender setTitle:@" 打开" forState:UIControlStateNormal];
            break;
        }
        case 2: {
            mode = AVCaptureFlashModeAuto;
            [sender setTitle:@" 自动" forState:UIControlStateNormal];
            break;
        }
        case 3: {
            mode = AVCaptureFlashModeOff;
            [sender setTitle:@" 关闭" forState:UIControlStateNormal];
            break;
        }
        default: {
            mode = AVCaptureFlashModeAuto;
            [sender setTitle:@" 自动" forState:UIControlStateNormal];
            break;
        }
    }

    if ([self.device isFlashModeSupported:mode]) {
        [self flashLightModel:^{
          [self.device setFlashMode:mode];
        }];
    }
}

// 闪光
- (void)flashLightModel:(lightBlock)lightBlock {
    if (!lightBlock)
        return;

    [self.session beginConfiguration];
    [self.device lockForConfiguration:nil];

    lightBlock();

    [self.device unlockForConfiguration];
    [self.session commitConfiguration];
    [self.session startRunning];
}

#pragma mark -拍照按钮
- (void)clickPHOTO {
    self.connection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];

    //获取输出视图的展示方向
    //    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation: AVCaptureVideoOrientationLandscapeRight];

    //    [self.connection setVideoOrientation:self.deviceOrientation];
    self.connection.videoOrientation = (AVCaptureVideoOrientation)self.deviceOrientation;

    __weak typeof(self) wself = self;

    [self.imageOutput captureStillImageAsynchronouslyFromConnection:self.connection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

                                                    NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                    //原图
                                                    UIImage *image = [UIImage imageWithData:jpegData];

                                                    MSCShowPictureViewController *showVC = [[MSCShowPictureViewController alloc] init];
                                                    CGRect frame = CGRectMake(
                                                        (image.size.width - 360 / KSCREEN_WIDTH * image.size.height) / 2,
                                                        (image.size.height - 240 / KSCREEN_WIDTH * image.size.height) / 2,
                                                        360 / KSCREEN_WIDTH * image.size.height,
                                                        240 / KSCREEN_WIDTH * image.size.height);
                                                    UIImage *clipImage = [self imageFromImage:image
                                                                                       inRect:frame];
                                                    showVC.image = clipImage;

                                                    showVC.block = ^(BOOL isFinished) {

                                                      if (isFinished) {
                                                          if (wself.block) {
                                                              wself.block(YES, jpegData, clipImage);
                                                          }
                                                      }
                                                    };

                                                    [wself.navigationController pushViewController:showVC animated:YES];

                                                  }];
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {

    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}



- (void)didReceiveMemoryWarning
{
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

//
//  JDIDCardScanViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDIDCardScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JDCardScanView.h"
#import "excards.h"
#import "JDIDCardModel.h"

@interface JDIDCardScanViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

// 摄像头设备
@property (nonatomic,strong) AVCaptureDevice *device;

// AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic,strong) AVCaptureSession *session;

// 输出格式
@property (nonatomic,strong) NSNumber *outPutSetting;

// 出流对象
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;

// 预览图层
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

// 队列
@property (nonatomic,strong) dispatch_queue_t queue;

// 是否打开手电筒
@property (nonatomic,assign,getter = isTorchOn) BOOL torchOn;

@end

@implementation JDIDCardScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化rect
    const char *thePath = [[[NSBundle mainBundle] resourcePath] UTF8String];
    
#if TARGET_IPHONE_SIMULATOR
    int ret =0;
    DLog(@"%s",thePath);
#else
    int ret = EXCARDS_Init(thePath);
#endif
    
    if (ret != 0) {
        NSLog(@"初始化失败：ret=%d", ret);
    }
    
    [self.view.layer addSublayer:self.previewLayer];
    
    JDCardScanView *scanView = [[JDCardScanView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scanView];
    
    // 添加rightBarButtonItem为打开／关闭手电筒
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStylePlain target:self action:@selector(turnOnOrOffTorch)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    // 每次展现AVCaptureViewController的界面时，都检查摄像头使用权限
    [self checkAuthorizationStatus];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self stopSession];
}

#pragma mark - 检测摄像头权限
-(void)checkAuthorizationStatus {
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined:[self showAuthorizationNotDetermined]; break;// 用户尚未决定授权与否，那就请求授权
        case AVAuthorizationStatusAuthorized:[self showAuthorizationAuthorized]; break;// 用户已授权，那就立即使用
        case AVAuthorizationStatusDenied:[self showAuthorizationDenied]; break;// 用户明确地拒绝授权，那就展示提示
        case AVAuthorizationStatusRestricted:[self showAuthorizationRestricted]; break;// 无法访问相机设备，那就展示提示
    }
}
#pragma mark - 相机使用权限处理
#pragma mark 用户还未决定是否授权使用相机
-(void)showAuthorizationNotDetermined {
    __weak __typeof__(self) weakSelf = self;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        granted? [weakSelf runSession]: [weakSelf showAuthorizationDenied];
    }];
}

#pragma mark 被授权使用相机
-(void)showAuthorizationAuthorized {
    [self runSession];
}

#pragma mark 未被授权使用相机
-(void)showAuthorizationDenied {
    //    NSString *title = @"相机未授权";
    //    NSString *message = @"请到系统的“设置-隐私-相机”中授权此应用使用您的相机";
    //
    //    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        // 跳转到该应用的隐私设授权置界面
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    //    }];
    //
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
}

#pragma mark 使用相机设备受限
-(void)showAuthorizationRestricted {
    //    NSString *title = @"相机设备受限";
    //    NSString *message = @"请检查您的手机硬件或设置";
    
}
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
#pragma mark 从输出的数据流捕捉单一的图像帧
// AVCaptureVideoDataOutput获取实时图像，这个代理方法的回调频率很快，几乎与手机屏幕的刷新频率一样快
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]]
        || [self.outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]) {
        
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        
        if ([captureOutput isEqual:self.videoDataOutput]) {
            // 身份证信息识别
            [self IDCardRecognit:imageBuffer];
        }
    } else {
        NSLog(@"输出格式不支持");
    }
}


#pragma mark - 身份证信息识别
- (void)IDCardRecognit:(CVImageBufferRef)imageBuffer {
    CVBufferRetain(imageBuffer);
    
    // Lock the image buffer
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        size_t width= CVPixelBufferGetWidth(imageBuffer);// 1920
        size_t height = CVPixelBufferGetHeight(imageBuffer);// 1080
        
        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
        size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
        DLog(@"%zu",rowBytes);
        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
        unsigned char* pixelAddress = baseAddress + offset;
        
        static unsigned char *buffer = NULL;
        if (buffer == NULL) {
            buffer = (unsigned char *)malloc(sizeof(unsigned char) * width * height);
        }
        
        memcpy(buffer, pixelAddress, sizeof(unsigned char) * width * height);
        
        unsigned char pResult[1024];
        
#if TARGET_IPHONE_SIMULATOR
        int ret = 0;
        
#else
        int ret = EXCARDS_RecoIDCardData(buffer, (int)width, (int)height, (int)rowBytes, (int)8, (char*)pResult, sizeof(pResult));
#endif
        if (ret <= 0) {
            NSLog(@"ret=[%d]", ret);
        } else {
            NSLog(@"ret=[%d]", ret);
            
            // 播放一下“拍照”的声音，模拟拍照
            AudioServicesPlaySystemSound(1108);
            if ([self.session isRunning]) {
                [self.session stopRunning];
            }
            
            char ctype;
            char content[256];
            int xlen;
            int i = 0;
            
            JDIDCardModel *iDInfo = [[JDIDCardModel alloc] init];
            
            ctype = pResult[i++];
            
            //iDInfo.type = ctype;
            
            while(i < ret){
                ctype = pResult[i++];
                for(xlen = 0; i < ret; ++i){
                    
                    if(pResult[i] == ' ') {
                        ++i;
                        break;
                    }
                    content[xlen++] = pResult[i];
                }
                
                content[xlen] = 0;
                
                if(xlen) {
                    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                    
                    if(ctype == 0x21) {
                        iDInfo.cardID = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x22) {
                        iDInfo.name = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x23) {
                        iDInfo.gender = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x24) {
                        iDInfo.nation = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x25) {
                        iDInfo.address = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x26) {
                        iDInfo.issue = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    } else if(ctype == 0x27) {
                        iDInfo.valid = [NSString stringWithCString:(char *)content encoding:gbkEncoding];
                    }
                }
            }
            
            if (iDInfo) {// 读取到身份证信息，实例化出IDInfo对象后，截取身份证的有效区域，获取到图像
                NSString *message = [NSString stringWithFormat:@"\n正面\n姓名：%@\n性别：%@\n民族：%@\n住址：%@\n公民身份证号码：%@\n\n反面\n签发机关：%@\n有效期限：%@",iDInfo.name,iDInfo.gender,iDInfo.nation,iDInfo.address,iDInfo.cardID,iDInfo.issue,iDInfo.valid];
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"扫描成功" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                JDDISPATCH_MAIN_THREAD(^{
                    [alertV show];
                });
                // 身份证信息识别完毕后，就将videoDataOutput的代理去掉，防止频繁调用AVCaptureVideoDataOutputSampleBufferDelegate方法而引起的“混乱”
                if (self.videoDataOutput.sampleBufferDelegate) {
                    [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
                }
                
            }
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    
    CVBufferRelease(imageBuffer);
}


#pragma mark - 运行session
// session开始，即输入设备和输出设备开始数据传递
- (void)runSession {
    if (![self.session isRunning]) {
        dispatch_async(self.queue, ^{
            [self.session startRunning];
        });
    }
}

#pragma mark - 停止session
// session停止，即输入设备和输出设备结束数据传递
-(void)stopSession {
    if ([self.session isRunning]) {
        dispatch_async(self.queue, ^{
            [self.session stopRunning];
        });
    }
}


#pragma mark - 打开／关闭手电筒
-(void)turnOnOrOffTorch {
    self.torchOn = !self.isTorchOn;
    
    if ([self.device hasTorch]){ // 判断是否有闪光灯
        [self.device lockForConfiguration:nil];// 请求独占访问硬件设备
        [self.device unlockForConfiguration];// 请求解除独占访问硬件设备
    }else {
        
    }
}


#pragma mark - 懒加载

-(AVCaptureDevice *)device {
    
    if (_device == nil) {
        
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        NSError *error = nil;
        if ([_device lockForConfiguration:&error]) {
            if ([_device isSmoothAutoFocusSupported]) {// 平滑对焦
                _device.smoothAutoFocusEnabled = YES;
            }
            
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {// 自动持续对焦
                _device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            }
            
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure ]) {// 自动持续曝光
                _device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            }
            
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {// 自动持续白平衡
                _device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            }
            
            [_device unlockForConfiguration];
        }
    }
    
    return _device;
}

#pragma mark outPutSetting
-(NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    }
    
    return _outPutSetting;
}



#pragma mark previewLayer
-(AVCaptureVideoPreviewLayer *)previewLayer {
    
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        _previewLayer.frame = self.view.frame;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewLayer;
}

#pragma mark videoDataOutput
-(AVCaptureVideoDataOutput *)videoDataOutput {
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:self.outPutSetting};
        [_videoDataOutput setSampleBufferDelegate:self queue:self.queue];
        
    }
    
    return _videoDataOutput;
}

#pragma mark session
-(AVCaptureSession *)session {
    
    if (_session == nil) {
        
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        
        // 2、设置输入：由于模拟器没有摄像头，因此最好做一个判断
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        if (error) {
            
        }else {
            if ([_session canAddInput:input]) {
                [_session addInput:input];
            }
            
            if ([_session canAddOutput:self.videoDataOutput]) {
                [_session addOutput:self.videoDataOutput];
            }
        }
    }
    
    return _session;
}

#pragma mark queue
-(dispatch_queue_t)queue {
    
    if (_queue == nil) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return _queue;
}


@end

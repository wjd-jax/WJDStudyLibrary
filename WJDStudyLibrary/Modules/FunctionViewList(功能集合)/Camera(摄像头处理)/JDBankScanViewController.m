//
//  JDBankScanViewController.m
//
//
//  Created by wangjundong on 2017/7/11.
//
// enable Testability 要设置为NO

#import "JDBankScanViewController.h"
#import "OverlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "RectManager.h"
#import "JDBandCardScanResultModel.h"
#import "exbankcard.h"
#import "UIImage+Extend.h"
#import "BankCardSearch.h"

@interface JDBankScanViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) OverlayView *overlayView;
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

@implementation JDBankScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"银行卡扫描";
    [self.view.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.overlayView];
    
    // Do any additional setup after loading the view.
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
}

#pragma mark 使用相机设备受限
-(void)showAuthorizationRestricted {
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

#pragma mark - 识别
- (void)IDCardRecognit:(CVImageBufferRef)imageBuffer {
   
#if TARGET_IPHONE_SIMULATOR
    
#else
       CVBufferRetain(imageBuffer);
    
    // 必须先锁定buffer才可以
    if (CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
    {
        size_t width_t= CVPixelBufferGetWidth(imageBuffer);
        size_t height_t = CVPixelBufferGetHeight(imageBuffer);
        CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
        size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
        
        unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
        unsigned char* pixelAddress = baseAddress + offset;
        
        size_t cbCrOffset = NSSwapBigIntToHost(planar->componentInfoCbCr.offset);
        uint8_t *cbCrBuffer = baseAddress + cbCrOffset;
        
        CGSize size = CGSizeMake(width_t, height_t);
        CGRect effectRect = [RectManager getEffectImageRect:size];
        CGRect rect = [RectManager getGuideFrame:effectRect];
        
        int width = ceilf(width_t);
        int height = ceilf(height_t);
        
        unsigned char result [512];
        //如果编译报错// enable Testability 要设置为NO

        int resultLen = BankCardNV12(result, 512, pixelAddress, cbCrBuffer, width, height, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
        
        if(resultLen > 0) {
            
            int charCount = [RectManager docode:result len:resultLen];
            if(charCount > 0) {
                CGRect subRect = [RectManager getCorpCardRect:width height:height guideRect:rect charCount:charCount];
                UIImage *image = [UIImage getImageStream:imageBuffer];
                __block UIImage *subImg = [UIImage getSubImage:subRect inImage:image];
                
                char *numbers = [RectManager getNumbers];
                
                NSString *numberStr = [NSString stringWithCString:numbers encoding:NSASCIIStringEncoding];
                NSString *bank = [BankCardSearch getBankNameByBin:numbers count:charCount];
                
                JDBandCardScanResultModel *model = [JDBandCardScanResultModel new];
                
                model.bankNumber = numberStr;
                model.bankName = bank;
                model.bankImage = subImg;
                
                
                // 播放一下“拍照”的声音，模拟拍照
                AudioServicesPlaySystemSound(1108);
                if ([self.session isRunning]) {
                    [self.session stopRunning];
                }
                
                if (self.videoDataOutput.sampleBufferDelegate) {
                    [self.videoDataOutput setSampleBufferDelegate:nil queue:self.queue];
                }
                
                NSString *message = [NSString stringWithFormat:@"银行%@\n卡号%@\n",model.bankName,model.bankNumber];

                
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"扫描成功" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                JDDISPATCH_MAIN_THREAD(^{
                    [alertV show];
                });
                
            }
        }
        CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    }
    CVBufferRelease(imageBuffer);
#endif
    
}


#pragma mark 懒加载

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

-(NSNumber *)outPutSetting {
    if (_outPutSetting == nil) {
        _outPutSetting = @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange);
    }
    
    return _outPutSetting;
}


-(AVCaptureVideoPreviewLayer *)previewLayer {
    
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        
        _previewLayer.frame = self.view.frame;
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    
    return _previewLayer;
}

-(AVCaptureVideoDataOutput *)videoDataOutput {
    
    if (_videoDataOutput == nil) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        _videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
        _videoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey:self.outPutSetting};
        [_videoDataOutput setSampleBufferDelegate:self queue:self.queue];
        
    }
    
    return _videoDataOutput;
}

-(AVCaptureSession *)session {
    
    if (_session == nil) {
        
        _session = [[AVCaptureSession alloc] init];
        
        _session.sessionPreset = AVCaptureSessionPreset1280x720;
        
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

-(dispatch_queue_t)queue {
    
    if (_queue == nil) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    return _queue;
}

- (OverlayView *)overlayView {
    if(!_overlayView) {
        CGRect rect = [OverlayView getOverlayFrame:[UIScreen mainScreen].bounds];
        _overlayView = [[OverlayView alloc] initWithFrame:rect];
    }
    return _overlayView;
}

@end

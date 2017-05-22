//
//  JDQRScannerViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDQRScannerViewController.h"
#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>

@interface JDQRScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) CGRect scanRect;
@property (nonatomic, retain) ScanView *scanView;
@property (nonatomic, strong) CIDetector *detector;

@end

@implementation JDQRScannerViewController

- (AVCaptureSession *)session {
    
    if (!_session) {
        
        AVCaptureDevice *device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; //获取设想设备
        AVCaptureInput *input =[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];   //创建输入流
        if (!input) {
            return nil;
        }
        AVCaptureMetadataOutput *output =[[AVCaptureMetadataOutput alloc]init];                 //创建输出流
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];               //设置代理，并在主线程中刷新UI
        CGFloat width = 300/CGRectGetWidth(self.view.bounds);
        CGFloat height = 300/CGRectGetHeight(self.view.bounds);
        //设置扫描区域
        output.rectOfInterest = CGRectMake((1-height)/2, (1-width)/2, height, width);
        
        _session =[[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                       AVMetadataObjectTypeEAN13Code,
                                       AVMetadataObjectTypeEAN8Code,
                                       AVMetadataObjectTypeCode128Code];
    }
    
    return _session;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //相册按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarBtnItemClicked)];
    self.navigationItem.rightBarButtonItem = right;
    
    //扫描界面
    _scanView = [[ScanView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDHT, SCREEN_HEIGHT-64)];
    _scanRect =_scanView.scanRect;
    [self.view addSubview:_scanView];
    
    [self checkAVAuthorizationStatus];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.session startRunning];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count>0) {
        
        [self.session stopRunning];
        [_scanView pause];
        NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *) metadataObjects.firstObject stringValue];
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"扫描结果" message:scannedResult preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alt =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [_scanView run];
            [self.session startRunning];

        }];
        [alert addAction:alt];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    DLog(@"%@",sampleBuffer);
}
- (void)checkAVAuthorizationStatus {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请打开相机权限" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}

- (void)rightBarBtnItemClicked {
    
    //识别类(人脸,矩形,条形码,文字)CIDetectorTypeFace/CIDetectorTypeRectangle/CIDetectorTypeQRCode/CIDetectorTypeText
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
   
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
   
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]
                                               options:@{CIDetectorImageOrientation:[NSNumber numberWithInt:1]}];
    
    if (features.count >=1) {
        
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:scannedResult delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"未扫描出结果" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    [_scanView run];
}

@end

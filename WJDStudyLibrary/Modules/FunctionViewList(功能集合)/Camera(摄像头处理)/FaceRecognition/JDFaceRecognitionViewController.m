//
//  JDFaceRecognitionViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/9.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDFaceRecognitionViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface JDFaceRecognitionViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;//协调输入输出流的数据
@property (nonatomic, strong) CIDetector *detector;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;//预览层﻿
@property (nonatomic, strong) NSMutableArray *faceLayerArray;
@property (nonatomic, strong) NSMutableArray *metadataObjects;


@end

@implementation JDFaceRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    _previewLayer.frame = self.view.layer.bounds;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.session startRunning];
}
- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self.session stopRunning];
}
-(NSMutableArray *)faceLayerArray
{
    if (!_faceLayerArray) {
        _faceLayerArray  =[[NSMutableArray alloc]init];
    }
    return _faceLayerArray;
}

-(NSMutableArray *)metadataObjects
{
    if (!_metadataObjects) {
        _metadataObjects  =[[NSMutableArray alloc]init];
    }
    return _metadataObjects;
}

- (AVCaptureSession *)session {
    
    if (!_session) {
        
        AVCaptureDevice *device =[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo]; //获取设想设备
        
        AVCaptureInput *input =[AVCaptureDeviceInput deviceInputWithDevice:device error:nil];   //创建输入流
        if (!input) {
            return nil;
        }
        AVCaptureMetadataOutput *output =[[AVCaptureMetadataOutput alloc]init];                 //创建输出流
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];               //设置代理，并在主线程中刷新UI
        
        //设置扫描区域
        output.rectOfInterest = self.view.bounds;
        
        _session =[[AVCaptureSession alloc]init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        [_session addInput:input];
        [_session addOutput:output];
        
        output.metadataObjectTypes = @[
                                       AVMetadataObjectTypeFace,
                                       ];
    }
    
    return _session;
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    _metadataObjects = [NSMutableArray arrayWithArray:metadataObjects];
    
    if (_metadataObjects.count>0) {
        
        self.title =[NSString stringWithFormat:@"检测到%@张脸",@(metadataObjects.count)];
        
        for (CALayer *layer in self.faceLayerArray) {
            [layer removeFromSuperlayer];
        }
        
        [self.faceLayerArray removeAllObjects];
        
        for (int i=0; i<_metadataObjects.count; i++) {
            CALayer *faceLayer =[CALayer layer];
            faceLayer.borderColor =[UIColor redColor].CGColor;
            faceLayer.borderWidth =2;
            [self.view.layer addSublayer:faceLayer];
            [self.faceLayerArray addObject:faceLayer];
        }
        for (int i= 0; i<_metadataObjects.count; i++) {
            AVMetadataMachineReadableCodeObject *metadataObject  =[_metadataObjects objectAtIndex:i];
            if (metadataObject.type == AVMetadataObjectTypeFace) {
                {
                    AVMetadataObject *objec = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
                    AVMetadataFaceObject *face = (AVMetadataFaceObject *)objec;
                    CALayer *faceLayer =[_faceLayerArray objectAtIndex:i];
                    faceLayer.frame =face.bounds;
                }
                
            }
        }
        
    }
    else
    {
        self.title =[NSString stringWithFormat:@"检测到%@张脸",@(0)];
        for (CALayer *layer in self.faceLayerArray) {
            [layer removeFromSuperlayer];
        }
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    DLog(@"%@",sampleBuffer);
}

@end

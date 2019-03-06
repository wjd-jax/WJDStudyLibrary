//
//  ViewController.m
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/14.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import "JDCameraViewController.h"

#import "MSCTakePictureViewController.h"

@interface JDCameraViewController ()

@end

@implementation JDCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor redColor];
    btn1.frame = CGRectMake(50, 100, 120, 120);
    [btn1 setTitle:@"身份证正面" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(but1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.frame = CGRectMake(50, 240, 120, 120);
    [btn2 setTitle:@"身份证反面" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(but2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [UIColor blueColor];
    btn3.frame = CGRectMake(50, 380, 120, 120);
    [btn3 setTitle:@"照片" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(but3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor blueColor];
    btn4.frame = CGRectMake(200, 100, 120, 120);
    [btn4 setTitle:@"行驶证" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(but4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

- (void)but1Clicked:(UIButton *)btn
{
    MSCTakePictureViewController *faceVC = [[MSCTakePictureViewController alloc]init];
    faceVC.takePictureType = MSCTakePictureTypeFace;
    
    faceVC.block = ^(BOOL isFinished, NSData *imageData, UIImage *image){
        
        if (isFinished)
        {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
    };
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:faceVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)but2Clicked:(UIButton *)btn
{
    MSCTakePictureViewController *faceVC = [[MSCTakePictureViewController alloc]init];
    faceVC.takePictureType = MSCTakePictureTypeBack;
    
    faceVC.block = ^(BOOL isFinished, NSData *imageData, UIImage *image){
        
        if (isFinished)
        {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
    };
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:faceVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)but3Clicked:(UIButton *)btn
{
    MSCTakePictureViewController *faceVC = [[MSCTakePictureViewController alloc]init];
    faceVC.isShowChangeCameraBtn = YES;
    
    faceVC.block = ^(BOOL isFinished, NSData *imageData, UIImage *image){
        
        if (isFinished)
        {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
    };
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:faceVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)but4Clicked:(UIButton *)btn
{
    MSCTakePictureViewController *faceVC = [[MSCTakePictureViewController alloc]init];
    faceVC.isShowChangeCameraBtn = YES;
    faceVC.takePictureType = MSCTakePictureTypeDriver;
    
    faceVC.block = ^(BOOL isFinished, NSData *imageData, UIImage *image){
        
        if (isFinished)
        {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
        }
    };
    
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:faceVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  JDAuthorityManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAuthorityManager.h"
#import <AVFoundation/AVFoundation.h>   //相机
#import <Photos/Photos.h>               //相册
#import <CoreLocation/CoreLocation.h>   //定位
#import <AddressBook/AddressBook.h>     //通讯录


static NSString *authorityStr =@"authority";

@implementation JDAuthorityManager


+ (void)requestAuthority{
    
    //只请求一次
    NSUserDefaults *defaut =[NSUserDefaults standardUserDefaults];
    NSString *authority = [defaut objectForKey:authorityStr];
    if (authority) {
        return;
    }
    [defaut setObject:@"authority" forKey:authorityStr];
    
    
    //相册权限
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusNotDetermined){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
    }
    //相机
    AVAuthorizationStatus avstatus =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (avstatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
        }];
    }
    //麦克风
    AVAuthorizationStatus micstatus =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (micstatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            
        }];
    }
    
    //定位权限
    CLAuthorizationStatus cLstatus = [CLLocationManager authorizationStatus];
    if (cLstatus == kCLAuthorizationStatusNotDetermined) {
        
        [[[CLLocationManager alloc]init] requestWhenInUseAuthorization];
        [[[CLLocationManager alloc]init] requestAlwaysAuthorization];
        
    }
    
    //通讯录 ios9之前
    ABAuthorizationStatus abstatus =ABAddressBookGetAuthorizationStatus();
    if (abstatus  == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
        });
    }
    
    //日历或者备忘录
}

@end

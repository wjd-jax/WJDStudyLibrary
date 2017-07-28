//
//  JDAuthorityManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAuthorityManager.h"
#import <CoreLocation/CoreLocation.h>           //定位
#import <AddressBook/AddressBook.h>             //通讯录
#import <Photos/Photos.h>                       //获取相册状态权限
#import <AVFoundation/AVFoundation.h>           //相机麦克风权限
#import <EventKit/EventKit.h>                   //日历\备提醒事项权限
#import <Contacts/Contacts.h>                   //通讯录权限
#import <SafariServices/SafariServices.h>
#import <Speech/Speech.h>                       //语音识别
#import <HealthKit/HealthKit.h>                 //运动与健身
#import <MediaPlayer/MediaPlayer.h>             //媒体资料库
#import <UserNotifications/UserNotifications.h> //推送权限
#import <CoreBluetooth/CoreBluetooth.h>         //蓝牙权限
#import <Speech/Speech.h>                       //语音识别

static NSString *authorityStr =@"authority";


typedef NS_ENUM(NSInteger, JDAuthorizationStatus) {
    JDAuthorizationStatusNotDetermined = 0,
    JDAuthorizationStatusRestricted,
    JDAuthorizationStatusDenied,
    JDAuthorizationStatusAuthorized,
};

//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif

@implementation JDAuthorityManager


+ (void)requestAllAuthority{
    
    //只请求一次
    NSUserDefaults *defaut =[NSUserDefaults standardUserDefaults];
    NSString *authority = [defaut objectForKey:authorityStr];
    if (authority) return;
    [defaut setObject:@"authority" forKey:authorityStr];
    
    if (![self isObtainPhPhotoAuthority]) {
        [self obtainPHPhotoAuthorizedStaus];                //相册权限
    }
    
    if (![self isObtainAVVideoAuthority]) {
        
        [self isObtainAVVideoAuthority];                    //相机
    }
    
    if (![self isObtainAVAudioAuthority]) {
        
        [self obtainAVMediaAudioAuthorizedStatus];          //麦克风
    }
    
    if (![self isObtainLocationAuthority]) {
        
        [self obtainCLLocationAlwaysAuthorizedStatus];      //定位权限
        [self obtainCLLocationWhenInUseAuthorizedStatus];
    }
    
    if (![self isObtainCNContactAuthority]) {
        
        [self obtainCNContactAuthorizedStatus];             //通讯录
    }
    
    if (![self isObtainSpeechRecognizer]) {
        
        [self obtainSFSpeechAuthorizedStatus];               //语音识别
    }
}

#pragma mark - 定位

/**
 * @brief 是否开启定位权限
 */
+ (BOOL)isObtainLocationAuthority{
    
    if ([self statusOfCurrentLocation] == kCLAuthorizationStatusAuthorizedWhenInUse |
        [self statusOfCurrentLocation] == kCLAuthorizationStatusAuthorizedAlways) {
        return YES;
    }else{
        return NO;
    }
}

+ (CLAuthorizationStatus)statusOfCurrentLocation
{
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) {
        DLog(@"定位权限:未起开定位开关(not turn on the location)");
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
            DLog(@"定位权限:同意一直使用(Always Authorized)");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            DLog(@"定位权限:使用期间同意使用(AuthorizedWhenInUse)");
            break;
        case kCLAuthorizationStatusDenied:
            DLog(@"定位权限:拒绝(Denied)");
            break;
        case kCLAuthorizationStatusNotDetermined:
            DLog(@"定位权限:未进行授权选择(not Determined)");
            break;
        case kCLAuthorizationStatusRestricted:
            DLog(@"定位权限:未授权(Restricted)");
            break;
        default:
            break;
    }
    return status;
}


//始终访问位置信息
+ (void)obtainCLLocationAlwaysAuthorizedStatus{
    
    [[[CLLocationManager alloc]init] requestAlwaysAuthorization];
    
}

//使用时访问位置信息
+ (void)obtainCLLocationWhenInUseAuthorizedStatus{
    
    [[[CLLocationManager alloc]init] requestWhenInUseAuthorization];
    
}

#pragma mark - 推送

+ (void)obtainUserNotificationAuthorizedStatus{
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              
                              [self ShowGranted:granted];
                              
                          }];
    
}


#pragma mark - 媒体资料库
/**
 * @brief 是否开启媒体资料库权限
 */
+ (BOOL)isObtainMediaAuthority{
    
    MPMediaLibraryAuthorizationStatus status = [MPMediaLibrary authorizationStatus];
    return [self isObtainWithStatus:status];
}

+ (void)obtainMPMediaAuthorizedStatus{
    
    MPMediaLibraryAuthorizationStatus authStatus = [MPMediaLibrary authorizationStatus];
    if (authStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            [self isObtainWithStatus:status];
        }];
    }
}

#pragma mark - 语音识别
/**
 * @brief 是否开启语音识别权限
 */
+ (BOOL)isObtainSpeechAuthority{
    
    SFSpeechRecognizerAuthorizationStatus status = [SFSpeechRecognizer authorizationStatus];
    return [self isObtainWithStatus:status];
    
}

+ (void)obtainSFSpeechAuthorizedStatus{
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        [self isObtainWithStatus:status];
    }];
    
}

#pragma mark - 日历权限
/**
 * @brief 是否开启日历权限
 */
+ (BOOL)isObtainEKEventAuthority{
    
    EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    return [self isObtainWithStatus:status];
}

//开启日历权限
+ (void)obtainEKEventAuthorizedStatus{
    
    EKEventStore *store = [[EKEventStore alloc]init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        
        [self ShowGranted:granted];
        
    }];
    
}

#pragma mark - 相册权限
/**
 * @brief 是否开启相册权限
 */
+ (BOOL)isObtainPhPhotoAuthority{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return [self isObtainWithStatus:status];
    
}
//开启相册权限
+ (void)obtainPHPhotoAuthorizedStaus{
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == 3) {
            DLog(@"相册开启权限:获取");
        }else{
            DLog(@"相册开启权限:暂无");
        }
    }];
    
}

#pragma mark - 相机权限
/**
 * @brief 是否开启相机权限
 */
+ (BOOL)isObtainAVVideoAuthority{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return [self isObtainWithStatus:status];
    
}

+ (void)obtainAVMediaVideoAuthorizedStatus{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        [self ShowGranted:granted];
        
    }];
    
}

#pragma mark - 通讯录权限
/**
 * @brief 是否开启通讯录权限(ios9以后)
 */
+ (BOOL)isObtainCNContactAuthority{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return [self isObtainWithStatus:status];
        
    }else{
        
        ABAuthorizationStatus abstatus =ABAddressBookGetAuthorizationStatus();
        return [self isObtainWithStatus:abstatus];
    }
}

+ (void)obtainCNContactAuthorizedStatus{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            [self ShowGranted:granted];
            
        }];
    }
    else
    {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            [self ShowGranted:granted];
            
        });
    }
}

#pragma mark - 麦克风权限
/**
 * @brief 是否开启麦克风权限
 */
+ (BOOL)isObtainAVAudioAuthority{
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return [self isObtainWithStatus:status];
}

+ (void)obtainAVMediaAudioAuthorizedStatus{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {//麦克风权限
        
        [self ShowGranted:granted];
        
    }];
}

#pragma mark - 提醒事项权限
/**
 * @brief 是否开启提醒事项权限
 */
+ (BOOL)isObtainReminder{
    
    EKAuthorizationStatus status = [EKEventStore  authorizationStatusForEntityType:EKEntityTypeEvent];
    return [self isObtainWithStatus:status];
}

+ (void)obtainEKReminderAuthorizedStatus{
    
    EKEventStore *store = [[EKEventStore alloc]init];
    
    [store requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        
        [self ShowGranted:granted];
        
    }];
}

#pragma mark - 语音识别项权限
/**
 * @brief 是否开启语音识别事项权限
 */
+ (BOOL)isObtainSpeechRecognizer{
    
    SFSpeechRecognizerAuthorizationStatus status =[SFSpeechRecognizer authorizationStatus];
    return [self isObtainWithStatus:status];
}
+ (void)obtainSpeechRecognizeAuthorizedStatus{
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        
    }];
}



#pragma mark - 运动与健身
/**
 * @brief 开启运动与健身权限(需要的运动权限自己再加,目前仅有"步数"、"步行+跑步距离"、"心率")
 */
+ (void)obtainHKHealthAuthorizedStatus{
    
    HKHealthStore *health =[[HKHealthStore alloc]init];
    
    NSSet *readObjectTypes =[NSSet setWithObjects:
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount],//Cumulative
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning],   //跑步
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],    //体重
                             [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],    //心率
                             nil];
    
    [health requestAuthorizationToShareTypes:nil readTypes:readObjectTypes completion:^(BOOL success, NSError * _Nullable error) {
        
        [self ShowGranted:success];
        
    }];
    
}

#pragma mark - 是否授权状态判断
+ (BOOL)isObtainWithStatus:(NSInteger)status{
    
    if (status == JDAuthorizationStatusDenied) {
        DLog(@"用户拒绝App使用(Denied)");
        return NO;
    }else if (status ==JDAuthorizationStatusNotDetermined){
        DLog(@"未选择权限(NotDetermined)");
        return NO;
    }else if (status == JDAuthorizationStatusRestricted){
        DLog(@"未授权(Restricted)");
        return NO;
    }
    DLog(@"权限:已授权(Authorized)"); //EKAuthorizationStatusAuthorized
    return YES;
}

+ (void)ShowGranted:(BOOL)success
{
    if (success == YES) {
        DLog(@"开启权限:成功");
    }else{
        DLog(@"开启权限:失败");
    }
}

@end

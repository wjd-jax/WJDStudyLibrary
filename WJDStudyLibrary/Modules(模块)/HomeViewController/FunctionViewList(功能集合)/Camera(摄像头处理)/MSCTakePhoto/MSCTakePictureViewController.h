//
//  MSCTakePictureViewController.h
//  MSCIDPhotoDemo
//
//  Created by miaoshichang on 2017/6/22.
//  Copyright © 2017年 miaoshichang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MSCTakePictureType)
{
    MSCTakePictureTypePhoto = 0,
    MSCTakePictureTypeFace = 1,
    MSCTakePictureTypeBack = 2,
    MSCTakePictureTypeDriver = 3,
    
};

typedef void (^MSCTakePictureBlock)(BOOL isFinished, NSData *imageData, UIImage *image);

@interface MSCTakePictureViewController : UIViewController

@property (nonatomic, assign)MSCTakePictureType takePictureType;

@property (nonatomic, assign)BOOL isShowChangeCameraBtn;

@property (nonatomic, copy)MSCTakePictureBlock block;

@end

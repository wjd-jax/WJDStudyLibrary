//
//  UIImage+JDImage.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,fileterType) {
    CIPhotoEffectChrome,
    CIPhotoEffectFade,
    CIPhotoEffectInstant,
    CIPhotoEffectMono,
    CIPhotoEffectNoir,
    CIPhotoEffectProcess,
    CIPhotoEffectTonal,
    CIPhotoEffectTransfer
};
@interface UIImage (JDImage)

/**
 二值化
 */
- (UIImage *)covertToGrayScale;

/**
 转化灰度
 */
- (UIImage *)grayImage;

/**
 高斯模糊
 */
- (UIImage *)gaussianBlur;

/**
 图片添加滤镜

 @param filterName 滤镜名字
 @return 添加滤镜之后的效果
 */
- (UIImage *)setFilterWithFilterName:(NSString *)filterName;


@end

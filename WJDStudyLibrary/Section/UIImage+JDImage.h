//
//  UIImage+JDImage.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JDImage)

/**
 二值化
 */
- (UIImage *)covertToGrayScale;

/**
 转化灰度
 */
- (UIImage *)grayImage;
@end

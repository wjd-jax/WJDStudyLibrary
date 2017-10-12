//
//  JDQRCodeWapper.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/8.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,type)
{
    type_QRCode,
    type_BarCode
};

@interface JDQRCodeWapper : NSObject

/**
 生成二维码

 @param text 输入的信息
 @param width 需要生成图片的宽
 @param height 需要生成图的高
 @return 生成的 image
 */
+ (UIImage *)generateQRCode:(NSString *)text width:(CGFloat)width height:(CGFloat)height;

/**
 生成条形码
 
 @param code 输入的信息(不能是中文)
 @param width 需要生成图片的宽
 @param height 需要生成图的高
 @return 生成的 image
 */
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;
@end

//
//  JDQRCodeWapper.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/8.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDQRCodeWapper.h"

@implementation JDQRCodeWapper

+ (UIImage *)generateQRCode:(NSString *)text width:(CGFloat)width height:(CGFloat)height {
    
    
    return [self generateCodeImage:text width:width height:height type:type_QRCode];

}

+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    return [self generateCodeImage:code width:width height:height type:type_BarCode];
    
}

+ (UIImage *)generateCodeImage:(NSString *)code width:(CGFloat)width height:(CGFloat)height type:(type)type{
    
    // 生成条形码图片
    /*
     CIImage 对象中包含了与它相关的图像数据，它并不是一个图像。
     你可以把 CIImage 对象看作一个图像“处方”。一个 CIImage 对象中包含了生成一个图像的所需要的所有信息，不过核心绘图系统在没有得到明确指令的情况下是不会绘制这个图像的。
     “懒惰评估”机制 (请参考“过滤器客户和过滤器创建者”) 允许核心绘图系统尽可能高效的运行
     */
    
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    
    //CIFilter是一个滤镜类型
    CIFilter *filter = [CIFilter filterWithName:type_BarCode ==type?@"CICode128BarcodeGenerator":@"CIQRCodeGenerator"];
    [filter setDefaults];

    [filter setValue:data forKey:@"inputMessage"];
    if (type_QRCode ==type) {
        [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    }
    @try {
        barcodeImage = [filter outputImage];

    } @catch (NSException *exception) {
        DLog(@"条形码输入信息错误");
        return nil;
    }
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

@end

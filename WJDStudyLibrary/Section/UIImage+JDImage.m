//
//  UIImage+JDImage.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "UIImage+JDImage.h"

@implementation UIImage (JDImage)

/**
 二值化
 */
- (UIImage *)covertToGrayScale{
    
    CGSize size =[self size];
    int width =size.width;
    int height =size.height;
    
    //像素将画在这个数组
    uint32_t *pixels = (uint32_t *)malloc(width *height *sizeof(uint32_t));
    //清空像素数组
    memset(pixels, 0, width*height*sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //用 pixels 创建一个 context
    CGContextRef context =CGBitmapContextCreate(pixels, width, height, 8, width*sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    int tt =1;
    CGFloat intensity;
    int bw;
    
    for (int y = 0; y <height; y++) {
        for (int x =0; x <width; x ++) {
            uint8_t *rgbaPixel = (uint8_t *)&pixels[y*width+x];
            intensity = (rgbaPixel[tt] + rgbaPixel[tt + 1] + rgbaPixel[tt + 2]) / 3. / 255.;
            
            bw = intensity > 0.45?255:0;
            
            rgbaPixel[tt] = bw;
            rgbaPixel[tt + 1] = bw;
            rgbaPixel[tt + 2] = bw;
            
        }
    }

    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

/**
 转化灰度
 */
- (UIImage *)grayImage{
   
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  kCGImageAlphaNone);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), self.CGImage);
    
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}

#pragma mark - 高斯模糊
- (UIImage *)gaussianBlur;
{

    //转换图片
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *midImage = [CIImage imageWithData:UIImagePNGRepresentation(self)];
    //图片开始处理
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:midImage forKey:kCIInputImageKey];
    //value 改变模糊效果值
    [filter setValue:@10.0f forKey:@"inputRadius"];
    CIImage *result =[filter valueForKey:kCIOutputImageKey];
    
    CGImageRef outImage =[context createCGImage:result fromRect:[result extent]];

    //转化为 UIImage
    UIImage *resultImage =[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);

    return resultImage;
}
#pragma mark - 滤镜处理
- (UIImage *)setFilterWithFilterName:(NSString *)filterName
{
    //转换图片
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *midImage = [CIImage imageWithData:UIImagePNGRepresentation(self)];
    //图片开始处理
    CIFilter *filter = [CIFilter filterWithName:filterName];
    
    @try {
        [filter setValue:midImage forKey:kCIInputImageKey];

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    CIImage *result =[filter valueForKey:kCIOutputImageKey];
    
    CGImageRef outImage =[context createCGImage:result fromRect:[result extent]];
    
    //转化为 UIImage
    UIImage *resultImage =[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    
    return resultImage;

}
@end

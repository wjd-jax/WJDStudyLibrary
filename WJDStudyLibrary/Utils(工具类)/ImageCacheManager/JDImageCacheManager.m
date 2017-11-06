//
//  JDImageCacheManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/11/1.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDImageCacheManager.h"
#import <SDWebImageDownloader.h>

#define defaultFolderName @"ImageCache"

@interface JDImageCacheManager()

@end

@implementation JDImageCacheManager


+ (instancetype)shareInstance{
    
    static JDImageCacheManager *imageCacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCacheManager = [[JDImageCacheManager alloc]init];
        [imageCacheManager createDownFile];
    });
    return imageCacheManager;
}

- (UIImage *)getImageCacheWithURLString:(NSString *)imageUrl{
    
    //不存在图片返回nil
    if (![self fileIsExist:imageUrl])
    {
        [self downloadImageWithUrl:imageUrl];
        return nil;
    }
    
    //存在图片返回图片
    return [UIImage  imageWithContentsOfFile:[self imagePathWithURL:imageUrl]];
}

//创建下载的文件夹
-(BOOL)createDownFile
{
    //获得存储位置的路径字符串
    NSString * path =  [[self documentPath] stringByAppendingFormat:@"/%@",defaultFolderName];
    
    //如果存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return true;
    }
    
    //创建文件夹
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    
}

//沙盒目录中默认存储文件夹中是否存在这个文件
- (BOOL)fileIsExist:(NSString *)url
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self imagePathWithURL:url]];
}

- (NSString *)imagePathWithURL:(NSString *)url
{
    //拼接路径
    NSString *imageName = [url lastPathComponent];
    
    return  [[self documentPath] stringByAppendingFormat:@"/%@/%@",defaultFolderName,imageName];
}


- (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
}


-(void)downloadImageWithUrl:(NSString *)imageDownloadURLStr{
    
    
    //图片下载链接
    NSURL *imageDownloadURL = [NSURL URLWithString:imageDownloadURLStr];
    
    //将图片下载在异步线程进行
    //创建异步线程执行队列
    dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue", NULL);
    //创建异步线程
    dispatch_async(asynchronousQueue, ^{
        //网络下载图片  NSData格式
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:imageDownloadURL options:NSDataReadingMappedIfSafe error:&error];
        if (imageData) {
            
            BOOL suc = [imageData writeToFile:[self imagePathWithURL:imageDownloadURLStr] atomically:YES];
            DLog(@"本地写入结果:%d",suc);
        }
    });
}

@end

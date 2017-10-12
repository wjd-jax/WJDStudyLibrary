//
//  JDFileManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/8/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDFileManager : NSObject


//判断文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)aPath;
//判断文件是否存在Documents下
+ (BOOL)fileExistsAtDocumentsWithFileName:(NSString *)afileName;
//判断文件夹是否存在
+ (BOOL)dirExistAtPath:(NSString *)aPath;


//创建目录
+ (BOOL)createPath:(NSString *)aPath;
// 创建目录的上级目录
+ (BOOL)createParentDirectory:(NSString *)aPath;
// 目录下创建文件
+ (BOOL)createFileWithPath:(NSString *)aPath content:(NSData *)aContent;
// documents下创建文件
+ (BOOL)createFileAtDocumentsWithName:(NSString *)aFilename content:(NSData *)aContent;
+ (NSString *)createFileWithName:(NSString *)aFilename content:(NSData *)aContent;
//TMP下创建文件
+ (NSString *)createFileAtTmpWithName:(NSString *)aFilename content:(NSData *)aContent;
// Caches下创建文件
+ (BOOL)createFileAtCachesWithName:(NSString *)aFilename content:(NSData *)aContent;
//在Document下创建文件目录
+ (BOOL)createDirectoryAtDocument:(NSString *)aDirectory;
// 删除文件
+ (BOOL)deleteFileWithName:(NSString *)aFileName error:(NSError **)aError;
//删除指定路径下的文件
+ (BOOL)deleteFileWithUrl:(NSURL *)aUrl error:(NSError **)aError;
//删除文件夹下的所有文件
+ (BOOL)deleteAllFileAtPath:(NSString *)aPath;
//根据文件名删除document下的文件
+ (BOOL)deleteFileAtDocumentsWithName:(NSString *)aFilename error:(NSError **)aError;


//读取文件
+ (NSData *)readFileWithPath:(NSString *)aPath;
+ (NSData *)readFileWithURL:(NSURL *)aUrl;
+ (NSData *)readFileAtDocumentsWithFileName:(NSString *)aFileName;
//获取临时目录下的所有文件列表
+ (NSArray *)getContentsOfTmpDirectorByTimeOrder;
// 获取文件大小
+ (unsigned long long)fileSizeAtPaht:(NSString *)aPath;
//遍历文件夹下的所有文件,不含子文件
+ (NSArray *)getContentsOfDirectoryAtPath:(NSString *)aDirString;
//遍历文件夹下的所有文件,包含子文件
+ (NSArray *)getAllFilesAtPath:(NSString *)aDirString;
//获取路径下通过时间排序的文件列表
+ (NSArray *)getContentsOfDirectoryByTimeOrderAtPath:(NSString *)aDireString;


//复制一个目录下的文件到另外一个目录,前后两个必须一致，要么都是目录，要么都是文件
+ (BOOL) copyItemAtPath:(NSString *)aPath toPath:(NSString *)aDestinationPath error:(NSError **)aError;
//重命名文件
+ (BOOL)renameFileNameFrom:(NSString *)aOldName toPath:(NSString *)aNewName error:(NSError **)aError;

@end

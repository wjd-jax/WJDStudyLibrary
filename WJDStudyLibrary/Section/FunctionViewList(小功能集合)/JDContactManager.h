//
//  JDContactManager.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/26.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JDContactModel :NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,retain)NSArray *phoneNumArray;

@end

typedef void (^Cancel)();
typedef void (^SelectBlock)(JDContactModel *model);
@interface JDContactManager : NSObject

/**
 创建单例

 @return 返回单例
 */
+ (instancetype)manager;

- (void)presentContactUIWithViewController:(UIViewController *)vc selectModel:(SelectBlock)selectBlock cancel:(Cancel)cancel;

@end

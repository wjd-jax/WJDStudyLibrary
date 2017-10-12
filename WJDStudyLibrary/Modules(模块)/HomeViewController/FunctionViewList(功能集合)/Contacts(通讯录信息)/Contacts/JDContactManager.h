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

typedef void (^Cancel)(void);
typedef void (^SelectBlock)(JDContactModel *model);
typedef void (^ContactsArrayBlock)(NSArray *contactsArray);

@interface JDContactManager : NSObject

/**
 创建单例

 @return 返回单例
 */
+ (instancetype)manager;


/**
 通过系统通讯录界面选择联系人

 @param vc 需要 push 的 viewController
 @param selectBlock 选择后的 model 回调
 @param cancel 取消回调
 */
- (void)presentContactUIWithViewController:(UIViewController *)vc selectModel:(SelectBlock)selectBlock cancel:(Cancel)cancel;


/**
 获取通讯录数组

 @param contactsArrayBlock 返回的通讯录 model 数组
 */
- (void)getContacts:(ContactsArrayBlock)contactsArrayBlock;

/**
 添加联系人(目前仅支持 IOS9)

 @param model 联系人模型
 */
- (BOOL)addPersionToContact:(JDContactModel *)model;

@end

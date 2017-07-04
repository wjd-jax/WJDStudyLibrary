//
//  JDActionSheetView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/4.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDActionSheetView;

/**
 block回调
 
 @param actionSheet 对象自身
 @param index 被点击的标识,取消0,删除-1,其他1,2,3
 */
typedef void(^JDActionSheetBlock) (JDActionSheetView *actionSheet,NSInteger index);

@interface JDActionSheetView : UIView

/**
 <#Description#>

 @param title 标题
 @param cancelButtonTitle 取消按钮标题
 @param destructiveButtonTitle 销毁按钮标题
 @param otherButtonTitles 选择项按钮标题
 @param actionSheetBlock 点击选择项之后的回调
 */
+ (void)showActionSheetWithTitle:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
          destructiveButtonTitle:(NSString *)destructiveButtonTitle
               otherButtonTitles:(NSArray *)otherButtonTitles
                         handler:(JDActionSheetBlock)actionSheetBlock;
@end

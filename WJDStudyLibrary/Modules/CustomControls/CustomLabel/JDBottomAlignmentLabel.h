//
//  JDBottomAlignmentLabel.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDBottomAlignmentLabel : UIView

/**
 添加一段文本

 @param text 文字
 @param font 字体
 @param textColor 颜色
 @param isChinese 是否是中文
 */
- (void)addText:(NSString *)text Font:(UIFont *)font TextColor:(UIColor *)textColor IsChinese:(BOOL)isChinese;

/**
 清空文字
 */
- (void)removeAllText;

@end

//
//  JDSheetView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JDSheetViewDidSelectRowBlock)(NSUInteger index);

@interface JDSheetView : UIView

/**
 可以传入自定义头部
 */
@property (nonatomic, strong) UIView *headerView;

- (instancetype)initWithItems:(NSArray <NSString *> *)titleItem didSelectRowBlock:(JDSheetViewDidSelectRowBlock)callBlock;

- (void)show;

/**
 一句话显示列表方法
 
 @param titleItem 选择项目标题
 @param callBlock 返回的标题
 */
+ (void)ShowListWithItems:(NSArray <NSString *> *)titleItem didSelectRowBlock:(JDSheetViewDidSelectRowBlock)callBlock;

@end

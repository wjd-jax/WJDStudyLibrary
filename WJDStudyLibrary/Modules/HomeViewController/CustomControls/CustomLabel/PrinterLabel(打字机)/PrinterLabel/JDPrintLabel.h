//
//  JDPrintLabel.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PrintLabelCompleteBlock)(void);

@interface JDPrintLabel : UILabel


/**
 设置耽搁打字打印间隔,默认0.3秒
 */
@property (nonatomic,assign)NSTimeInterval time;

/**
 开始打印的位置索引，默认为0，即从头开始
 */
@property (nonatomic,assign)int currentIndex;

/**
 显示字体的颜色
 */
@property (nonatomic,retain)UIColor *prientColor;

/**
 *	是否有打印的声音,默认为 YES
 */
@property (nonatomic) BOOL hasSound;
/**
 打印完成的回调
 */
@property(nonatomic,assign)PrintLabelCompleteBlock completeBlock;

- (void)startPrint;

@end

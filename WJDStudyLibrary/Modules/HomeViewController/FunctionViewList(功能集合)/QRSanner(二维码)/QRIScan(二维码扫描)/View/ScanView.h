//
//  ScanView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/8.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIView

@property (nonatomic,assign)CGRect scanRect;

/**
 开始动画
 */
- (void)run;

/**
 停止动画
 */
- (void)pause;

@end

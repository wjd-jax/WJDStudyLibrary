//
//  JDWaterWaveView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/12.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDWaterWaveView : UIView

/**
 水纹速度
 */
@property(nonatomic,assign)CGFloat waveSpeed;

/**
 水纹振幅
 */
@property(nonatomic,assign)CGFloat waveA;

/**
 水纹周期
 */
@property(nonatomic,assign)CGFloat waveW;


/**
 !!!页面退出的时候必须调用,否则定时器无法销
 */
- (void)stopWave;

@end

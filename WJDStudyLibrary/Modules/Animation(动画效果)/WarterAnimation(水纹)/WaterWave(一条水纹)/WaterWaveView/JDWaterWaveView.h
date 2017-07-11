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
 水纹速度,defaut 0.05
 */
@property(nonatomic,assign)CGFloat waveSpeed;

/**
 水纹振幅 defaut 10
 */
@property(nonatomic,assign)CGFloat waveA;

/**
 水纹周期defaut  (2 * M_PI) / self.bounds.size.width
 */
@property(nonatomic,assign)CGFloat waveW;

@end

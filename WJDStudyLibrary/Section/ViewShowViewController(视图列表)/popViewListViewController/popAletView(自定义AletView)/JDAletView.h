//
//  JDAletView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^block) (NSInteger index);
@interface JDAletView : UIView

@property(nonatomic,weak)block callBack;

- (instancetype)initWithTitle:(NSString *)title detailMessage:(NSString *)desc callBack:(block)callBack;
- (void)show;
@end

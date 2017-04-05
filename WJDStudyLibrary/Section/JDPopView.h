//
//  JDPopView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/5.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^callBackBlock) (id callBack);  //回调的 block

@interface JDPopView : UIView

@property(nonatomic,weak)callBackBlock callblock;

- (void)showWithBlock:(callBackBlock)block;
@end

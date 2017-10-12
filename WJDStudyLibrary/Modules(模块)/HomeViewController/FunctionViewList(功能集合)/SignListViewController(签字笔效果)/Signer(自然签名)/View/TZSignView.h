//
//  TZSignView.h
//  TZPDFReader
//
//  Created by wangjundong on 2017/4/10.
//  Copyright © 2017年 TongZhiWeiYe technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

typedef void(^OkClick)(void);

@interface TZSignView : GLKView

@property (assign, nonatomic) UIColor *strokeColor;
@property (assign, nonatomic) BOOL hasSignature;
@property (strong, nonatomic) UIImage *signatureImage;
@property(nonatomic,copy)OkClick okClick;

@end

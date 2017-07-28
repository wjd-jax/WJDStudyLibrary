//
//  JDBandCardScanResultModel.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/7/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDBandCardScanResultModel : NSObject

@property (nonatomic, copy) NSString *bankNumber;       //银行卡数字
@property (nonatomic, copy) NSString *bankName;         //银行卡归属银行
@property (nonatomic, strong) UIImage *bankImage;       //银行卡图片

@end

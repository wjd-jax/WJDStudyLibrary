//
//  JDMainDataModel.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/31.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JDBaseModel.h"

@interface JDMainDataModel : JDBaseModel

@property(nonatomic,copy)NSString *title;               //标题
@property(nonatomic,copy)NSString *className;           //类名
@property(nonatomic,copy)NSString *info;                //额外信息

@end

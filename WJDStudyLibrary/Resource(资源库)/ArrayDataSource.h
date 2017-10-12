//
//  ArrayDataSource.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/3/27.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^configureCell)(id cell, id item);

@interface ArrayDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)identifier configureCellBlock:(configureCell)configureCellBlock;
- (void)setDataSourceArray:(NSArray *)array;

@end

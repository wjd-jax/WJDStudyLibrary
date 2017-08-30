//
//  JDBaseTableViewController.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDMainDataModel.h"

/**
    优化通用tableView的显示,只需要一句话即可实现视图,点击实现可以重写 didselect 方法
        子类只需要在 viewDidLoad中填写数据源即可
    self.dataSoureArray = @[@{@"title":@"弹出视图",@"className":@"JDPopViewController"},
                         @{@"title":@"引导页视图",@"className":@"JDGuideViewController"}];
 */
@interface JDBaseTableViewController : UITableViewController

/**
 数据源数组
 */
@property(nonatomic,strong)NSArray *dataSoureArray;

/**
 模型数组
 */
@property(nonatomic,retain)NSArray *dataArray;

@end

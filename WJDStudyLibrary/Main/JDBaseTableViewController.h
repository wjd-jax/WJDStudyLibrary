//
//  JDBaseTableViewController.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/6.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
    优化通用tableView的显示,只需要一句话即可实现视图,点击实现可以重写 didselect 方法
        子类只需要在 viewDidLoad中填写数据源即可
 
    self.dataSoureArray = @[@{@"title":@"弹出视图",@"ClassName":@"JDPopViewController"},
                         @{@"title":@"引导页视图",@"ClassName":@"JDGuideViewController"}];

 */
@interface JDBaseTableViewController : UITableViewController

@property(nonatomic,strong)NSArray *dataSoureArray;

@end

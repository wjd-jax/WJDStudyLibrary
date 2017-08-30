//
//  JDStudyWebListViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/11.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDStudyWebListViewController.h"
#import "JDWebBrowserViewController.h"

@interface JDStudyWebListViewController ()

@end

@implementation JDStudyWebListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSoureArray =@[
                           @{@"title":@"我的简书",@"className":@"http://www.jianshu.com/u/b68a84c0ced8"},
                           @{@"title":@"唐巧",@"className":@"http://blog.devtang.com/blog/archives/"},
                           @{@"title":@"王巍",@"className":@"http://www.onevcat.com"},
                           @{@"title":@"文顶顶",@"className":@"http://www.cnblogs.com/wendingding/p/"},
                           @{@"title":@"池建强",@"className":@"http://macshuo.com"},
                           @{@"title":@"CocoaChina",@"className":@"http://www.cocoachina.com"},
                           @{@"title":@"Code4App",@"className":@"http://www.code4app.com"},
                           @{@"title":@"Git@OSC",@"className":@"http://git.oschina.net"},
                           @{@"title":@"开源中国社区",@"className":@"http://www.oschina.net/code/list"},
                           @{@"title":@"GitHub",@"className":@"https://github.com"},
                           @{@"title":@"苹果Library",@"className":@"https://developer.apple.com/library/mac/navigation/"},
                           
                           ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDMainDataModel *model =[self.dataArray objectAtIndex:indexPath.row];
    [JDWebBrowserViewController openUrl:model.className fromViewController:self];
    
}
@end

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
                           @{@"title":@"唐巧",@"ClassName":@"http://blog.devtang.com/blog/archives/"},
                           @{@"title":@"王巍",@"ClassName":@"http://www.onevcat.com"},
                           @{@"title":@"文顶顶",@"ClassName":@"http://www.cnblogs.com/wendingding/p/"},
                           @{@"title":@"池建强",@"ClassName":@"http://macshuo.com"},
                           @{@"title":@"CocoaChina",@"ClassName":@"http://www.cocoachina.com"},
                           @{@"title":@"Code4App",@"ClassName":@"http://www.code4app.com"},
                           @{@"title":@"Git@OSC",@"ClassName":@"http://git.oschina.net"},
                           @{@"title":@"开源中国社区",@"ClassName":@"http://www.oschina.net/code/list"},
                           @{@"title":@"GitHub",@"ClassName":@"https://github.com"},
                           @{@"title":@"苹果Library",@"ClassName":@"https://developer.apple.com/library/mac/navigation/"},
                           
                           ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JDMainDataModel *model =[self.dataArray objectAtIndex:indexPath.row];
    [JDWebBrowserViewController openUrl:model.ClassName fromViewController:self];
    
}
@end

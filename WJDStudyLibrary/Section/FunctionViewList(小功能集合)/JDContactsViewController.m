//
//  JDNewContactViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDContactsViewController.h"
#import "JDContactManager.h"
#import "ArrayDataSource.h"

@interface JDContactsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,retain) ArrayDataSource *arrayDataSource;
@property(nonatomic,retain)NSArray *dataArray;

@end

static NSString *cellIdentifier = @"CellIdentifier";

@implementation JDContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButton =[JDUtils createTextBarButtonWithTitle:@"通讯录" Target:self Action:@selector(requestContact)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    //tableView
    
    
    _arrayDataSource =[[ArrayDataSource alloc]initWithItems:_dataArray cellIdentifier:cellIdentifier configureCellBlock:^(UITableViewCell *cell, JDContactModel *model) {
        
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = model.phoneNumArray.firstObject;
    }];
    _tableView.dataSource = _arrayDataSource;
    
    
    [[JDContactManager manager] getContacts:^(NSArray *contactsArray) {
       
        [_arrayDataSource setDataSourceArray:contactsArray];
        JDDISPATCH_MAIN_THREAD(^{
            [_tableView reloadData];
        });
    }];
    
    
    
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - click
- (void)requestContact
{
    JDWeakSelf(self);
    JDContactManager *manager =[JDContactManager manager];
    
    //打开系统的通讯录界面
    [manager presentContactUIWithViewController:self selectModel:^(JDContactModel *model) {
        
        JDDISPATCH_MAIN_THREAD(^{
            [weakself handleModel:model];
        });
        
    } cancel:^{
        [JDMessageView showMessage:@"取消选择"];
    }];
    
}

- (void)handleModel:(JDContactModel *)model
{
    
    NSString *phoneStr =@"";
    for (NSString *str in model.phoneNumArray) {
        //除去-符号
        NSString *tmpStr = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneStr = [phoneStr stringByAppendingFormat:@"%@\n", tmpStr];
    }
    
    UIAlertController *alertVC =[UIAlertController alertControllerWithTitle:model.name message:phoneStr preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)dealloc
{
    
}
@end

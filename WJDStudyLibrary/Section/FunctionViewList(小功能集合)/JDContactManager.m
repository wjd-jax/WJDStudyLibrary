//
//  JDContactManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/26.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDContactManager.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "Availability.h"

@interface JDContactManager ()<CNContactPickerDelegate>

@property(nonatomic,retain)UIViewController *vn;

@end

@implementation JDContactManager

+ (instancetype)manager
{
    static JDContactManager *manager =nil;
    JDDISPATCH_ONCE_BLOCK(^{
        if (!manager) {
            manager =[[JDContactManager alloc]init];
        }
    })
    return manager;
}


- (void)presentContactUIWithViewController:(UIViewController *)vc
{
    _vn =vc;
    if (__IPHONE_9_0) {
        [self requestContactAuthorAfterSystemVersion9];
    }
    else
    {
    
    }
}

#pragma mark - IOS7-IOS9 -




#pragma mark - IOS9 - later
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //等待授权状态
    if (status == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error)DLog(@"授权失败");
            else DLog(@"成功授权");
        }];
        
    }
    /*
     !应用程序未被授权访问联系人数据。*用户不能更改该应用程序的状态,可能由于活跃的限制,如家长控制。
     */
    else if(status == CNAuthorizationStatusRestricted)
        
        [JDMessageView showMessage:@"无权访问"];
    
    /* !明确拒绝用户访问联系人数据的应用程序。*/
    else if (status == CNAuthorizationStatusDenied)
        
        [JDMessageView showMessage:@"用户拒绝"];
    
    else if (status == CNAuthorizationStatusAuthorized)
        
        [self openContact];
    
    
    
}


- (void)openContact
{
    CNContactPickerViewController *pickerVC = [[CNContactPickerViewController alloc] init];
    
    /*
     
     //只是展示电话号码,email 等不展示
     pickerVC.displayedPropertyKeys = [NSArray arrayWithObject:CNContactPhoneNumbersKey];
     //让有 email 的对象才可以选中
     pickerVC.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];
     //选中联系人是否返回
     pickerVC.predicateForSelectionOfContact =  [NSPredicate predicateWithValue:false];
     //选中属性是否返回
     pickerVC.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:false];
     
     */
    pickerVC.delegate = self;
    [_vn presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        // NSString *phoneLabel = labeledValue.label;
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        DLog(@"%@",phoneValue);
        //_phoneNum2.text = phoneValue;
    }
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSString *name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    DLog(@"%@",name);
    _vn =nil;
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}

//点击取消操作
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [JDMessageView showMessage:@"取消选择"];
    _vn =nil;
}

@end

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
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "Availability.h"

@implementation JDContactModel

@end


@interface JDContactManager ()<CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

@property(nonatomic,retain)UIViewController *vc;
@property(nonatomic,weak)Cancel cancelBlock;
@property(nonatomic,weak)SelectBlock selectBlock;

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


- (void)presentContactUIWithViewController:(UIViewController *)vc selectModel:(SelectBlock)selectBlock cancel:(Cancel)cancel{
    _vc =vc;
    _cancelBlock = cancel;
    _selectBlock = selectBlock;

    if (iOS9) {
        
        [self requestContactAuthorAfterSystemVersion9];
    }
    else
    {
        [self requestContactAuthorBeforeSystemVersion9];
    }
}

#pragma mark - IOS7-IOS9 -

- (void)requestContactAuthorBeforeSystemVersion9{
    
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    //还没有授权
    if (authStatus  == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            //通过授权
            if (granted) {
                [self openABaddressBook];
            }
            else
            {
                [JDMessageView showMessage:@"无通讯录权限"];
            }
            
        });
    }
    else
    {
        if (authStatus == kABAuthorizationStatusAuthorized)
        {
            [self openABaddressBook];
        }
        else
        {
            [JDMessageView showMessage:@"无通讯录权限"];

        }
    
    }
    
}

- (void)openABaddressBook
{
    ABPeoplePickerNavigationController *ppnc =[[ABPeoplePickerNavigationController alloc]init];
    ppnc.peoplePickerDelegate = self;
    
    /*
     配置过滤的内容
    //进入个人详情页想展示的属性,如果不设置,默认展示所有属性
    //kABPersonPhoneProperty这些属性可以去ABPerson.h这个类去查,太多就不列出来
    ppnc.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];//只是展示电话号码
    
    // 过滤能选中的联系人,不符合条件的会变成灰色不可选;CNMutableContact这个类中可以查询CNMutableContact等属性,这里就不列出来
    ppnc.predicateForEnablingPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];//让有 email 的对象才可以选中
     
     */
    // 4.弹出控制器
    [_vc presentViewController:ppnc animated:YES completion:nil];

}


#pragma mark - IOS9 - later
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //等待授权状态
    if (status == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error){
                [JDMessageView showMessage:@"无法读取通讯录"];
            }
            else {
                [self openContact];
            }
        }];
        
    }
    /*
     !应用程序未被授权访问联系人数据。*用户不能更改该应用程序的状态,可能由于活跃的限制,如家长控制。
     */
    else
    {
        if(status == CNAuthorizationStatusRestricted)
            
            [JDMessageView showMessage:@"无权访问"];
        
        /* !明确拒绝用户访问联系人数据的应用程序。*/
        else if (status == CNAuthorizationStatusDenied)
            
            [JDMessageView showMessage:@"无访问权限"];
        
        else if (status == CNAuthorizationStatusAuthorized)
            
            [self openContact];
        
    }
    
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
    [_vc presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    
    JDContactModel *model = [[JDContactModel alloc]init];
    NSMutableArray *array =[[NSMutableArray alloc]init];
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
        // NSString *phoneLabel = labeledValue.label;
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        [array addObject:phoneValue];
    }
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    NSString *name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    model.name =name;
    model.phoneNumArray =array;
    
    _selectBlock(model);
    _vc =nil;
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}

//点击取消操作
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    _vc =nil;
    _cancelBlock();
}
#pragma mark - ABPeoplePickerNavigationControllerDelegate
//选中通讯录中的某个人将调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    //如果需要详细属性,则不要执行 dismiss
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

}


// 选中通讯录中某个人的某项属性将调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{

}

// 点击取消调用
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    _cancelBlock();
    _vc =nil;
}

@end

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

@property(nonatomic,retain)UIViewController *vc;  //需要跳转的页面
@property(nonatomic,weak)Cancel cancelBlock;
@property(nonatomic,copy)SelectBlock selectBlock;
@property(nonatomic,copy)ContactsArrayBlock contactsArrayBlock;
@property(nonatomic,assign)BOOL isSystemUI;

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

#pragma mark - 获取某个人的联系人对象

- (void)presentContactUIWithViewController:(UIViewController *)vc selectModel:(SelectBlock)selectBlock cancel:(Cancel)cancel{
    
    _isSystemUI = YES;
    _vc =vc;
    _cancelBlock = cancel;
    _selectBlock = selectBlock;
    
    iOS9?[self requestContactAuthorAfterSystemVersion9]: [self requestContactAuthorBeforeSystemVersion9];
    
}

#pragma mark - 获取通讯录对象数组
- (void)getContacts:(ContactsArrayBlock)contactsArrayBlock;
{
    _contactsArrayBlock = contactsArrayBlock;
    _isSystemUI = NO;
    iOS9?[self requestContactAuthorAfterSystemVersion9]: [self requestContactAuthorBeforeSystemVersion9];
}

- (BOOL)addPersionToContact:(JDContactModel *)model
{
    return iOS9?[self addPersionToContactIsIOS9Later:model]:[self addPersionToContactIsIOS9Before:model];
}

#pragma mark - IOS7-IOS9 -
- (void)requestContactAuthorBeforeSystemVersion9{
    
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    //还没有授权
    if (authStatus  == kABAuthorizationStatusNotDetermined) {
        
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            //通过授权
            granted?(_isSystemUI?[self openABaddressBook]:[self getABaddressBookArrayList]):[JDMessageView showMessage:@"无通讯录权限"];
            
        });
    }
    else
    {
        if (authStatus == kABAuthorizationStatusAuthorized)
        {
            _isSystemUI?[self openABaddressBook]:[self getABaddressBookArrayList];
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

- (void)getABaddressBookArrayList
{
    
    NSMutableArray *contactListArray =[NSMutableArray array];
    
    //创建通信录对象
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    //获取所有的联系人
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    
    //遍历所有的联系人
    for (int i = 0; i < peopleCount; i++) {
        // 获取某一个联系人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        //获取联系人的姓名
        NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        
        // 获取电话号码
        // 获取所有的电话号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        NSMutableArray *array =[[NSMutableArray alloc]init];
        //遍历拿到每一个电话号码
        for (int i = 0; i < phoneCount; i++) {
            
            //获取电话对应的key
            //            NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            //获取电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            [array addObject:phoneValue];
            
        }
        JDContactModel *model = [[JDContactModel alloc]init];
        NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
        model.name =name;
        model.phoneNumArray =array;
        [contactListArray addObject:model];
        CFRelease(phones);
    }
    
    CFRelease(addressBook);
    CFRelease(peopleArray);
    
    _contactsArrayBlock(contactListArray);
    
    [self restMemaory];
    
}

- (BOOL)addPersionToContactIsIOS9Before:(JDContactModel *)model
{
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authStatus != kABAuthorizationStatusAuthorized)
    {
        [JDMessageView showMessage:@"没有权限"];
        return NO;
    }
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //创建一个联系人
    ABRecordRef person = ABPersonCreate();
    //新增姓名
    NSString *Name = model.name;
    //转换为CFString
    CFStringRef lastName = (__bridge_retained CFStringRef)Name;
    //设置属性
    ABRecordSetValue(person, kABPersonLastNameProperty, lastName, NULL);
    CFRelease(lastName);
    //新增电话
    ABMultiValueRef phones = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    //手机标签设置值
    CFStringRef mobile = (__bridge_retained CFStringRef)model.phoneNumArray.firstObject;
    ABMultiValueAddValueAndLabel(phones, mobile, kABPersonPhoneMobileLabel, NULL);
    CFRelease(mobile);
    ABRecordSetValue(person, kABPersonPhoneProperty, phones, NULL);
    
    /*
     //住宅标签设置值
     CFStringRef homeTel = (__bridge_retained CFStringRef)iPerson.HomeTel;
     ABMultiValueAddValueAndLabel(phones, homeTel, kABHomeLabel, NULL);
     CFRelease(homeTel);
     //工作标签设置值
     CFStringRef workTel = (__bridge_retained CFStringRef)iPerson.WorkTel;
     ABMultiValueAddValueAndLabel(phones, workTel, kABWorkLabel, NULL);
     CFRelease(workTel);
     //其他标签设置值
     CFStringRef otherTel = (__bridge_retained CFStringRef)iPerson.OtherTel;
     ABMultiValueAddValueAndLabel(phones, otherTel, kABOtherLabel, NULL);
     CFRelease(otherTel);
     //为联系人的电话多值 设置值
     ABRecordSetValue(person, kABPersonPhoneProperty, phones, NULL);
     
     //新增邮箱
     ABMultiValueRef emails = ABMultiValueCreateMutable(kABPersonEmailProperty);
     //住宅邮箱设置值
     CFStringRef email = (__bridge_retained CFStringRef)iPerson.Email;
     ABMultiValueAddValueAndLabel(emails, email, kABHomeLabel, NULL);
     CFRelease(email);
     //为联系人添加邮箱多值
     ABRecordSetValue(person, kABPersonEmailProperty, emails, NULL);
     */
    //给通讯录添加联系人
    ABAddressBookAddRecord(addressBook, person, NULL);
    CFRelease(person);
    CFRelease(phones);
    //    CFRelease(emails);
    //保存通讯录，一定要保存
    BOOL save = ABAddressBookSave(addressBook, NULL);
    CFRelease(addressBook);
    
    return save;
}
#pragma mark - IOS9 - later
- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //等待授权状态
    if (status == CNAuthorizationStatusNotDetermined) {
        
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            granted?(_isSystemUI?[self openContact]:[self getContactsArrayList]):[JDMessageView showMessage:@"无法读取通讯录"];
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
            
            _isSystemUI?[self openContact]:[self getContactsArrayList];
        
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

- (void)getContactsArrayList
{
    //创建通讯录对象
    CNContactStore *contactStore =[[CNContactStore alloc]init];
    
    // 创建获取通信录的请求对象
    // 拿到所有打算获取的属性对应的key
    NSArray *keys =@[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    // 创建CNContactFetchRequest对象
    CNContactFetchRequest *request =[[CNContactFetchRequest alloc]initWithKeysToFetch:keys];
    NSMutableArray *contactListArray =[NSMutableArray array];
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        
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
        [contactListArray addObject:model];
        
        
    }];
    
    _contactsArrayBlock(contactListArray);
    [self restMemaory];
}

- (BOOL)addPersionToContactIsIOS9Later:(JDContactModel *)model;
{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusAuthorized)
    {
        //创建联系人
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        
        //设置名字
        contact.givenName = model.name;
        
        //电话
        contact.phoneNumbers = @[[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:model.phoneNumArray.firstObject]]];
        /*
         //设置姓氏
         contact.familyName = @"zhang";
         //邮箱
         CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:@"422736262@qq.com"];
         CNLabeledValue *workEmail = [CNLabeledValue labeledValueWithLabel:CNLabelWork value:@"1045270931@qq.com"];
         contact.emailAddresses = @[homeEmail,workEmail];
         //设置头像
         //contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:@"Icon-114.png"]);
         
         */
        //初始化方法
        CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
        //添加联系人
        [saveRequest addContact:contact toContainerWithIdentifier:nil];
        //进行联系人的写入操作
        CNContactStore *store = [[CNContactStore alloc] init];
        return  [store executeSaveRequest:saveRequest error:nil];
        
    }
    else
    {
        iOS9?[JDMessageView showMessage:@"无权访问通讯录"]:[JDMessageView showMessage:@"低于 IOS9版本暂不支持"];
    }
    return NO;
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
    
    [self restMemaory];
    
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}

//点击取消操作
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    _cancelBlock();
    [self restMemaory];
    
}
#pragma mark - ABPeoplePickerNavigationControllerDelegate
//选中通讯录中的某个人将调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    
    JDContactModel *model = [[JDContactModel alloc]init];
    NSMutableArray *array =[[NSMutableArray alloc]init];
    
    // 1.获取选中联系人的姓名
    CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // (__bridge NSString *) : 将对象交给Foundation框架的引用来使用,但是内存不交给它来管理
    // (__bridge_transfer NSString *) : 将对象所有权直接交给Foundation框架的应用,并且内存也交给它来管理
    NSString *lastname = (__bridge_transfer NSString *)(lastName);
    NSString *firstname = (__bridge_transfer NSString *)(firstName);
    NSString *name = [NSString stringWithFormat:@"%@%@",lastname,firstname];
    
    // 获取选中联系人的电话号码
    // 获取所有的电话号码
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phones);
    
    // 遍历拿到每一个电话号码
    for (int i = 0; i < phoneCount; i++) {
        
        // 获取电话对应的key
        //        NSString *phoneLabel = (__bridge_transfer NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
        // 获取电话号码
        NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        
        [array addObject:phoneValue];
    }
    
    model.name =name;
    model.phoneNumArray =array;
    _selectBlock(model);
    // 注意:管理内存
    CFRelease(phones);
    //如果需要详细属性,则不要执行 dismiss
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    [self restMemaory];
    
}


// 选中通讯录中某个人的某项属性将调用
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
}

// 点击取消调用
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    _cancelBlock();
    [self restMemaory];
}

#pragma mark - 销毁引用对象
/**
 销毁引用对象
 */
- (void)restMemaory
{
    _cancelBlock = nil;
    _selectBlock = nil;
    _contactsArrayBlock = nil;
    _vc =nil;
}
@end

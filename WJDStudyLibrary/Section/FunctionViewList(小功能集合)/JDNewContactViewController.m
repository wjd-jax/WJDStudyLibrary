//
//  JDNewContactViewController.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/5/25.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDNewContactViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface JDNewContactViewController ()<CNContactPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *identifier;
@property (weak, nonatomic) IBOutlet UILabel *contactType;
@property (weak, nonatomic) IBOutlet UILabel *namePrefix;
@property (weak, nonatomic) IBOutlet UILabel *givenName;
@property (weak, nonatomic) IBOutlet UILabel *minddleName;
@property (weak, nonatomic) IBOutlet UILabel *familyName;
@property (weak, nonatomic) IBOutlet UILabel *previousFamilyName;
@property (weak, nonatomic) IBOutlet UILabel *nameSuffix;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet UILabel *departmentName;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *phoneticCivenName;
@property (weak, nonatomic) IBOutlet UILabel *phoneticMiddleName;
@property (weak, nonatomic) IBOutlet UILabel *phoneticFamilyName;
@property (weak, nonatomic) IBOutlet UILabel *phoneticOrganizationName;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum1;
@property (weak, nonatomic) IBOutlet UILabel *phoneNum2;

@end

@implementation JDNewContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButton =[JDUtils createTextBarButtonWithTitle:@"通讯录" Target:self Action:@selector(requestContactAuthorAfterSystemVersion9)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [self requestContactAuthorAfterSystemVersion9];
    // Do any additional setup after loading the view.
}

- (void)requestContactAuthorAfterSystemVersion9{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    //等待授权状态
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
            }else {
                NSLog(@"成功授权");
            }
        }];
    }
    /*
     !应用程序未被授权访问联系人数据。*用户不能更改该应用程序的状态,可能由于活跃的限制,如家长控制。
     */
    else if(status == CNAuthorizationStatusRestricted)
    {
        
        [JDMessageView showMessage:@"无权访问"];
    }
    /* !明确拒绝用户访问联系人数据的应用程序。*/
    else if (status == CNAuthorizationStatusDenied)
    {
        [JDMessageView showMessage:@"用户拒绝"];
    }
    else if (status == CNAuthorizationStatusAuthorized)
    {
        [self openContact];
    }
    
    
}


- (void)openContact
{
    
    CNContactPickerViewController *pickerVC = [[CNContactPickerViewController alloc] init];
    //只是展示电话号码,email 等不展示
    //pickerVC.displayedPropertyKeys = [NSArray arrayWithObject:CNContactPhoneNumbersKey];
    //让有 email 的对象才可以选中
    //pickerVC.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];
    //选中联系人是否返回
    //pickerVC.predicateForSelectionOfContact =  [NSPredicate predicateWithValue:false];
    //选中属性是否返回
    // pickerVC.predicateForSelectionOfProperty = [NSPredicate predicateWithValue:false];
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
}

#pragma mark - 选择某个
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    DLog(@"%@",contact);
    _identifier.text =    contact.identifier;
    
    _contactType.text =[NSString stringWithFormat:@"%ld",(long)contact.contactType];
    _namePrefix.text =contact.namePrefix;
    _givenName.text =contact.givenName;
    _minddleName.text =contact.middleName;
    _familyName.text =contact.familyName;
    _previousFamilyName.text = contact.previousFamilyName;
    _nameSuffix.text = contact.nameSuffix;
    _nickName.text = contact.nickname;
    _organizationName.text = contact.organizationName;
    _departmentName.text = contact.departmentName;
    _jobTitle.text = contact.jobTitle;
    _phoneticCivenName.text = contact.phoneticGivenName;
    _phoneticMiddleName.text = contact.phoneticMiddleName;
    _phoneticFamilyName.text = contact.phoneticFamilyName;
    _phoneticOrganizationName.text = contact.phoneticOrganizationName;
    _headImage.image = [UIImage imageWithData:contact.imageData];
    
    
    // 2.获取联系人的电话号码
    NSArray *phoneNums = contact.phoneNumbers;
    for (CNLabeledValue *labeledValue in phoneNums) {
        // 2.1.获取电话号码的KEY
//        NSString *phoneLabel = labeledValue.label;
        
        // 2.2.获取电话号码
        CNPhoneNumber *phoneNumer = labeledValue.value;
        NSString *phoneValue = phoneNumer.stringValue;
        
        _phoneNum2.text = phoneValue;
    }
    
    // 1.获取联系人的姓名
    NSString *lastname = contact.familyName;
    NSString *firstname = contact.givenName;
    _phoneNum1.text = [NSString stringWithFormat:@"%@%@",lastname,firstname];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    
}

//点击取消操作
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    [JDMessageView showMessage:@"取消选择"];
}
@end

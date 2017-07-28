//
//  JDMD5EvntyptionViewController.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDBaseViewController.h"
typedef NS_ENUM(NSInteger ,EncryptionType) {
    Encryption_MD5,
    Encryption_AES,
    Encryption_RSA,
    Encryption_SIGN,    //签名
    Encryption_DES,
    Encryption_JavaServerORRSA,
};
@interface JDEvntyptionViewController : JDBaseViewController

@end

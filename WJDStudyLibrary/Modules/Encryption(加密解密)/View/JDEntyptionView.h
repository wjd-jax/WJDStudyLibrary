//
//  JDEntyptionView.h
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "JDEvntyptionViewController.h"

@protocol EntyptDelegate <NSObject>

- (void)encryption;
- (void)dectyption;

@end

@interface JDEntyptionView : UIView

@property (weak, nonatomic) id <EntyptDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *encryptTypeLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITextView *encryptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *decryptTextView;
@property (weak, nonatomic) IBOutlet UIButton *encryptButton;
@property (weak, nonatomic) IBOutlet UIButton *decryptButton;

@property (nonatomic,assign) EncryptionType type;
@end

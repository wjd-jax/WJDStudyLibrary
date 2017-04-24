//
//  JDEntyptionView.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/4/24.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDEntyptionView.h"

@implementation JDEntyptionView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (IBAction)encryptClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(encryption)]) {
        [self.delegate encryption];
    }
}
- (IBAction)decryptClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dectyption)]) {
        [self.delegate dectyption];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_inputTextField resignFirstResponder];
    
    return YES;
    
}
@end

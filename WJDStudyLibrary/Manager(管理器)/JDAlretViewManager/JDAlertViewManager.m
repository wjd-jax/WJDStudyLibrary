//
//  JDAlretViewManager.m
//  WJDStudyLibrary
//
//  Created by wangjundong on 2017/8/10.
//  Copyright © 2017年 wangjundong. All rights reserved.
//

#import "JDAlertViewManager.h"

@implementation JDAlertViewManager

+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
       textFieldNumber:(NSUInteger)textFieldNumber
          actionTitles:(NSArray *)actionTitle
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(actionHandler)actionHandler {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (textFieldNumber > 0) {
        for (int i = 0; i < textFieldNumber; i++) {
            [alertC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textFieldHandler(textField, i);
            }];
        }
    }
    if (actionTitle.count > 0) {
        for (NSUInteger i = 0; i < actionTitle.count; i++) {
            
            if ([actionTitle[i] isEqualToString:@"删除"]) {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)  {
                    actionHandler(action, i);
                }];
                [alertC addAction:action];
                continue;
            }
            if ([actionTitle[i] isEqualToString:@"取消"]) {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)  {
                    actionHandler(action, i);
                }];
                [alertC addAction:action];
                continue;
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}


+ (void)actionSheettWithTitle:(NSString *)title
                      message:(NSString *)message
                 actionTitles:(NSArray *)actionTitle
                actionHandler:(actionHandler)actionHandler {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    if (actionTitle.count > 0) {
        
        
        for (NSUInteger i = 0; i < actionTitle.count; i++) {
            
            if ([actionTitle[i] isEqualToString:@"删除"]) {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action)  {
                    actionHandler(action, i);
                }];
                [alertC addAction:action];
                continue;
            }
            if ([actionTitle[i] isEqualToString:@"取消"]) {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)  {
                    actionHandler(action, i);
                }];
                [alertC addAction:action];
                continue;
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
                actionHandler(action, i);
            }];
            [alertC addAction:action];
        }
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertC animated:YES completion:nil];
}



@end


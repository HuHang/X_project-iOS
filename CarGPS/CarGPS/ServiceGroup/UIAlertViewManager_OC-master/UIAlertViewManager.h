//
//  UIAlertViewManager.h
//  UIAlertViewController
//
//  Created by Charlot on 2017/3/16.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^alertActionHandler)(UIAlertAction *action, NSUInteger index, NSArray *textFields);
typedef void(^actionHandler)(UIAlertAction *action, NSUInteger index);
typedef void(^textFieldHandler)(UITextField *textField, NSUInteger index);

@interface UIAlertViewManager : NSObject


+ (void)alertWithTitle:(NSString *)title
               message:(NSString *)message
      withCancelButton:(BOOL)withCancelButton
 textFieldPlaceholders:(NSArray *)textFieldPlaceholders
          actionTitles:(NSArray *)actionTitles
      textFieldHandler:(textFieldHandler)textFieldHandler
         actionHandler:(alertActionHandler)actionHandler;


+ (void)actionSheettWithTitle:(NSString *)title
                      message:(NSString *)message
             withCancelButton:(BOOL)withCancelButton
                 actionTitles:(NSArray *)actionTitles
                actionHandler:(actionHandler)actionHandler;
@end

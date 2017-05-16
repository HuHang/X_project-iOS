//
//  UITextField+Util.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UITextField+Util.h"

@implementation UITextField (Util)

+ (UITextField *)textFieldWithTextAlignment:(NSTextAlignment)textAlignment
                              withTextColor:(UIColor *)textColor
                                   withFont:(UIFont *)font
                            withPlaceholder:(NSString *)placeholder{
    
    UITextField *textField = [[UITextField alloc] init];
    if (textColor) {
        
        textField.textColor = textColor;
    }
    if (font) {
        
        textField.font = font;
    }
    if (placeholder) {
        textField.placeholder = placeholder;
    }
    
    textField.textAlignment = textAlignment;
    return textField;
}


/**
 
 @param placeholder 提示文字
 @param leftView 左侧图片
 @param rightView 右侧图片
 @return UITextField
 */
+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                        withTextAlignment:(NSTextAlignment)textAlignment
                            withTextColor:(UIColor *)textColor
                                 withFont:(UIFont*)font
                             withLeftView:(UIView *)leftView
                            withRightView:(UIView *)rightView{
    UITextField *textField = [UITextField textFieldWithTextAlignment:textAlignment withTextColor:textColor withFont:font withPlaceholder:placeholder];

    if (leftView) {
        textField.leftView = leftView;
        textField.leftViewMode=UITextFieldViewModeAlways;
    }
    if (rightView) {
        textField.rightView = rightView;
        textField.rightViewMode=UITextFieldViewModeAlways;
    }
    return textField;
    
}
@end

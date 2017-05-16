//
//  UIButton+Util.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UIButton+Util.h"

@implementation UIButton (Util)

/**
 UIButton
 
 @param string 文字
 @param image 背景图
 @param color 背景色
 @param textAlignment 左右布局
 @param textColor 文字颜色
 @param font 字号
 @return UIButton
 */
+ (UIButton *)buttonWithString:(NSString *)string
           withBackgroundImage:(UIImage *)image
           withBackgroundColor:(UIColor *)color
             withTextAlignment:(NSTextAlignment)textAlignment
                 withTextColor:(UIColor *)textColor
                      withFont:(UIFont *)font {
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (string) {
        
        [button setTitle:string forState:UIControlStateNormal];
    }
    if (image) {
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (color) {
        
        button.backgroundColor = color;
    }
    if (textColor) {
        
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (font) {
        
        button.titleLabel.font = font;
    }
    button.titleLabel.textAlignment = textAlignment;
    return button;
}


/**
 UIButton
 
 @param string 文字
 @param color 背景色
 @param textAlignment 左右布局
 @param textColor 文字颜色
 @param font 字号
 @return UIButton
 */
+ (UIButton *)buttonWithString:(NSString *)string
           withBackgroundColor:(UIColor *)color
             withTextAlignment:(NSTextAlignment)textAlignment
                 withTextColor:(UIColor *)textColor
                      withFont:(UIFont *)font{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    if (string) {
        
        [button setTitle:string forState:UIControlStateNormal];
    }

    if (color) {
        
        button.backgroundColor = color;
    }
    if (textColor) {
        
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (font) {
        
        button.titleLabel.font = font;
    }
    button.titleLabel.textAlignment = textAlignment;
    return button;
}

+ (UIButton *)buttonWithBackgroundColor:(UIColor *)color withNormalImage:(NSString *)normalImageStr withSelectedImage:(NSString *)withSelectedImageStr{
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (color) {
        
        button.backgroundColor = color;
    }
    if (normalImageStr) {
        [button setImage:[UIImage imageNamed:normalImageStr] forState:(UIControlStateNormal)];
    }
    
    if (withSelectedImageStr) {
        [button setImage:[UIImage imageNamed:withSelectedImageStr] forState:(UIControlStateSelected)];
    }
    return button;
}

@end

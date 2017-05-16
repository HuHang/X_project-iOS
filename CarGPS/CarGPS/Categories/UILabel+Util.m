//
//  UILabel+Util.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UILabel+Util.h"

@implementation UILabel (Util)

/**
 UILabel

 @param textAlignment 布局
 @param textColor 文字颜色
 @param font 字号
 @return UILabel
 */
+ (UILabel *)labelWithTextAlignment:(NSTextAlignment)textAlignment
                      withTextColor:(UIColor *)textColor
                           withFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    if (textColor) {
        label.textColor = textColor;
    }
    
    if (font) {
        label.font = font;
    }
    if (textAlignment) {
        label.textAlignment = textAlignment;
    }
    return label;
}


/**
 UILabel

 @param string 文字
 @param textAlignment 布局
 @param textColor 文字颜色
 @param font 字号
 @return UILabel
 */
+ (UILabel *)labelWithString:(NSString *)string
           withTextAlignment:(NSTextAlignment)textAlignment
               withTextColor:(UIColor *)textColor
                    withFont:(UIFont *)font {
    UILabel *label = [UILabel labelWithTextAlignment:textAlignment withTextColor:textColor withFont:font];
    if (string) {
        label.text = string;
    }
    return label;
}

/**
 UILabel

 @param string 文字
 @param textAlignment 布局
 @param textColor 文字颜色
 @param backgroundColor 背景色
 @param font 字号
 @return UILabel
 */
+ (UILabel *)labelWithString:(NSString *)string
           withTextAlignment:(NSTextAlignment)textAlignment
               withTextColor:(UIColor *)textColor
         withBackgroundColor:(UIColor *)backgroundColor
                    withFont:(UIFont *)font{
    UILabel *label = [UILabel labelWithString:string withTextAlignment:textAlignment withTextColor:textColor withFont:font];
    if (backgroundColor) {
        label.backgroundColor = backgroundColor;
    }
    return label;
}



@end

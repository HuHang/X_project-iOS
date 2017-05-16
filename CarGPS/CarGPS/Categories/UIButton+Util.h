//
//  UIButton+Util.h
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Util)

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
                      withFont:(UIFont *)font;


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
                      withFont:(UIFont *)font;

+ (UIButton *)buttonWithBackgroundColor:(UIColor *)color withNormalImage:(NSString *)normalImageStr withSelectedImage:(NSString *)withSelectedImageStr;
@end

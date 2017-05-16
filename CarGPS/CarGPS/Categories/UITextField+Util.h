//
//  UITextField+Util.h
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Util)
+ (UITextField *)textFieldWithTextAlignment:(NSTextAlignment)textAlignment
                              withTextColor:(UIColor *)textColor
                                   withFont:(UIFont *)font
                            withPlaceholder:(NSString *)placeholder;

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
                        withTextAlignment:(NSTextAlignment)textAlignment
                            withTextColor:(UIColor *)textColor
                                 withFont:(UIFont*)font
                             withLeftView:(UIView *)leftView
                            withRightView:(UIView *)rightView;
@end

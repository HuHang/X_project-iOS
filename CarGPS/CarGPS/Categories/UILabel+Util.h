//
//  UILabel+Util.h
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Util)
+ (UILabel *)labelWithString:(NSString *)string
           withTextAlignment:(NSTextAlignment)textAlignment
               withTextColor:(UIColor *)textColor
                    withFont:(UIFont *)font;

+ (UILabel *)labelWithTextAlignment:(NSTextAlignment)textAlignment
                      withTextColor:(UIColor *)textColor
                           withFont:(UIFont *)font;

+ (UILabel *)labelWithString:(NSString *)string
           withTextAlignment:(NSTextAlignment)textAlignment
               withTextColor:(UIColor *)textColor
         withBackgroundColor:(UIColor *)backgroundColor
                    withFont:(UIFont *)font;
@end

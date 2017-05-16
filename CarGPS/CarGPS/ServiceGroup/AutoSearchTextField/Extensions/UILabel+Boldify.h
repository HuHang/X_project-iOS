//
//  UILabel+Boldify.h
//  NHAutoCompleteTextBox
//
//  Created by Shahan on 02/01/2015.
//  Copyright (c) 2015 Shahan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Boldify)
{
    
}

- (void)boldSubstring: (NSString*) substring;
- (void)boldRange: (NSRange) range;
- (void)normalizeRange:(NSRange)range;
- (void)normalizeSubstring:(NSString*)substring;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
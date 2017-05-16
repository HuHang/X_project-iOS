//
//  NSString+Init.m
//  WTSProject
//
//  Created by Charlot on 2017/3/29.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "NSString+Init.h"

@implementation NSString (Init)

+ (BOOL)isEmpty:(NSString*)text{
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    } else if ([@"" isEqualToString:text]){
        
        return YES;
    }
    return NO;
}
@end

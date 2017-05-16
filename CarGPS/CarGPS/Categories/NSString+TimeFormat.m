//
//  NSString+TimeFormat.m
//  WTSProject
//
//  Created by Charlot on 2017/3/29.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "NSString+TimeFormat.h"

@implementation NSString (TimeFormat)

/**
 截取日期

 @param dateTimeStr 日期时间
 @return 日期
 */
+ (NSString *)cutDateTimeForDate:(NSString *)dateTimeStr{
    if (dateTimeStr.length > 10) {
        return [dateTimeStr substringToIndex:10];
    }
    return dateTimeStr;
}

/**
 截取时间

 @param dateTimeStr 日期时间
 @return 时间
 */
+ (NSString *)cutDateTimeForTime:(NSString *)dateTimeStr{
    if (dateTimeStr.length > 11) {
        dateTimeStr = [dateTimeStr substringFromIndex:11];
    }
    if (dateTimeStr.length > 8) {
        dateTimeStr = [dateTimeStr substringToIndex:8];
    }
    
    
    return dateTimeStr;
}

/**
 格式化时间

 @param dateTimeStr dateTimeStr
 @return return value description
 */
+ (NSString *)formatDateTimeForCN:(NSString *)dateTimeStr{
    NSString *dateTime = [dateTimeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    if (dateTimeStr.length > 19) {
        dateTime = [dateTime substringToIndex:19];
    }
    return dateTime;
}
@end

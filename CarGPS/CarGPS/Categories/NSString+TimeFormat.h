//
//  NSString+TimeFormat.h
//  WTSProject
//
//  Created by Charlot on 2017/3/29.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeFormat)
+ (NSString *)cutDateTimeForDate:(NSString *)dateTimeStr;
+ (NSString *)cutDateTimeForTime:(NSString *)dateTimeStr;
+ (NSString *)formatDateTimeForCN:(NSString *)dateTimeStr;


@end

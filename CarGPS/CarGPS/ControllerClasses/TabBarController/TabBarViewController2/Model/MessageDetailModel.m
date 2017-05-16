//
//  MessageDetailModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/9.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MessageDetailModel.h"

@implementation MessageDetailModel


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}



- (NSArray *)getData:(NSArray *)array{
    return [MessageDetailModel mj_objectArrayWithKeyValuesArray:array];
}

@end

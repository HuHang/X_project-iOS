//
//  DeviceModel.m
//  CarGPS
//
//  Created by Charlot on 2017/4/25.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

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
    return [DeviceModel mj_objectArrayWithKeyValuesArray:array];
}
@end

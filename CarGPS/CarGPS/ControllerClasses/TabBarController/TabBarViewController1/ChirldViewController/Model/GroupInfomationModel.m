//
//  GroupInfomationModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/22.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "GroupInfomationModel.h"

@implementation GroupInfomationModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Count": @"count"};
}
- (NSArray *)getData:(NSArray *)array{
    return [GroupInfomationModel mj_objectArrayWithKeyValuesArray:array];
}
@end

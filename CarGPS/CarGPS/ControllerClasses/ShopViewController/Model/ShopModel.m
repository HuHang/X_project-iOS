//
//  ShopModel.m
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
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
    return [ShopModel mj_objectArrayWithKeyValuesArray:array];
}
@end

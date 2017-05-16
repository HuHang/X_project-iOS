//
//  DefaultModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/10.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DefaultModel.h"

@implementation DefaultModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"ID": @"id"};
//}
- (DefaultModel *)getData:(NSDictionary *)dictionary{
    return [DefaultModel mj_objectWithKeyValues:dictionary];
}
@end

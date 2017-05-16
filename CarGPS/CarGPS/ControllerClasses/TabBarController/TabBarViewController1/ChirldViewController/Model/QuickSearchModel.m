//
//  QuickSearchModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/15.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "QuickSearchModel.h"

@implementation QuickSearchModel
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
- (QuickSearchModel *)getData:(NSDictionary *)dictionary{
    return [QuickSearchModel mj_objectWithKeyValues:dictionary];
}
@end

//
//  UserInfoModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
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
- (UserInfoModel *)getData:(NSDictionary *)dictionary{
    return [UserInfoModel mj_objectWithKeyValues:dictionary];
}
@end

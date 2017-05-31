//
//  MonitorModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/4.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MonitorModel.h"

@implementation MonitorModel

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



- (MonitorModel *)getData:(NSDictionary *)dictionary{
    return [MonitorModel mj_objectWithKeyValues:dictionary];
}
@end

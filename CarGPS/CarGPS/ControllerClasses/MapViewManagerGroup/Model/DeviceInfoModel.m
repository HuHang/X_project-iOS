//
//  DeviceInfoModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/11.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DeviceInfoModel.h"

@implementation DeviceInfoModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}


- (DeviceInfoModel *)getData:(NSDictionary *)dictionary{
    return [DeviceInfoModel mj_objectWithKeyValues:dictionary];
}

@end

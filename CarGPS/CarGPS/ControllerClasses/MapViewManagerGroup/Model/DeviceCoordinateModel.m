//
//  DeviceCoordinateModel.m
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DeviceCoordinateModel.h"

@implementation DeviceCoordinateModel


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}


- (DeviceCoordinateModel *)getData:(NSDictionary *)dictionary{
    return [DeviceCoordinateModel mj_objectWithKeyValues:dictionary];
}
@end

//
//  ResponseShopGroupModel.m
//  CarGPS
//
//  Created by Charlot on 2017/11/27.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ResponseShopGroupModel.h"

@implementation ResponseShopGroupModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}


- (ResponseShopGroupModel *)getData:(NSDictionary *)dictionary{
    return [ResponseShopGroupModel mj_objectWithKeyValues:dictionary];
}

@end

//
//  ShopInfoModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/23.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ShopInfoModel.h"

@implementation ShopInfoModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}


- (ShopInfoModel *)getData:(NSDictionary *)dictionary{
    return [ShopInfoModel mj_objectWithKeyValues:dictionary];
}
@end

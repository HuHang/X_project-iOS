//
//  ShopGroupModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/23.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ShopGroupModel.h"

@implementation ShopGroupModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}





- (NSArray *)getData:(NSArray *)array{
    return [ShopGroupModel mj_objectArrayWithKeyValuesArray:array];
}
@end

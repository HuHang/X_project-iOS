//
//  CarModel.m
//  CarGPS
//
//  Created by Charlot on 2017/4/25.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel


- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}





- (NSArray *)getData:(NSArray *)array{
    return [CarModel mj_objectArrayWithKeyValuesArray:array];
}
@end

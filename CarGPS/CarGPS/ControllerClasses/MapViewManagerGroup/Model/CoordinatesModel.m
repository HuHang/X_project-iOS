//
//  CoordinatesModel.m
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CoordinatesModel.h"

@implementation CoordinatesModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}





- (NSArray *)getData:(NSArray *)array{
    return [CoordinatesModel mj_objectArrayWithKeyValuesArray:array];
}

@end

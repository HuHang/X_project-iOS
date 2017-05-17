//
//  ChartDataModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ChartDataModel.h"

@implementation ChartDataModel
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



- (NSArray *)getData:(NSArray *)array{
    return [ChartDataModel mj_objectArrayWithKeyValuesArray:array];
}
@end

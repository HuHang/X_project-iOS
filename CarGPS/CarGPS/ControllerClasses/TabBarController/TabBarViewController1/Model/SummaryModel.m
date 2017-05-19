//
//  SummaryModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "SummaryModel.h"

@implementation SummaryModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"dataNr": @"data"};
}
- (NSArray *)getData:(NSArray *)array{
    return [SummaryModel mj_objectArrayWithKeyValuesArray:array];
}
@end

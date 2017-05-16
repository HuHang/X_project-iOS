//
//  MessageTypeModel.m
//  CarGPS
//
//  Created by Charlot on 2017/5/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MessageTypeModel.h"

@implementation MessageTypeModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([NSString isEmpty:oldValue]) {
        return  @"";
    }
    return oldValue;
}
- (NSArray *)getData:(NSArray *)array{
    return [MessageTypeModel mj_objectArrayWithKeyValuesArray:array];
}
@end

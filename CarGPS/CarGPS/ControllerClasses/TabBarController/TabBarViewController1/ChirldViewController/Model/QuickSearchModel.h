//
//  QuickSearchModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/15.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuickSearchModel : NSObject
@property (copy, nonatomic)NSString *type;
@property (copy, nonatomic)NSArray *data;
- (QuickSearchModel *)getData:(NSDictionary *)dictionary;
@end

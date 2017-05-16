//
//  DefaultModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/10.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultModel : NSObject
@property BOOL Success;
@property (copy, nonatomic)NSString *Content;
@property (copy, nonatomic)NSDictionary *UserInfo;
- (DefaultModel *)getData:(NSDictionary *)dictionary;
@end

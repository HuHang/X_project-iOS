//
//  ResponseShopGroupModel.h
//  CarGPS
//
//  Created by Charlot on 2017/11/27.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseShopGroupModel : NSObject

@property unsigned int code;
@property BOOL result;
@property (copy,nonatomic)NSString *message;
@property (nonatomic,copy)NSArray *content;

- (ResponseShopGroupModel *)getData:(NSDictionary *)dictionary;
@end

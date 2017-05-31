//
//  ShopGroupModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/23.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopGroupModel : NSObject
@property (nonatomic,copy)NSDictionary *shop;
@property (nonatomic,copy)NSArray *cars;
@property BOOL is_Opened;
- (NSArray *)getData:(NSArray *)array;
@end

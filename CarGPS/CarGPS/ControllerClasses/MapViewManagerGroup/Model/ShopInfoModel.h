//
//  ShopInfoModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/23.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopInfoModel : NSObject
@property (assign, nonatomic)double longitude;
@property (assign, nonatomic)double latitude;

@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *shopTypeDisplay;
@property (copy, nonatomic)NSString *allBankPath;


- (ShopInfoModel *)getData:(NSDictionary *)dictionary;
@end

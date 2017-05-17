//
//  UserInfoModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (assign, nonatomic)unsigned int ID;
@property (assign, nonatomic)unsigned int roleType;
@property (assign, nonatomic)unsigned int shopId;
@property (assign, nonatomic)unsigned int bankId;

@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *loginId;
@property (copy, nonatomic)NSString *email;
@property (copy, nonatomic)NSString *phone;
@property (copy, nonatomic)NSString *roleTypeDisplay;
@property (copy, nonatomic)NSString *shopName;
@property (copy, nonatomic)NSString *bankName;
@property (copy, nonatomic)NSString *token;


- (UserInfoModel *)getData:(NSDictionary *)dictionary;

@end

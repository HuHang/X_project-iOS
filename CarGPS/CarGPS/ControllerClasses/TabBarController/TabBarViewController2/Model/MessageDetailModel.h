//
//  MessageDetailModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/9.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDetailModel : NSObject
@property (assign, nonatomic)unsigned int ID;
@property (assign, nonatomic)unsigned int deviceId;
@property (assign, nonatomic)double lng;
@property (assign, nonatomic)double lat;

@property (copy, nonatomic)NSString *alarmTypeStr;
@property (copy, nonatomic)NSString *createdAt;

@property (copy, nonatomic)NSString *AlarmFenceStateDisplay;
@property (copy, nonatomic)NSString *AlarmFenceState;

@property (copy, nonatomic)NSString *AlarmCurrentShopName;
@property (copy, nonatomic)NSString *AlarmShopName;
@property (copy, nonatomic)NSString *shopTypeDisplay;
@property (copy, nonatomic)NSString *imei;
@property (copy, nonatomic)NSString *vin;
@property (copy, nonatomic)NSString *carType;
@property (copy, nonatomic)NSString *carColor;


- (NSArray *)getData:(NSArray *)array;
@end

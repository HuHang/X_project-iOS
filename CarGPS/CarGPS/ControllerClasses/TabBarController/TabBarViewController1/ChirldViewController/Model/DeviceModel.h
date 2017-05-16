//
//  DeviceModel.h
//  CarGPS
//
//  Created by Charlot on 2017/4/25.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
@property (assign, nonatomic)unsigned int ID;
@property (assign, nonatomic)double lng;
@property (assign, nonatomic)double lat;
@property (assign, nonatomic)unsigned int battery;
@property (assign, nonatomic)unsigned int workState;
@property (assign, nonatomic)unsigned int batteryState;
@property (assign, nonatomic)unsigned int fenceState;
@property (assign, nonatomic)unsigned int signalLevel;

@property (copy, nonatomic)NSString *currentShopTypeDisplay;
@property (copy, nonatomic)NSString *nr;
@property (copy, nonatomic)NSString *imei;
@property (copy, nonatomic)NSString *batteryPercent;
@property (copy, nonatomic)NSString *workStateDisplay;
@property (copy, nonatomic)NSString *fenceStateDisplay;
@property (copy, nonatomic)NSString *signalLevelDisplay;
@property (copy, nonatomic)NSString *singleType;

@property (copy, nonatomic)NSString *signalTime;
@property (copy, nonatomic)NSString *vin;
@property (copy, nonatomic)NSString *carType;
@property (copy, nonatomic)NSString *carColor;
@property (copy, nonatomic)NSString *currentShopName;
@property (copy, nonatomic)NSString *bankName;

- (NSArray *)getData:(NSArray *)array;
@end

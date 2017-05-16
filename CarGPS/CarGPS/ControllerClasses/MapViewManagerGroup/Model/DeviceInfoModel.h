//
//  DeviceInfoModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/11.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoModel : NSObject
@property (assign, nonatomic)double currentLongitude;
@property (assign, nonatomic)double currentLatitude;

@property (copy, nonatomic)NSString *vin;
@property (copy, nonatomic)NSString *imei;
@property (copy, nonatomic)NSString *signalTime;

@property (copy, nonatomic)NSArray *imagesUrl;

- (DeviceInfoModel *)getData:(NSDictionary *)dictionary;
@end

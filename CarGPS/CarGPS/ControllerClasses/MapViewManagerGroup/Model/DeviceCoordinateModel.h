//
//  DeviceCoordinateModel.h
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceCoordinateModel : NSObject

@property (assign, nonatomic)double lng;
@property (assign, nonatomic)double lat;

@property (copy, nonatomic)NSString *vin;
@property (copy, nonatomic)NSString *imei;
@property (copy, nonatomic)NSString *signalTime;


- (DeviceCoordinateModel *)getData:(NSDictionary *)dictionary;
@end

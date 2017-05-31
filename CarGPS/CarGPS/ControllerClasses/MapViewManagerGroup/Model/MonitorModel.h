//
//  MonitorModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/4.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonitorModel : NSObject
@property (assign, nonatomic)unsigned int ID;
@property (assign, nonatomic)double lng;
@property (assign, nonatomic)double lat;
@property (assign, nonatomic)unsigned int fenceState;
@property (copy, nonatomic)NSString *nr;
@property (copy, nonatomic)NSString *imei;
@property (copy, nonatomic)NSString *vin;
@property (copy, nonatomic)NSString *currentShopName;
@property (copy, nonatomic)NSString *signalTime;
@property (copy, nonatomic)NSString *carType;
@property (copy, nonatomic)NSString *brand;
@property (copy, nonatomic)NSString *fenceStateDisplay;

- (MonitorModel *)getData:(NSDictionary *)dictionary;
@end

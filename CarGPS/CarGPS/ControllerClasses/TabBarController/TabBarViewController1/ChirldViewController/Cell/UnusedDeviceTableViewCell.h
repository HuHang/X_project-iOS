//
//  UnusedDeviceTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnusedDeviceTableViewCell : UITableViewCell
//imei
@property (nonatomic,strong) UILabel *imeiLabel;
//编号
@property (nonatomic,strong) UILabel *numberLabel;

//信号类型
@property (nonatomic,strong) UILabel *signalTypeLabel;
//信号强度
@property (nonatomic,strong) UILabel *signalStatusLabel;

//时间
@property (nonatomic,strong) UILabel *timeLabel;
//工作状态
@property (nonatomic,strong) UILabel *workStateLabel;
//电量
@property (nonatomic,strong) UILabel *electricyLabel;

@property (nonatomic,strong)UIImageView *batteryImage;

- (void)loadDataWithIMEI:(NSString *)imeiStr
                  number:(NSString *)numberStr
                     vin:(NSString *)vinStr
                    time:(NSString *)timeStr
              signalType:(NSString *)signalTypeStr
            signalStatus:(NSString *)signalStatusStr
        workStateDisplay:(NSString *)workStateStr
                  status:(NSString *)statusStr
                   elect:(NSString *)electStr
                    shop:(NSString *)shopStr
                    bank:(NSString *)bankStr
          withBatteryInt:(NSInteger)battery
          withFenceState:(NSInteger)fenceState
           withWorkState:(NSInteger)workState
         withSignalLevel:(NSInteger)signalLevel;
@end

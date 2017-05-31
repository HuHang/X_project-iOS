//
//  DeviceTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/7.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell
//imei
@property (nonatomic,strong) UILabel *imeiLabel;
//编号
@property (nonatomic,strong) UILabel *numberLabel;
//商店类型
@property (nonatomic,strong) UILabel *shopTypeLabel;
//商店
@property (nonatomic,strong) UILabel *shopLabel;
//银行
@property (nonatomic,strong) UILabel *bankLabel;


//信号类型
@property (nonatomic,strong) UILabel *signalTypeLabel;
//信号强度
@property (nonatomic,strong) UILabel *signalStatusLabel;
//
@property (nonatomic,strong) UILabel *statusLabel;
//时间
@property (nonatomic,strong) UILabel *timeLabel;
//工作状态
@property (nonatomic,strong) UILabel *workStateLabel;
//电量
@property (nonatomic,strong) UILabel *electricyLabel;

@property (nonatomic,strong)UIImageView *batteryImage;

@property (nonatomic,strong)UILongPressGestureRecognizer *longPressGestureRecognizer;


/**
 cell

 @param imeiStr imei
 @param numberStr nr
 @param timeStr 时间
 @param signalTypeStr 信号类型
 @param signalStatusStr 信号强度
 @param workStateStr 工作状态
 @param statusStr 设备位置状态
 @param electStr 电量
 @param shopStr 商店
 @param bankStr 银行
 @param battery 电量标示
 @param fenceState 设备位置状态标示
 @param workState 工作状态标示
 @param signalLevel 信号强度标示
 @param vin 是否绑定
 */
- (void)loadDataWithIMEI:(NSString *)imeiStr
                  number:(NSString *)numberStr
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
         withSignalLevel:(NSInteger)signalLevel
            isBindedMark:(NSString *)vin;
@end

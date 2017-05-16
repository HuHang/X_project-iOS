//
//  CarTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/25.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarTableViewCell : UITableViewCell


//vin
@property (nonatomic,strong) UILabel *vinLabel;
//商店类型
@property (nonatomic,strong) UILabel *shopTypeLabel;
//商店
@property (nonatomic,strong) UILabel *shopLabel;
//银行
@property (nonatomic,strong) UILabel *bankLabel;



@property (nonatomic,strong) UILabel *brandLabel;

@property (nonatomic,strong) UILabel *carTypeLabel;

@property (nonatomic,strong) UILabel *carColorLabel;
//
@property (nonatomic,strong) UILabel *statusLabel;
//时间
@property (nonatomic,strong) UILabel *timeLabel;


- (void)loadDataWithVin:(NSString *)vinStr
               shopType:(NSString *)shopTypeStr
               shopName:(NSString *)shopNameStr
               bankName:(NSString *)bankNameStr
                  brand:(NSString *)brandStr
                carType:(NSString *)carTypeStr
               carColor:(NSString *)carColorStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState
             isUsedMark:(NSString *)imei;
@end

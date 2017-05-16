//
//  MonitorTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/4.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonitorTableViewCell : UITableViewCell
//imei
@property (nonatomic,strong) UILabel *imeiLabel;


@property (nonatomic,strong) UILabel *vinLabel;

@property (nonatomic,strong) UILabel *shopLabel;



//品牌
@property (nonatomic,strong) UILabel *brandLabel;
//车型
@property (nonatomic,strong) UILabel *carTypeLabel;

@property (nonatomic,strong) UILabel *statusLabel;
//时间
@property (nonatomic,strong) UILabel *timeLabel;


- (void)loadDataWithVin:(NSString *)vinStr
                   imei:(NSString *)imeiStr
               shopName:(NSString *)shopNameStr
                  brand:(NSString *)brandStr
                carType:(NSString *)carTypeStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState;
@end

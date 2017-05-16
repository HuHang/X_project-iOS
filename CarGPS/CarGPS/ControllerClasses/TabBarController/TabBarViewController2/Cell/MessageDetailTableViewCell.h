//
//  MessageDetailTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MessageDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)UIColor *themeColor;
//imei

@property (nonatomic,strong) UILabel *imeiLabel;

//vin
@property (nonatomic,strong) UILabel *vinLabel;
//商店
@property (nonatomic,strong) UILabel *shopLabel;
@property (nonatomic,strong) UILabel *carTypeLabel;
//
@property (nonatomic,strong) UILabel *statusLabel;
//时间
@property (nonatomic,strong) UILabel *timeLabel;


- (void)loadDataWithVin:(NSString *)vinStr
                   imei:(NSString *)imeiStr
               shopName:(NSString *)shopNameStr
                carType:(NSString *)carTypeStr
               carColor:(NSString *)carColor
            shopTypeStr:(NSString *)shopTypeStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState;
@end

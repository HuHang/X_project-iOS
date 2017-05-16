//
//  UnBindTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnBindTableViewCell : UITableViewCell



@property (nonatomic,strong) UILabel *carCurrentShopLabel;
//vin
@property (nonatomic,strong) UILabel *vinLabel;
//商店
@property (nonatomic,strong) UILabel *shopLabel;
//银行
@property (nonatomic,strong) UILabel *bankLabel;



@property (nonatomic,strong) UILabel *brandLabel;

@property (nonatomic,strong) UILabel *carTypeLabel;
//
@property (nonatomic,strong) UILabel *carColorLabel;
//
//时间
@property (nonatomic,strong) UILabel *timeLabel;


- (void)loadDataWithVin:(NSString *)vinStr
                   imei:(NSString *)imeiStr
               shopName:(NSString *)shopNameStr
     carCurrentShopName:(NSString *)carCurrentShopNameStr
               bankName:(NSString *)bankNameStr
                  brand:(NSString *)brandStr
                carType:(NSString *)carTypeStr
               carColor:(NSString *)carColorStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState;
@end

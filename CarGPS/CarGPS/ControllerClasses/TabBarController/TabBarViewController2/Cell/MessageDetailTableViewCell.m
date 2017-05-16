//
//  MessageDetailTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MessageDetailTableViewCell.h"

@implementation MessageDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout{

    UILabel *vinTitle = [UILabel labelWithString:@"车架号:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
    UILabel *carTypeTitle = [UILabel labelWithString:@"车辆型号:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    UILabel *shopTitle = [UILabel labelWithString:@"商户名称:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    UILabel *imeiTitle = [UILabel labelWithString:@"设备编码:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    UILabel *timeTitle = [UILabel labelWithString:@"报警时间:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    self.vinLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(16.f)];
    self.imeiLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.shopLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
     self.carTypeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    self.statusLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(12.f)];
    
    
    self.timeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    UIView *lineView = [self viewWithColor:UIColorFromHEX(0xD9D9D9,1.0)];
    
    [self.contentView addSubview:carTypeTitle];
    [self.contentView addSubview:timeTitle];
    [self.contentView addSubview:vinTitle];
    [self.contentView addSubview:shopTitle];
    [self.contentView addSubview:imeiTitle];
    [self.contentView addSubview:self.imeiLabel];
    [self.contentView addSubview:self.vinLabel];
    [self.contentView addSubview:self.shopLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.carTypeLabel];
    [self.contentView addSubview:lineView];
    

    
    NSArray *titleArray = @[vinTitle,carTypeTitle,shopTitle,imeiTitle,timeTitle];
    NSArray *labelArray = @[self.vinLabel,self.carTypeLabel,self.shopLabel,self.imeiLabel,self.timeLabel];
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *label = labelArray[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0).with.mas_offset(24*i + 10);
            make.size.mas_equalTo(CGSizeMake(60, 24));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.top.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right);
            make.right.mas_equalTo(-60);
        }];
    }
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vinLabel.mas_right);
        make.right.equalTo(lineView).with.mas_offset(-5);
        make.top.and.height.equalTo(self.vinLabel);
    }];
    
    self.statusLabel.layer.cornerRadius = 12.f;
    self.statusLabel.layer.masksToBounds = YES;
}

- (void)loadDataWithVin:(NSString *)vinStr
                   imei:(NSString *)imeiStr
               shopName:(NSString *)shopNameStr
                carType:(NSString *)carTypeStr
               carColor:(NSString *)carColor
            shopTypeStr:(NSString *)shopTypeStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState{
    self.vinLabel.text = vinStr;
    self.imeiLabel.text = imeiStr;
    self.shopLabel.text = [NSString stringWithFormat:@"%@(%@)",shopNameStr,shopTypeStr];
    
    self.carTypeLabel.text = [NSString stringWithFormat:@"%@--%@",carTypeStr,carColor];
    self.timeLabel.text = timeStr;
    self.statusLabel.text = statusStr;
    
    if (fenceState != 100) {
        self.statusLabel.textColor = ZDRedColor;
    }else{
        self.statusLabel.textColor = UIColorFromHEX(0x9d9d9d, 1.0);
    }
    
}

#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}


@end

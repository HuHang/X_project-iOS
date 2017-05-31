//
//  MonitorTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/4.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MonitorTableViewCell.h"

@implementation MonitorTableViewCell

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
    UILabel *imeiTitle = [UILabel labelWithString:@"IMEI:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    UILabel *vinTitle = [UILabel labelWithString:@"VIN:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];


    
    self.vinLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.imeiLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.shopLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.statusLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(10.f)];
    
    self.brandLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.carTypeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];

    self.timeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    
    [self.contentView addSubview:imeiTitle];
    [self.contentView addSubview:vinTitle];
    [self.contentView addSubview:self.imeiLabel];
    [self.contentView addSubview:self.vinLabel];
    [self.contentView addSubview:self.shopLabel];
    [self.contentView addSubview:self.carTypeLabel];
    [self.contentView addSubview:self.brandLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.timeLabel];
    
    
    NSArray *titleArray = @[vinTitle,imeiTitle];
    NSArray *labelArray = @[self.vinLabel,self.imeiLabel];
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *label = labelArray[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(0).with.mas_offset(20*i + 10);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.top.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right);
            make.right.mas_equalTo(-60);
        }];
    }
    

    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vinLabel.mas_right);
        make.right.mas_equalTo(-10);
        make.top.and.height.equalTo(self.vinLabel);
    }];
    
    //品牌
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imeiTitle);
        make.top.equalTo(imeiTitle.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-30)/3, 20));
    }];
    
    //车型
    [self.carTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(self.brandLabel);
        make.left.equalTo(self.brandLabel.mas_right);
    }];
    
    [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.equalTo(imeiTitle);
        make.top.equalTo(self.brandLabel.mas_bottom);
        make.right.equalTo(self.statusLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(self.shopLabel);
        make.top.equalTo(self.shopLabel.mas_bottom);
    }];
    self.statusLabel.layer.cornerRadius = 10.f;
    self.statusLabel.layer.borderWidth = 1.f;
    self.statusLabel.layer.borderColor = [UIColor grayColor].CGColor;
    self.statusLabel.layer.masksToBounds = YES;
    self.carTypeLabel.adjustsFontSizeToFitWidth = YES;
    self.brandLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)loadDataWithVin:(NSString *)vinStr
                   imei:(NSString *)imeiStr
               shopName:(NSString *)shopNameStr
                  brand:(NSString *)brandStr
                carType:(NSString *)carTypeStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState{
    self.vinLabel.text = vinStr;
    self.imeiLabel.text = imeiStr;
    self.shopLabel.text = [NSString stringWithFormat:@"当前商户：%@",shopNameStr];
    self.brandLabel.text = [NSString stringWithFormat:@"品牌：%@",brandStr];
    self.carTypeLabel.text = [NSString stringWithFormat:@"车型：%@",carTypeStr];
    self.timeLabel.text = [NSString stringWithFormat:@"定位时间：%@",timeStr];
    self.statusLabel.text = statusStr;
    
    if (fenceState != 100) {
        self.statusLabel.textColor = ZDRedColor;
    }else{
        self.statusLabel.textColor = [UIColor blackColor];
    }
    
}

#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}


@end

//
//  UnBindTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UnBindTableViewCell.h"

@implementation UnBindTableViewCell

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
    
    UIView *backgroundView = [[UIView alloc] init];
    UILabel *imeiTitle = [UILabel labelWithString:@"IMEI:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    UILabel *vinTitle = [UILabel labelWithString:@"VIN:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    UILabel *shopTitle = [UILabel labelWithString:@"商店:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    UILabel *bankTitle = [UILabel labelWithString:@"银行:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    UILabel *carCurrentShopTitle = [UILabel labelWithString:@"当前商店:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    
    self.vinLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(16.f)];

    self.carCurrentShopLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.shopLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.bankLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    


    self.brandLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.carTypeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.carColorLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentRight) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    self.timeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    UIView *lineView = [self viewWithColor:UIColorFromHEX(0xD9D9D9,1.0)];
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:imeiTitle];
    [backgroundView addSubview:carCurrentShopTitle];
    [backgroundView addSubview:vinTitle];
    [backgroundView addSubview:shopTitle];
    [backgroundView addSubview:bankTitle];
    [backgroundView addSubview:self.carCurrentShopLabel];
    [backgroundView addSubview:self.vinLabel];
    [backgroundView addSubview:self.shopLabel];
    [backgroundView addSubview:self.bankLabel];
    [backgroundView addSubview:self.carTypeLabel];
    [backgroundView addSubview:self.brandLabel];
    [backgroundView addSubview:self.timeLabel];
    [backgroundView addSubview:self.carColorLabel];
    [backgroundView addSubview:lineView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 5, 3, 5));
    }];
    
    NSArray *titleArray = @[vinTitle,shopTitle,carCurrentShopTitle,bankTitle];
    NSArray *labelArray = @[self.vinLabel,self.shopLabel,self.carCurrentShopLabel,self.bankLabel];
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *label = labelArray[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0).with.mas_offset(20*i + 10);
            make.size.mas_equalTo(CGSizeMake(60, 24));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.top.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right);
            make.right.mas_equalTo(-60);
        }];
    }
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.bankLabel.mas_bottom);
    }];
    
    
    //品牌
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankTitle);
        make.top.equalTo(lineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-30)/3, 20));
    }];
    
    //车型
    [self.carTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(self.brandLabel);
        make.left.equalTo(self.brandLabel.mas_right);
    }];
    
    //颜色
    [self.carColorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(self.brandLabel);
        make.right.equalTo(lineView);
    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.height.equalTo(bankTitle);
        make.top.equalTo(self.brandLabel.mas_bottom);
        make.right.equalTo(lineView);
    }];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    [backgroundView.layer setShadowColor:UIColorFromHEX(0xe6c6c6,1.0).CGColor];
    [backgroundView.layer setShadowOpacity:0.8f];
    [backgroundView.layer setShadowOffset:CGSizeMake(0, 0)];
    [backgroundView.layer setShadowRadius:5.f];
    [backgroundView.layer setCornerRadius:5.f];
    [backgroundView.layer masksToBounds];

}

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
             withStatus:(NSInteger)fenceState{
    self.vinLabel.text = vinStr;
    self.shopLabel.text = shopNameStr;
    self.carCurrentShopLabel.text = carCurrentShopNameStr;
    self.bankLabel.text = bankNameStr;
    self.brandLabel.text = [NSString stringWithFormat:@"品牌：%@",brandStr];
    self.carTypeLabel.text = [NSString stringWithFormat:@"车型：%@",carTypeStr];
    self.carColorLabel.text = [NSString stringWithFormat:@"颜色：%@",carColorStr];
    self.timeLabel.text = timeStr;

    
}

#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}


@end

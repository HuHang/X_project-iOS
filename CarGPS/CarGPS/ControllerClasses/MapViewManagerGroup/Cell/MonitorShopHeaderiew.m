//
//  MonitorShopHeaderiew.m
//  CarGPS
//
//  Created by Charlot on 2017/5/23.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MonitorShopHeaderiew.h"

@implementation MonitorShopHeaderiew

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initLayout];
    }
    
    return self;
}

- (void)initLayout{
    UIImageView *signImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mapShop"]];
    self.shopNameLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    self.bankNameLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];

    
    [self.contentView addSubview:signImageView];
    [self.contentView addSubview:self.shopNameLabel];
    [self.contentView addSubview:self.bankNameLabel];
    
    [signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(26);
        make.top.mas_equalTo(0);
        make.left.equalTo(signImageView.mas_right).with.mas_offset(5);
        make.right.mas_equalTo(0);
    }];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(_shopNameLabel);
        make.top.equalTo(_shopNameLabel.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    
}

- (void)loadDataForHeaderViewWith:(NSString *)shopName bankName:(NSString *)bankName withCarCount:(NSInteger)count{
    self.shopNameLabel.text = [NSString stringWithFormat:@"%@(%ld)",shopName,(long)count];
    self.bankNameLabel.text = [NSString stringWithFormat:@"金融机构:%@",bankName];
}


@end

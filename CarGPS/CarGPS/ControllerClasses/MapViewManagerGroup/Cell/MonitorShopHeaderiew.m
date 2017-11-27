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
    self.signImageView = [[UIImageView alloc] init];
    self.shopNameLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    self.bankNameLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    self.carCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    [backgroundView addSubview:self.signImageView];
    [backgroundView addSubview:self.shopNameLabel];
    [backgroundView addSubview:self.bankNameLabel];
    [backgroundView addSubview:self.carCountLabel];
    [self.contentView addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 1, 0));
    }];
    
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
    }];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(36);
        make.top.mas_equalTo(0);
        make.left.equalTo(self.signImageView.mas_right).with.mas_offset(5);
        make.right.mas_equalTo(0);
    }];
    [self.carCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.shopNameLabel);
        make.top.equalTo(self.shopNameLabel.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    [self.bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.carCountLabel);
        make.top.equalTo(self.carCountLabel.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
//    self.shopNameLabel.adjustsFontSizeToFitWidth = YES;
    self.shopNameLabel.numberOfLines = 0;
    self.shopNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.signImageView.contentMode = UIViewContentModeCenter;
    
}

- (void)loadDataForHeaderViewWith:(NSString *)shopName bankName:(NSString *)bankName withCarCount:(NSInteger)count shopType:(NSInteger)shopType parentShop:(NSString *)parentShopName{
    self.bankNameLabel.text = [NSString stringWithFormat:@"金融机构:%@",bankName];
    switch (shopType) {
        case 0:
            self.shopNameLabel.text = [NSString stringWithFormat:@"%@",shopName];
            self.signImageView.image = [UIImage imageNamed:@"icon_map_4Sstore"];
            self.carCountLabel.text = [NSString stringWithFormat:@"在库：%ld 台",(long)count];
            break;
        case 2:
            self.shopNameLabel.text = [NSString stringWithFormat:@"%@/%@",parentShopName,shopName];
            self.signImageView.image = [UIImage imageNamed:@"icon_map_twolibrary"];
            self.carCountLabel.text = [NSString stringWithFormat:@"移动：%ld 台",(long)count];
            break;
        case 3:
            self.shopNameLabel.text = [NSString stringWithFormat:@"%@/%@",parentShopName,shopName];
            self.signImageView.image = [UIImage imageNamed:@"icon_map_twonet"];
            self.carCountLabel.text = [NSString stringWithFormat:@"移动：%ld 台",(long)count];
            break;
            
        default:
            self.shopNameLabel.text = [NSString stringWithFormat:@"%@",shopName];
            self.signImageView.image = [UIImage imageNamed:@"icon_dismissBtn"];
            self.carCountLabel.text = [NSString stringWithFormat:@"在库：%ld 台",(long)count];
            break;
    }
    
}


@end

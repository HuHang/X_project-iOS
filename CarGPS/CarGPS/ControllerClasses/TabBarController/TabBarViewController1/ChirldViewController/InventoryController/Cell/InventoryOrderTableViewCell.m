//
//  InventoryOrderTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/16.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "InventoryOrderTableViewCell.h"

@implementation InventoryOrderTableViewCell

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
    self.OrderNameLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(16.f)];
    self.OrderShopLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(14.f)];
    self.OrderTimeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    [self.contentView addSubview:self.OrderNameLabel];
    [self.contentView addSubview:self.OrderShopLabel];
    [self.contentView addSubview:self.OrderTimeLabel];
    [self.OrderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    [self.OrderShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.OrderNameLabel);
        make.top.equalTo(self.OrderNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 20));
    }];
    [self.OrderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(_OrderShopLabel);
        make.top.equalTo(self.OrderShopLabel.mas_bottom);
    }];
    
}

- (void)loadDataForCell{
    self.OrderNameLabel.text = @"170481日查库";
    self.OrderShopLabel.text = @"江苏乾丰汽车销售有限公司";
    self.OrderTimeLabel.text = @"2017/4/8 10:36:45";
}
@end

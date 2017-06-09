//
//  ShopTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell

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
    self.signImageView = [[UIImageView alloc] init];
    self.nameLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    self.bankLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    self.addressLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    self.additionButton = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_unSelect" withSelectedImage:@"icon_select"];
    self.bankImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_shopBank"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_address"]];
    
    [self.contentView addSubview:self.signImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.additionButton];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.bankLabel];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:_bankImageView];
    
    [self.signImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.additionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.equalTo(self.signImageView.mas_right).with.mas_offset(5);
        make.height.mas_equalTo(26);
        make.right.equalTo(self.additionButton.mas_left);
    }];
    
    [self.bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel);
    }];
    [self.bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.equalTo(_bankImageView.mas_right).with.mas_offset(10);
        make.right.equalTo(self.additionButton.mas_left);
        make.top.equalTo(_bankImageView);
    }];
    
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankLabel.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.equalTo(_nameLabel).with.mas_offset(25);
        make.right.equalTo(self.nameLabel);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.left.equalTo(_nameLabel);
        make.centerY.equalTo(self.addressLabel);
        
        
    }];

    
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.additionButton addTarget:self action:@selector(additionButtonTapped:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)setupWithName:(NSString *)name count:(NSInteger)count addressText:(NSString *)address bankName:(NSString *)bankName shopType:(NSInteger)shopType level:(NSInteger)level is_additionButtonSelected:(BOOL)is_additionButtonSelected is_expanded:(BOOL)is_expanded
{
    if (is_expanded) {
        self.signImageView.image = [UIImage imageNamed:@"icon_shopSelected"];
    }else{
        self.signImageView.image = [UIImage imageNamed:@"icon_shopUnselected"];
    }
    
    self.addressLabel.text = address;
    self.additionButton.selected = is_additionButtonSelected;
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.signImageView.mas_right).with.mas_offset(30*level + 10);
    }];
    if (level == 1) {

        if (shopType == 3) {
            self.bankLabel.text = @"二网";
        }else{
            self.bankLabel.text = @"二库";
        }
        self.nameLabel.text = name;
        self.backgroundColor = UIColorFromHEX(0xf6f6f6,1.0);
        self.signImageView.hidden = YES;
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%ld)",name,(long)count];
        self.bankLabel.text = bankName;
        self.backgroundColor = [UIColor whiteColor];
        if (count == 0) {
            self.signImageView.hidden = YES;
        }else{
            self.signImageView.hidden = NO;
        }
    }
    
}

- (void)additionButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.additionButtonTapAction) {
        self.additionButtonTapAction(sender);
    }
}

@end

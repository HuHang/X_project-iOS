//
//  FunctionDetailTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/7/14.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "FunctionDetailTableViewCell.h"

@implementation FunctionDetailTableViewCell

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
    self.functionTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    self.functionImageView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:self.functionTitleLabel];
    [self.contentView addSubview:self.functionImageView];
    
    [self.functionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.functionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.functionTitleLabel).with.mas_offset(10);
        make.top.equalTo(self.functionTitleLabel.mas_bottom).with.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 360));
    }];
    
    self.functionTitleLabel.numberOfLines = 0;
    self.functionTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)loadDataForCellWithfunctionLabel:(NSString *)title FunctionImageName:(NSString *)imageName{
    
    self.functionTitleLabel.text = title;
    self.functionImageView.image = [UIImage imageNamed:imageName];
}

@end

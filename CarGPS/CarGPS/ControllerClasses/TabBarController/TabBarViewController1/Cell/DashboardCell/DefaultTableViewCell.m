//
//  DefaultTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/6/5.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DefaultTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation DefaultTableViewCell

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
    self.contentImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.contentImage];
    [self.contentImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    self.backgroundColor = [UIColor clearColor];
}

- (void)loadDataForCellWithImageUrl:(NSString *)imageUrl{
     [self.contentImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_webImageDefault"] options:SDWebImageCacheMemoryOnly];
}

@end

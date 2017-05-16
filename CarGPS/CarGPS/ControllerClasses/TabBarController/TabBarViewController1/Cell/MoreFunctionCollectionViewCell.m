//
//  MoreFunctionCollectionViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/4/28.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MoreFunctionCollectionViewCell.h"
#define CONTENTWIDTH self.contentView.frame.size.width
@implementation MoreFunctionCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(CONTENTWIDTH/4, CONTENTWIDTH/4, CONTENTWIDTH/8, CONTENTWIDTH/4));
        }];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}
- (void)initImageViewImage:(NSString *)imageName{
    self.iconView.image = [UIImage imageNamed:imageName];
}
@end

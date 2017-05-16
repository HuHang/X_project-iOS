//
//  MessageTypeTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/5.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MessageTypeTableViewCell.h"

@implementation MessageTypeTableViewCell

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
    self.imageSign = [[UIImageView alloc] init];
    self.titleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    self.subscribeButton = [UIButton buttonWithString:@"订阅" withBackgroundColor:nil withTextAlignment:(NSTextAlignmentCenter) withTextColor:ZDRedColor withFont:SystemFont(14.f)];
    self.badge = [[RKNotificationHub alloc] initWithView:self.imageSign];
    [self.badge scaleCircleSizeBy:0.6];
    [self.badge moveCircleByX:40 Y:0];
    
    [self.contentView addSubview:self.imageSign];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subscribeButton];
    
    [_imageSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [_subscribeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.centerY.equalTo(_imageSign);
        make.right.mas_equalTo(-20);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageSign.mas_right).with.mas_offset(10);
        make.right.equalTo(_subscribeButton.mas_left);
        make.centerY.equalTo(_imageSign);
        make.height.mas_equalTo(30);
    }];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.subscribeButton setTitle:@"取消" forState:(UIControlStateSelected)];
    [self.subscribeButton.layer setCornerRadius:2.f];
    [self.subscribeButton.layer setBorderWidth:1.f];
    [self.subscribeButton.layer setBorderColor:ZDRedColor.CGColor];
    [self.subscribeButton.layer masksToBounds];
    
    [self.subscribeButton addTarget:self action:@selector(subscribeButtonTap:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)loadDataWithMessageType:(NSInteger)type messageName:(NSString *)name isSubscribed:(BOOL)is_subscribed meaageCount:(int)count{
    self.titleLabel.text = name;
    self.subscribeButton.selected = is_subscribed;
    switch (type) {
            //设备
        case 12:case 16:case 17:case 19:
            self.imageSign.image = [UIImage imageNamed:@"icon_device"];
            break;
            //电量
        case 2:case 14:case 15:
            self.imageSign.image = [UIImage imageNamed:@"icon_battery"];
            break;
            //围栏
        case 4:
            self.imageSign.image = [UIImage imageNamed:@"icon_crawIn"];
            break;
        case 5:
            self.imageSign.image = [UIImage imageNamed:@"icon_crawOut"];
            break;
            //移动
        case 3:case 6:case 9:
            self.imageSign.image = [UIImage imageNamed:@"icon_move"];
            break;
            //GPS
        case 10:case 11:case 13:case 18:case 23:
            self.imageSign.image = [UIImage imageNamed:@"icon_gps"];
            break;
            //故障
        case 1:
            self.imageSign.image = [UIImage imageNamed:@"icon_fault"];
            break;
            //其他
        case 0:case 22:
            self.imageSign.image = [UIImage imageNamed:@"icon_other"];
            break;
        default:
            self.imageSign.image = [UIImage imageNamed:@"icon_default"];
            break;
    }
    [self.badge setCount:count];
    [self.badge bump];
}

- (void)subscribeButtonTap:(UIButton *)sender
{
//    sender.selected = !sender.selected;
    
    if (self.subscribeButtonTapAction) {
        self.subscribeButtonTapAction(sender);
    }
}
@end

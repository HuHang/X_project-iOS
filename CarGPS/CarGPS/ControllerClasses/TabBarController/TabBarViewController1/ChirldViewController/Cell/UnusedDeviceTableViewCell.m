//
//  UnusedDeviceTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UnusedDeviceTableViewCell.h"

@implementation UnusedDeviceTableViewCell

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
    
    UILabel *imeiTitle = [UILabel labelWithString:@"IMEI:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    UILabel *numberTitle = [UILabel labelWithString:@"编号:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];

    
    
    UILabel *signalTypeTitle = [UILabel labelWithString:@"信号类型:" withTextAlignment:(NSTextAlignmentRight) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    UILabel *siganlStatusTitle = [UILabel labelWithString:@"信号强度:" withTextAlignment:(NSTextAlignmentRight) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    UILabel *timeTitle = [UILabel labelWithString:@"获取时间:" withTextAlignment:(NSTextAlignmentRight) withTextColor:[UIColor blackColor] withFont:SystemFont(10.f)];
    UILabel *workStateTitle = [UILabel labelWithString:@"工作状态:" withTextAlignment:(NSTextAlignmentRight) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    self.imeiLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(16.f)];
    self.numberLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    
    self.signalTypeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.signalStatusLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];

    self.timeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.workStateLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    self.electricyLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(10.f)];
    
    UIView *lineView = [self viewWithColor:UIColorFromHEX(0xD9D9D9,1.0)];
    self.batteryImage = [[UIImageView alloc] init];
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:imeiTitle];
    [backgroundView addSubview:numberTitle];

    [backgroundView addSubview:signalTypeTitle];
    [backgroundView addSubview:siganlStatusTitle];
    [backgroundView addSubview:workStateTitle];
    [backgroundView addSubview:timeTitle];
    [backgroundView addSubview:self.imeiLabel];
    [backgroundView addSubview:self.numberLabel];

    [backgroundView addSubview:self.signalStatusLabel];
    [backgroundView addSubview:self.signalTypeLabel];
    [backgroundView addSubview:self.timeLabel];
    [backgroundView addSubview:self.workStateLabel];
    [backgroundView addSubview:lineView];
    [backgroundView addSubview:self.batteryImage];
    [backgroundView addSubview:self.electricyLabel];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 5, 3, 5));
    }];
    
    NSArray *titleArray = @[imeiTitle,numberTitle];
    NSArray *labelArray = @[self.imeiLabel,self.numberLabel];
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *label = labelArray[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0).with.mas_offset(20*i + 10);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.and.top.equalTo(titleLabel);
            make.left.equalTo(titleLabel.mas_right);
            make.right.mas_equalTo(-60);
        }];
    }
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.numberLabel.mas_bottom);
    }];

    [self.batteryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.bottom.equalTo(lineView.mas_top);
    }];
    [self.electricyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.batteryImage.mas_right).with.mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(30, 20));
        make.centerY.equalTo(self.batteryImage);
    }];
    
    
    //信号类型
    [signalTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineView);
        make.top.equalTo(lineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    [self.signalTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(signalTypeTitle.mas_right);
        make.top.equalTo(signalTypeTitle);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];
    
    //信号强度
    [siganlStatusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(signalTypeTitle);
        make.right.equalTo(lineView.mas_centerX);
    }];
    [self.signalStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(self.signalTypeLabel);
        make.left.equalTo(siganlStatusTitle.mas_right);
    }];
    
    //工作状态
    [self.workStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(self.signalTypeLabel);
        make.right.equalTo(lineView);
    }];
    [workStateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(signalTypeTitle);
        make.right.equalTo(self.workStateLabel.mas_left);
    }];
    
    
    [timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(signalTypeTitle);
        make.bottom.mas_equalTo(-10);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeTitle.mas_right);
        make.top.and.height.equalTo(timeTitle);
        make.right.mas_equalTo(0);
    }];
    
    backgroundView.backgroundColor = [UIColor whiteColor];
    [backgroundView.layer setShadowColor:UIColorFromHEX(0xe6c6c6,1.0).CGColor];
    [backgroundView.layer setShadowOpacity:0.8f];
    [backgroundView.layer setShadowOffset:CGSizeMake(0, 0)];
    [backgroundView.layer setShadowRadius:5.f];
    [backgroundView.layer setCornerRadius:5.f];
    [backgroundView.layer masksToBounds];

    
    
}

- (void)loadDataWithIMEI:(NSString *)imeiStr
                  number:(NSString *)numberStr
                     vin:(NSString *)vinStr
                    time:(NSString *)timeStr
              signalType:(NSString *)signalTypeStr
            signalStatus:(NSString *)signalStatusStr
        workStateDisplay:(NSString *)workStateStr
                  status:(NSString *)statusStr
                   elect:(NSString *)electStr
                    shop:(NSString *)shopStr
                    bank:(NSString *)bankStr
          withBatteryInt:(NSInteger)battery
          withFenceState:(NSInteger)fenceState
           withWorkState:(NSInteger)workState
         withSignalLevel:(NSInteger)signalLevel{
    self.imeiLabel.text = imeiStr;
    self.numberLabel.text = numberStr;
    self.timeLabel.text = timeStr;
    
    self.electricyLabel.text = electStr;
    
    self.signalTypeLabel.text = signalTypeStr;
    self.signalStatusLabel.text = signalStatusStr;
    self.workStateLabel.text = workStateStr;
    
    
    if (workState != 100) {
        self.workStateLabel.textColor = ZDRedColor;
    }else{
        self.workStateLabel.textColor = [UIColor grayColor];
    }
    if (battery < 5) {
        self.batteryImage.image = [UIImage imageNamed:@"icon_battery0"];
    }else if (battery < 21){
        self.batteryImage.image = [UIImage imageNamed:@"icon_battery1"];
    }else if (battery < 50){
        self.batteryImage.image = [UIImage imageNamed:@"icon_battery2"];
    }else if (battery == 50){
        self.batteryImage.image = [UIImage imageNamed:@"icon_battery3"];
    }else if (battery < 100){
        self.batteryImage.image = [UIImage imageNamed:@"icon_battery4"];
    }else{
        self.batteryImage.image = [UIImage imageNamed:@"icon_battery5"];
    }
    
}

#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}


@end

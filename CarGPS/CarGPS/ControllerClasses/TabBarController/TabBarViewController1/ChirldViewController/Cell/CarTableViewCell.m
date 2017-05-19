//
//  CarTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/4/25.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CarTableViewCell.h"

@implementation CarTableViewCell

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
    UILabel *vinTitle = [UILabel labelWithString:@"车架号:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    UILabel *shopTypeTitle = [UILabel labelWithString:@"商户类型:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    UILabel *shopTitle = [UILabel labelWithString:@"商店名称:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    UILabel *bankTitle = [UILabel labelWithString:@"所属银行:" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];

    
    self.vinLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    self.shopTypeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.shopLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    self.bankLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    
    self.statusLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(10.f)];
    
    self.brandLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.carTypeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.carColorLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentRight) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    self.timeLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    UIView *lineView = [self viewWithColor:UIColorFromHEX(0xD9D9D9,1.0)];
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:shopTypeTitle];
    [backgroundView addSubview:vinTitle];
    [backgroundView addSubview:shopTitle];
    [backgroundView addSubview:bankTitle];
    [backgroundView addSubview:self.vinLabel];
    [backgroundView addSubview:self.shopTypeLabel];
    [backgroundView addSubview:self.shopLabel];
    [backgroundView addSubview:self.bankLabel];
    [backgroundView addSubview:self.carTypeLabel];
    [backgroundView addSubview:self.brandLabel];
    [backgroundView addSubview:self.statusLabel];
    [backgroundView addSubview:self.timeLabel];
    [backgroundView addSubview:self.carColorLabel];
    [backgroundView addSubview:lineView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 5, 3, 5));
    }];
    
    NSArray *titleArray = @[vinTitle,shopTypeTitle,shopTitle,bankTitle];
    NSArray *labelArray = @[self.vinLabel,self.shopTypeLabel,self.shopLabel,self.bankLabel];
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
        make.top.equalTo(self.bankLabel.mas_bottom).with.mas_offset(5);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vinLabel.mas_right);
        make.right.equalTo(lineView).with.mas_offset(-5);
        make.top.and.height.equalTo(self.vinLabel);
    }];
    
    //品牌
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankTitle);
        make.top.equalTo(lineView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-30)/3, 18));
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
    self.statusLabel.layer.cornerRadius = 12.f;
    self.statusLabel.layer.masksToBounds = YES;

    [self addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)loadDataWithVin:(NSString *)vinStr
               shopType:(NSString *)shopTypeStr
               shopName:(NSString *)shopNameStr
               bankName:(NSString *)bankNameStr
                  brand:(NSString *)brandStr
                carType:(NSString *)carTypeStr
               carColor:(NSString *)carColorStr
                   time:(NSString *)timeStr
                 status:(NSString *)statusStr
             withStatus:(NSInteger)fenceState
             isUsedMark:(NSString *)imei{
    self.vinLabel.text = vinStr;
    self.shopTypeLabel.text = shopTypeStr;
    self.shopLabel.text = shopNameStr;
    self.bankLabel.text = bankNameStr;
    self.brandLabel.text = [NSString stringWithFormat:@"品牌：%@",brandStr];
    self.carTypeLabel.text = [NSString stringWithFormat:@"车型：%@",carTypeStr];
    self.carColorLabel.text = [NSString stringWithFormat:@"颜色：%@",carColorStr];
    self.timeLabel.text = [NSString stringWithFormat:@"获取时间:%@",timeStr];
    
    if (imei.length == 0) {
        self.statusLabel.text = @"未绑定";
        self.statusLabel.textColor = [UIColor lightGrayColor];
        self.statusLabel.backgroundColor = [UIColor clearColor];
    }else{
        self.statusLabel.text = statusStr;
        if (fenceState != 100) {
            self.statusLabel.backgroundColor = ZDRedColor;
            self.statusLabel.textColor = [UIColor whiteColor];
        }else{
            self.statusLabel.backgroundColor = [UIColor clearColor];
            self.statusLabel.textColor = [UIColor lightGrayColor];
        }
    }
   
    
}

#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}
- (UILongPressGestureRecognizer *)longPressGestureRecognizer{
    if (_longPressGestureRecognizer == nil) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizer:)];
        _longPressGestureRecognizer.minimumPressDuration = 1;
    }
    return _longPressGestureRecognizer;
}

-(void)longPressGestureRecognizer:(UILongPressGestureRecognizer *)lpGR{
    
    if (lpGR.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.vinLabel.text];
        [PCMBProgressHUD showLoadingTipsInView:self.window title:self.vinLabel.text detail:@"已复制" withIsAutoHide:YES];
    }
}
- (void)dealloc{
    HHCodeLog(@"dealloc");
    [self removeGestureRecognizer:_longPressGestureRecognizer];
}
@end

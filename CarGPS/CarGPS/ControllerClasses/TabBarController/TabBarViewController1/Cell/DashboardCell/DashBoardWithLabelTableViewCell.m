//
//  DashBoardWithLabelTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashBoardWithLabelTableViewCell.h"
#import "SummaryModel.h"

@implementation DashBoardWithLabelTableViewCell

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
    self.titleImageView = [[UIImageView alloc] init];
    self.titleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
    
    self.firstTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.firstCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:UIColorFromHEX(0xFFBF00, 1.0) withFont:[UIFont fontWithName:@"STHeitiSC-Light" size:26.f]];
    self.firstUnitLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    self.secondTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:UIColorFromHEX(0xFF9094, 1.0) withFont:[UIFont fontWithName:@"STHeitiSC-Light" size:26.f]];
    self.secondUnitLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    self.thirdTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.thirdCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:UIColorFromHEX(0x79ADEA, 1.0) withFont:[UIFont fontWithName:@"STHeitiSC-Light" size:26.f]];
    self.thirdUnitLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    UIView *lineView = [[UIView alloc] init];
    UILabel *buttonLabel = [UILabel labelWithString:@"立即查看" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:self.titleImageView];
    [backgroundView addSubview:self.titleLabel];
    
    [backgroundView addSubview:self.firstTitleLabel];
    [backgroundView addSubview:self.firstCountLabel];
    [backgroundView addSubview:self.firstUnitLabel];
    
    [backgroundView addSubview:self.secondTitleLabel];
    [backgroundView addSubview:self.secondCountLabel];
    [backgroundView addSubview:self.secondUnitLabel];
    
    [backgroundView addSubview:self.thirdTitleLabel];
    [backgroundView addSubview:self.thirdCountLabel];
    [backgroundView addSubview:self.thirdUnitLabel];
    
    [backgroundView addSubview:lineView];
    [backgroundView addSubview:buttonLabel];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
    
    //标题view
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_right).with.mas_offset(8);
        make.right.mas_equalTo(0);
        make.height.and.top.equalTo(self.titleImageView);
    }];
    self.titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
    
    //信息
    NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
    NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
    
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *countLabel = countArray[i];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/[titleArray count], 60));
            make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(10);
            make.left.mas_equalTo(0).with.mas_offset(i * SCREEN_WIDTH/[titleArray count]);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.centerX.equalTo(countLabel);
            make.height.mas_equalTo(20);
            make.top.equalTo(countLabel.mas_bottom);
        }];
        
    }
    
    [buttonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    buttonLabel.preferredMaxLayoutWidth = SCREEN_WIDTH;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(buttonLabel.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    
    self.backgroundColor = [UIColor clearColor];
    backgroundView.backgroundColor = [UIColor whiteColor];
    lineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
    //    backgroundView.backgroundColor = [UIColor whiteColor];
    //    backgroundView.layer.cornerRadius = 5.f;
    //    backgroundView.layer.masksToBounds = YES;
    //    [backgroundView.layer setShadowColor:[UIColor grayColor].CGColor];
    //    [backgroundView.layer setShadowOpacity:0.8f];
    //    [backgroundView.layer setShadowOffset:CGSizeMake(0, 0)];
    //    [backgroundView.layer setShadowRadius:5.f];
}



- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type{
    self.titleLabel.text = titleString;

    self.titleImageView.image = [UIImage imageNamed:@"icon_titleImage_1"];
    NSArray *dataArray = [[SummaryModel alloc] getData:dataAry];
    if ([dataAry count] == 1) {
        self.secondTitleLabel.text = [dataArray[0] typeDisplay];
        self.secondCountLabel.text = [NSString stringWithFormat:@"%u",[dataArray[0] dataNr]];
    }else{
        NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
        NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
        for (NSInteger i = 0; i < [titleArray count]; i ++) {
            UILabel *titleLabel = titleArray[i];
            UILabel *countLabel = countArray[i];
            titleLabel.text = [dataArray[i] typeDisplay];
            countLabel.text = [NSString stringWithFormat:@"%u",[dataArray[i] dataNr]];
        }
    }
    
}


@end

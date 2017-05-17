//
//  DashBoardTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/4/28.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashBoardTableViewCell.h"
#define CONTENTWIDTH self.contentView.frame.size.width
/*
 @property (nonatomic,strong)UIView *titleContentView;
 @property (nonatomic,strong)UIImageView *titleImageView;
 @property (nonatomic,strong)UILabel *titleLabel;
 @property (nonatomic,strong)UIImageView *chartImageView;
 
 @property (nonatomic,strong)UILabel *firstTitleLabel;
 @property (nonatomic,strong)UILabel *firstCountLabel;
 @property (nonatomic,strong)UILabel *firstUnitLabel;
 
 @property (nonatomic,strong)UILabel *secondTitleLabel;
 @property (nonatomic,strong)UILabel *secondCountLabel;
 @property (nonatomic,strong)UILabel *secondUnitLabel;
 
 @property (nonatomic,strong)UILabel *thirdTitleLabel;
 @property (nonatomic,strong)UILabel *thirdCountLabel;
 @property (nonatomic,strong)UILabel *thirdUnitLabel;
 */


@implementation DashBoardTableViewCell

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
    self.titleContentView = [[UIView alloc] init];
    self.titleImageView = [[UIImageView alloc] init];
    self.titleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
    
    self.firstTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.firstCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.firstUnitLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    self.secondTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.secondUnitLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    self.thirdTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.thirdCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.thirdUnitLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    UIView *lineView = [[UIView alloc] init];
    UILabel *buttonLabel = [UILabel labelWithString:@"立即查看" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:self.titleContentView];
    [self.titleContentView addSubview:self.titleImageView];
    [self.titleContentView addSubview:self.titleLabel];
    
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
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5, 0, 20, 0));
    }];
    //标题view
    [self.titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(18, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.right.mas_equalTo(0);
        make.left.equalTo(self.titleImageView.mas_right).with.mas_offset(8);
        make.height.equalTo(self.titleImageView);
    }];
    
    
    //信息
    NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
    NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
//    NSArray *unitArray = @[self.firstUnitLabel,self.secondUnitLabel,self.thirdUnitLabel];
    
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *countLabel = countArray[i];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/[titleArray count], 60));
            make.top.equalTo(self.titleContentView.mas_bottom).with.mas_offset(10);
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
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(buttonLabel.mas_top);
        make.height.mas_equalTo(1);
    }];
    self.backgroundColor = [UIColor clearColor];
    
    lineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.layer.cornerRadius = 5.f;
    backgroundView.layer.masksToBounds = YES;
    [backgroundView.layer setShadowColor:[UIColor grayColor].CGColor];
    [backgroundView.layer setShadowOpacity:0.8f];
    [backgroundView.layer setShadowOffset:CGSizeMake(0, 0)];
    [backgroundView.layer setShadowRadius:5.f];
}



/**
 cell

 @param titleImageStr 标题图片
 @param titleStr 标题
 @param titleBackColor 标题颜色
 @param chartImageStr 图表图片
 @param titleArray 题目
 @param countArray 数量
 @param unitArray 单位
 @param titleColorArray 题目颜色
 */
- (void)setCellDataWithtitleImageNamge:(NSString *)titleImageStr
                                 title:(NSString *)titleStr
                        titleBackColor:(UIColor *)titleBackColor
                        chartImageName:(NSString *)chartImageStr
                            titleArray:(NSArray *)titleArray
                             counArray:(NSArray *)countArray
                             unitArray:(NSArray *)unitArray
                       titleColorArray:(NSArray *)titleColorArray{
    self.titleImageView.image = [UIImage imageNamed:titleImageStr];
    self.titleLabel.text = titleStr;
    self.titleContentView.backgroundColor = titleBackColor;
    
    NSArray *titleLabelArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
    NSArray *countLabelArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
    for (NSInteger i = 0; i < [titleLabelArray count] ; i ++) {
        UILabel *title = titleLabelArray[i];
        UILabel *count = countLabelArray[i];
        title.text = [NSString stringWithFormat:@"%@(%@)",titleArray[i],unitArray[i]];
        count.text = countArray[i];
    }
    
    self.firstCountLabel.textColor = titleColorArray[0];
    self.secondCountLabel.textColor = titleColorArray[1];
    self.thirdCountLabel.textColor = titleColorArray[2];
    
}
@end

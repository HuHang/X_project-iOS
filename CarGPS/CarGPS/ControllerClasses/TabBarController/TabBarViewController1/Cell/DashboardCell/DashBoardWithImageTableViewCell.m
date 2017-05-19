//
//  DashBoardWithImageTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//


/*
 @property (nonatomic,strong)UIImageView *titleImageView;
 @property (nonatomic,strong)UILabel *titleLabel;
 
 @property (nonatomic,strong)UILabel *firstTopTitle;
 @property (nonatomic,strong)UILabel *secondTopTitle;
 
 @property (nonatomic,strong)UILabel *firstCountTitle;
 @property (nonatomic,strong)UILabel *secondCountTitle;
 
 @property (nonatomic,strong)UILabel *firstTypeTitle;
 @property (nonatomic,strong)UILabel *secondTypeTitle;
 */

#import "DashBoardWithImageTableViewCell.h"
#import "SummaryModel.h"

@implementation DashBoardWithImageTableViewCell

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
    self.titleImageView = [[UIImageView alloc] init];
    self.titleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
    
    self.firstTopTitle = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondTopTitle = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.firstCountTitle = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondCountTitle = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.firstTypeTitle = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondTypeTitle = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];

    UIView *backgroundView = [[UIView alloc] init];
    UIView *lineView = [[UIView alloc] init];
    UILabel *buttonLabel = [UILabel labelWithString:@"立即查看" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    UIImageView *image1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dashboard_datebackg2"]];
    UIImageView *image2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dashboard_datebackg2"]];
   
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:image1];
    [backgroundView addSubview:image2];
    [backgroundView addSubview:self.titleImageView];
    [backgroundView addSubview:self.titleLabel];
    
    [backgroundView addSubview:self.firstTopTitle];
    [backgroundView addSubview:self.secondTopTitle];
    
    [image1 addSubview:self.firstCountTitle];
    [image1 addSubview:self.firstTypeTitle];
    [image2 addSubview:self.secondTypeTitle];
    [image2 addSubview:self.secondCountTitle];
    [backgroundView addSubview:lineView];
    [backgroundView addSubview:buttonLabel];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backgroundView).with.insets(UIEdgeInsetsMake(5, 0, 5, 0));
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
    
    [image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(backgroundView.mas_centerY);
        make.right.equalTo(backgroundView.mas_centerX).with.mas_offset(-10);
    }];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(backgroundView.mas_centerX).with.mas_offset(10);
        make.bottom.equalTo(image1);
    }];
    
    [self.firstTopTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(image1);
        make.height.mas_equalTo(20);
        make.bottom.equalTo(image1.mas_top);
    }];
    [self.secondTopTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(image2);
        make.height.equalTo(self.firstTopTitle);
        make.bottom.equalTo(image2.mas_top);
    }];
    [self.firstCountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(image1).with.insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    [self.firstTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.equalTo(self.firstCountTitle);
        make.top.equalTo(self.firstCountTitle.mas_bottom);
        make.height.mas_equalTo(20);
    }];
    [self.secondCountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(image1).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.secondTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.equalTo(self.secondCountTitle);
        make.top.equalTo(self.secondCountTitle.mas_bottom);
        make.height.mas_equalTo(15);
    }];
    
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
    backgroundView.backgroundColor = [UIColor whiteColor];
    lineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);

}

- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type{
    self.titleLabel.text = titleString;
    NSArray *dataArray = [[SummaryModel alloc] getData:dataAry];
    self.firstTopTitle.text = [dataArray[0] remark];
    self.secondTopTitle.text = [dataArray[1] remark];
    
    self.firstCountTitle.text = [NSString stringWithFormat:@"%u",[dataArray[0] dataNr]];
    self.firstTypeTitle.text = [dataArray[0] typeDisplay];
    self.secondCountTitle.text = [NSString stringWithFormat:@"%u",[dataArray[1] dataNr]];
    self.secondTypeTitle.text = [dataArray[1] typeDisplay];
}

@end

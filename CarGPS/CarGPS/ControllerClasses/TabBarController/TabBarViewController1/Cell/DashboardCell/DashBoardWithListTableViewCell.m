//
//  DashBoardWithListTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

/*
 @property (nonatomic,strong)UIImageView *titleImageView;
 @property (nonatomic,strong)UILabel *titleLabel;
 
 @property (nonatomic,strong)UILabel *leftCountLabel;
 @property (nonatomic,strong)UILabel *leftTitleLabel;
 
 @property (nonatomic,strong)UILabel *firstLineLabel;
 @property (nonatomic,strong)UILabel *secondLineLabel;
 @property (nonatomic,strong)UILabel *thirdLineLabel;
 */
#import "DashBoardWithListTableViewCell.h"
#import "SummaryModel.h"

@implementation DashBoardWithListTableViewCell

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
    
    self.leftTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(10.f)];
    self.leftCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:[UIFont fontWithName:@"STHeitiSC-Light" size:20.f]];
    
    self.firstLineLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.secondLineLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    self.thirdLineLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(10.f)];
    
    UIView *backgroundView = [[UIView alloc] init];
    self.centerLineView = [[UIView alloc] init];
    UIView *lineView = [[UIView alloc] init];
    UILabel *buttonLabel = [UILabel labelWithString:@"立即查看" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    UIImageView *leftBackView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:self.centerLineView];
    [backgroundView addSubview:self.titleImageView];
    [backgroundView addSubview:self.titleLabel];
    
    [backgroundView addSubview:leftBackView];
    [leftBackView addSubview:self.leftTitleLabel];
    [leftBackView addSubview:self.leftCountLabel];
    
    [backgroundView addSubview:self.firstLineLabel];
    [backgroundView addSubview:self.secondLineLabel];
    [backgroundView addSubview:self.thirdLineLabel];
    
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
    
    [self.centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 100));
        make.center.mas_equalTo(0);
    }];
    
    [leftBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerY.equalTo(backgroundView);
        make.centerX.mas_equalTo(-SCREEN_WIDTH/4 + 20);
    }];
    
    [self.leftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 20));
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(leftBackView.mas_centerY);
    }];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.equalTo(self.leftCountLabel);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.leftCountLabel.mas_bottom);
    }];
    //信息
    NSArray *subArray = @[self.firstLineLabel,self.secondLineLabel,self.thirdLineLabel];
    
    for (NSInteger i = 0; i < [subArray count]; i ++) {
        UILabel *subLabel = subArray[i];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerLineView.mas_right);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(100/[subArray count]);
            make.top.equalTo(self.centerLineView).with.mas_offset(i * 100/[subArray count]);
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
    
    self.leftCountLabel.adjustsFontSizeToFitWidth = YES;
    leftBackView.image = [UIImage imageNamed:@"icon_dashboard_datebackg1"];
    self.backgroundColor = [UIColor whiteColor];
    backgroundView.backgroundColor = [UIColor whiteColor];
    self.centerLineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
    lineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
}

- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type{
    self.titleLabel.text = titleString;
    NSArray *dataArray = [[SummaryModel alloc] getData:dataAry];
    
    switch ([dataArray count]) {
        case 3:
        {
            if (type == 8) {
                self.titleImageView.image = [UIImage imageNamed:@"icon_deshb_protocol"];
            }else{
                self.titleImageView.image = [UIImage imageNamed:@"icon_deshb_supervisor"];
            }
            
            NSArray *subArray = @[self.firstLineLabel,self.thirdLineLabel];
            for (NSInteger i = 0; i < [subArray count]; i ++) {
                UILabel *subLabel = subArray[i];
                NSString *countStr = [NSString stringWithFormat:@"%@",[dataArray[i + 1] dataNr]];
                NSString *labelSre = [NSString stringWithFormat:@"%@ %@",[dataArray[i + 1] typeDisplay],countStr];
                NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:labelSre];
                [colorString addAttribute:NSForegroundColorAttributeName value:UIColorFromHEX(0xFFBF00, 1.0) range:NSMakeRange([[dataArray[i + 1] typeDisplay] length] + 1, [countStr length])];
                subLabel.attributedText = colorString;
            }
            self.thirdLineLabel.text = @"";
            self.leftCountLabel.text = [NSString stringWithFormat:@"%@",[dataArray[0] dataNr]];
            self.leftTitleLabel.text = [dataArray[0] typeDisplay];
        }
            break;
        case 4:
        {
            self.centerLineView.backgroundColor = [UIColor whiteColor];
            self.titleImageView.image = [UIImage imageNamed:@"icon_deshb_draft"];
            NSArray *subArray = @[self.firstLineLabel,self.secondLineLabel,self.thirdLineLabel];
            for (NSInteger i = 1; i < [dataArray count]; i ++) {
                UILabel *subLabel = subArray[i - 1];
                NSString *countStr = [NSString stringWithFormat:@"%@",[dataArray[i] dataNr]];
                NSString *labelSre = [NSString stringWithFormat:@"%@ %@",[dataArray[i] typeDisplay],countStr];
                NSMutableAttributedString *colorString = [[NSMutableAttributedString alloc]initWithString:labelSre];
                [colorString addAttribute:NSForegroundColorAttributeName value:UIColorFromHEX(0xFFBF00, 1.0) range:NSMakeRange([[dataArray[i] typeDisplay] length] + 1, [countStr length])];
                subLabel.attributedText = colorString;

            }
            self.leftCountLabel.text = [NSString stringWithFormat:@"%@",[dataArray[0] dataNr]];
            self.leftTitleLabel.text = [dataArray[0] typeDisplay];
        }
            break;
            
        default:
            break;
    }
    
}

@end

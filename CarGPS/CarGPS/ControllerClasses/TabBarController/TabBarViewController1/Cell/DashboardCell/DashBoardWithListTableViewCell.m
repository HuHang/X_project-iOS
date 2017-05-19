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
    
    self.leftTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.leftCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    
    self.firstLineLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondLineLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.thirdLineLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    UIView *backgroundView = [[UIView alloc] init];
    UIView *centerLineView = [[UIView alloc] init];
    UIView *lineView = [[UIView alloc] init];
    UILabel *buttonLabel = [UILabel labelWithString:@"立即查看" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    
    [self.contentView addSubview:backgroundView];
    [backgroundView addSubview:centerLineView];
    [backgroundView addSubview:self.titleImageView];
    [backgroundView addSubview:self.titleLabel];
    
    [backgroundView addSubview:self.leftTitleLabel];
    [backgroundView addSubview:self.leftCountLabel];
    
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
    
    [centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(1, 100));
        make.center.mas_equalTo(0);
    }];
    [self.leftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.equalTo(centerLineView.mas_left);
        make.top.equalTo(centerLineView);
    }];
    [self.leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.left.equalTo(self.leftCountLabel);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(centerLineView);
    }];
    //信息
    NSArray *subArray = @[self.firstLineLabel,self.secondLineLabel,self.thirdLineLabel];
    
    for (NSInteger i = 0; i < [subArray count]; i ++) {
        UILabel *subLabel = subArray[i];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerLineView.mas_right);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(100/[subArray count]);
            make.top.equalTo(centerLineView).with.mas_offset(i * 100/[subArray count]);
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
    
    
    self.backgroundColor = [UIColor whiteColor];
    backgroundView.backgroundColor = [UIColor whiteColor];
    centerLineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
    lineView.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
}

- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type{
    self.titleLabel.text = titleString;
    NSArray *dataArray = [[SummaryModel alloc] getData:dataAry];
    
    switch ([dataArray count]) {
        case 3:
        {
            NSArray *subArray = @[self.firstLineLabel,self.secondLineLabel];
            for (NSInteger i = 0; i < [subArray count]; i ++) {
                UILabel *subLabel = subArray[i];
                [subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.contentView.mas_centerX).with.mas_offset(1);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(100/[subArray count]);
                    make.bottom.equalTo(self.contentView.mas_centerY).with.mas_offset(i * 100/[subArray count]);
                }];
                subLabel.text = [NSString stringWithFormat:@"%@ %u",[dataArray[i + 1] typeDisplay],[dataArray[i + 1] dataNr]];
            }
            [self.thirdLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGRectZero);
                make.center.mas_equalTo(0);
            }];
            self.leftCountLabel.text = [NSString stringWithFormat:@"%u",[dataArray[0] dataNr]];
            self.leftTitleLabel.text = [dataArray[0] typeDisplay];
        }
            break;
        case 4:
        {
            NSArray *subArray = @[self.firstLineLabel,self.secondLineLabel,self.thirdLineLabel];
            for (NSInteger i = 0; i < [dataArray count]; i ++) {
                UILabel *subLabel = subArray[i];
                subLabel.text = [NSString stringWithFormat:@"%@ %u",[dataArray[i] typeDisplay],[dataArray[i] dataNr]];

            }
            self.leftCountLabel.text = [NSString stringWithFormat:@"%u",[dataArray[0] dataNr]];
            self.leftTitleLabel.text = [dataArray[0] typeDisplay];
        }
            break;
            
        default:
            break;
    }
    
}

@end

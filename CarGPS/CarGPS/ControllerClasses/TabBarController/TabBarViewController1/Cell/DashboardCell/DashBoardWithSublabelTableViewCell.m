//
//  DashBoardWithSublabelTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashBoardWithSublabelTableViewCell.h"
#import "SummaryModel.h"

@implementation DashBoardWithSublabelTableViewCell

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
    UIView *backgroundview = [[UIView alloc] init];
    self.titleImageView = [[UIImageView alloc] init];
    self.titleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
    
    self.firstTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.firstCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.firstSubLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    self.secondTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.secondCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.secondSubLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    self.thirdTitleLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    self.thirdCountLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(28.f)];
    self.thirdSubLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    
    UIView *lineView = [[UIView alloc] init];
    UILabel *buttonLabel = [UILabel labelWithString:@"立即查看" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor lightGrayColor] withFont:SystemFont(12.f)];
    
    [self.contentView addSubview:backgroundview];
    [backgroundview addSubview:self.titleImageView];
    [backgroundview addSubview:self.titleLabel];
    
    [backgroundview addSubview:self.firstTitleLabel];
    [backgroundview addSubview:self.firstCountLabel];
    [backgroundview addSubview:self.firstSubLabel];
    
    [backgroundview addSubview:self.secondTitleLabel];
    [backgroundview addSubview:self.secondCountLabel];
    [backgroundview addSubview:self.secondSubLabel];
    
    [backgroundview addSubview:self.thirdTitleLabel];
    [backgroundview addSubview:self.thirdCountLabel];
    [backgroundview addSubview:self.thirdSubLabel];
    
    [backgroundview addSubview:lineView];
    [backgroundview addSubview:buttonLabel];
    
    [backgroundview mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    //信息
    NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
    NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
    NSArray *subArray = @[self.firstSubLabel,self.secondSubLabel,self.thirdSubLabel];
    
    for (NSInteger i = 0; i < [titleArray count]; i ++) {
        UILabel *titleLabel = titleArray[i];
        UILabel *countLabel = countArray[i];
        UILabel *subLabel = subArray[i];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/[titleArray count], 60));
            make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(10);
            make.left.mas_equalTo(0).with.mas_offset(i * SCREEN_WIDTH/[titleArray count]);
        }];
        
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.centerX.equalTo(titleLabel);
            make.height.mas_equalTo(20);
            make.top.equalTo(titleLabel.mas_bottom);
        }];
        
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.left.equalTo(countLabel);
            make.top.equalTo(countLabel.mas_bottom).with.mas_offset(50);
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
    backgroundview.backgroundColor = [UIColor whiteColor];
    //    backgroundView.layer.cornerRadius = 5.f;
    //    backgroundView.layer.masksToBounds = YES;
    //    [backgroundView.layer setShadowColor:[UIColor grayColor].CGColor];
    //    [backgroundView.layer setShadowOpacity:0.8f];
    //    [backgroundView.layer setShadowOffset:CGSizeMake(0, 0)];
    //    [backgroundView.layer setShadowRadius:5.f];
}

- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type{
    self.titleLabel.text = titleString;
    NSArray *dataArray = [[SummaryModel alloc] getData:dataAry];
    HHCodeLog(@"%@",titleString);
    HHCodeLog(@"%@",titleString);
    HHCodeLog(@"%@",titleString);
    switch ([dataArray count]) {
        case 4:
        {
            if (type == 9) {
                NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel];
                NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel];
                for (NSInteger i = 0; i < [titleArray count]; i ++) {
                    UILabel *titleLabel = titleArray[i];
                    UILabel *countLabel = countArray[i];
                    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/[titleArray count], 60));
                        make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(10);
                        make.left.mas_equalTo(0).with.mas_offset(i * SCREEN_WIDTH/[titleArray count]);
                    }];
                    
                    [countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.and.centerX.equalTo(titleLabel);
                        make.height.mas_equalTo(20);
                        make.top.equalTo(titleLabel.mas_bottom);
                    }];
                }
                [self.thirdTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGRectZero);
                    make.center.mas_equalTo(0);
                }];
                [self.thirdCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGRectZero);
                    make.center.mas_equalTo(0);
                }];

            }else{
                self.secondTitleLabel.text = [dataArray[0] typeDisplay];
                self.secondCountLabel.text = [NSString stringWithFormat:@"%u",[dataArray[0] dataNr]];
                NSArray *subArray = @[self.firstSubLabel,self.secondSubLabel,self.thirdSubLabel];
                for (NSInteger i = 1 ; i < [dataArray count]; i ++) {
                    UILabel *subLabel = subArray[i - 1];
                    subLabel.text = [NSString stringWithFormat:@"%@ %u",[dataArray[i] typeDisplay],[dataArray[i] dataNr]];
                }
            }
        }
            break;
        case 5:
        {
            [self.firstSubLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
                make.left.mas_equalTo(0);
                make.top.equalTo(self.titleLabel.mas_bottom).with.mas_offset(50);
            }];
            [self.thirdSubLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.and.top.equalTo(self.firstSubLabel);
                make.right.mas_equalTo(0);
            }];
            [self.thirdSubLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGRectZero);
                make.center.mas_equalTo(0);
            }];
            
            NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
            NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
            for (NSInteger i = 0 ; i < [titleArray count]; i ++) {
                UILabel *titleLabel = titleArray[i];
                UILabel *countLabel = countArray[i];
                titleLabel.text = [dataArray[i] typeDisplay];
                countLabel.text = [NSString stringWithFormat:@"%u",[dataArray[i] dataNr]];
            }
            self.firstSubLabel.text = [NSString stringWithFormat:@"%@ %u",[dataArray[3] typeDisplay],[dataArray[3] dataNr]];
            self.secondSubLabel.text = [NSString stringWithFormat:@"%@ %u",[dataArray[4] typeDisplay],[dataArray[4] dataNr]];
        }
            break;
        case 6:
        {
            NSArray *titleArray = @[self.firstTitleLabel,self.secondTitleLabel,self.thirdTitleLabel];
            NSArray *countArray = @[self.firstCountLabel,self.secondCountLabel,self.thirdCountLabel];
            NSArray *subArray = @[self.firstSubLabel,self.secondSubLabel,self.thirdSubLabel];
            for (NSInteger i = 0 ; i < [titleArray count]; i ++) {
                UILabel *titleLabel = titleArray[i];
                UILabel *countLabel = countArray[i];
                UILabel *subLabel = subArray[i];
                titleLabel.text = [dataArray[i] typeDisplay];
                countLabel.text = [NSString stringWithFormat:@"%u",[dataArray[i] dataNr]];
                subLabel.text = [NSString stringWithFormat:@"%@ %u",[dataArray[i + 3] typeDisplay],[dataArray[i + 3] dataNr]];
            }
        }
            break;
            
        default:
            break;
    }
    
    
}

@end

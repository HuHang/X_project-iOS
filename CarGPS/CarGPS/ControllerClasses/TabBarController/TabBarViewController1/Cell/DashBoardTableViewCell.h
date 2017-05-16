//
//  DashBoardTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/28.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *titleContentView;
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *firstTitleLabel;
@property (nonatomic,strong)UILabel *firstCountLabel;
@property (nonatomic,strong)UILabel *firstUnitLabel;

@property (nonatomic,strong)UILabel *secondTitleLabel;
@property (nonatomic,strong)UILabel *secondCountLabel;
@property (nonatomic,strong)UILabel *secondUnitLabel;

@property (nonatomic,strong)UILabel *thirdTitleLabel;
@property (nonatomic,strong)UILabel *thirdCountLabel;
@property (nonatomic,strong)UILabel *thirdUnitLabel;

- (void)setCellDataWithtitleImageNamge:(NSString *)titleImageStr
                                 title:(NSString *)titleStr
                        titleBackColor:(UIColor *)titleBackColor
                        chartImageName:(NSString *)chartImageStr
                            titleArray:(NSArray *)titleArray
                             counArray:(NSArray *)countArray
                             unitArray:(NSArray *)unitArray
                       titleColorArray:(NSArray *)titleColorArray;
@end

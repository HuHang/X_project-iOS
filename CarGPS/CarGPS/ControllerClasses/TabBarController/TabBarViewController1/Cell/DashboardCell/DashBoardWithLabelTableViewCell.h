//
//  DashBoardWithLabelTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DashBoardWithLabelTableViewCell : UITableViewCell
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


- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type;
@end

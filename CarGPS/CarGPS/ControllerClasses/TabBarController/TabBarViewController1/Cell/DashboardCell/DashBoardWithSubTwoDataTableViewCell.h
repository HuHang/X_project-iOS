//
//  DashBoardWithSubTwoDataTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/6/5.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardWithSubTwoDataTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *firstTitleLabel;
@property (nonatomic,strong)UILabel *firstCountLabel;
@property (nonatomic,strong)UILabel *firstSubLabel;

@property (nonatomic,strong)UILabel *secondTitleLabel;
@property (nonatomic,strong)UILabel *secondCountLabel;
@property (nonatomic,strong)UILabel *secondSubLabel;

- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type;
@end

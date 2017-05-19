//
//  DashBoardWithListTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardWithListTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *leftCountLabel;
@property (nonatomic,strong)UILabel *leftTitleLabel;

@property (nonatomic,strong)UILabel *firstLineLabel;
@property (nonatomic,strong)UILabel *secondLineLabel;
@property (nonatomic,strong)UILabel *thirdLineLabel;
- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type;
@end

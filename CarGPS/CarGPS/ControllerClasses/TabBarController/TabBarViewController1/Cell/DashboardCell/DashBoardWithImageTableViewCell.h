//
//  DashBoardWithImageTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashBoardWithImageTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *firstTopTitle;
@property (nonatomic,strong)UILabel *secondTopTitle;

@property (nonatomic,strong)UILabel *firstCountTitle;
@property (nonatomic,strong)UILabel *secondCountTitle;

@property (nonatomic,strong)UILabel *firstTypeTitle;
@property (nonatomic,strong)UILabel *secondTypeTitle;

- (void)setCellDataWithData:(NSArray *)dataAry withtitle:(NSString *)titleString withType:(int)type;
@end

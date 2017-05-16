//
//  ShopTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^additionButtonTapAction)(id sender);

@property (nonatomic,strong)UIImageView *signImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UIButton *additionButton;

- (void)setupWithName:(NSString *)name count:(NSString *)count addressText:(NSString *)address level:(NSInteger)level is_additionButtonSelected:(BOOL)is_additionButtonSelected;
@end

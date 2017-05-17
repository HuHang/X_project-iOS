//
//  InventoryOrderTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/16.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InventoryOrderTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel* OrderNameLabel;
@property (nonatomic,strong)UILabel* OrderShopLabel;
@property (nonatomic,strong)UILabel* OrderTimeLabel;

- (void)loadDataForCell;
@end

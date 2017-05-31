//
//  MonitorShopHeaderiew.h
//  CarGPS
//
//  Created by Charlot on 2017/5/23.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MonitorShopHeaderiew : UITableViewHeaderFooterView
@property (nonatomic,strong)UILabel *shopNameLabel;
@property (nonatomic,strong)UILabel *bankNameLabel;
- (void)loadDataForHeaderViewWith:(NSString *)shopName bankName:(NSString *)bankName withCarCount:(NSInteger)count;

@end
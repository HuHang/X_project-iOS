//
//  CenterLabelTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterLabelTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *centerLabel;
- (void)setCallDataWithString:(NSString *)string;
@end

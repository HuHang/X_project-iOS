//
//  DefaultTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/6/5.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *contentImage;
- (void)loadDataForCellWithImageUrl:(NSString *)imageUrl;
@end

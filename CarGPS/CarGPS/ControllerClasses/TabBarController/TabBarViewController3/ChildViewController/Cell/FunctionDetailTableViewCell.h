//
//  FunctionDetailTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/7/14.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionDetailTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *functionTitleLabel;
@property (nonatomic,strong)UIImageView *functionImageView;

- (void)loadDataForCellWithfunctionLabel:(NSString *)title FunctionImageName:(NSString *)imageName;

@end

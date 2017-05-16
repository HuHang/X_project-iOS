//
//  MoreFunctionCollectionViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/4/28.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreFunctionCollectionViewCell : UICollectionViewCell

@property(strong,nonatomic)UIImageView *iconView;
- (void)initImageViewImage:(NSString *)imageName;
@end

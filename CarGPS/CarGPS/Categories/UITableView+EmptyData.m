//
//  UITableView+EmptyData.m
//  WTSProject
//
//  Created by Charlot on 2017/4/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)


- (void)tableViewDisplayWithImage:(NSString *)imageStr ifNecessaryForRowCount:(NSUInteger)rowCount withSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
{
    if (rowCount == 0) {
        UIView *view = [UIView new];
        self.backgroundView = view;
        UIImageView *showImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        showImage.center = view.center;
        [view addSubview:showImage];
        showImage.contentMode = UIViewContentModeScaleAspectFit;
        showImage.image = [UIImage imageNamed:imageStr ? imageStr : @"icon_noData"];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = separatorStyle;
    }
}
@end

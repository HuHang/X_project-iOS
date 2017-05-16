//
//  UITableView+EmptyData.h
//  WTSProject
//
//  Created by Charlot on 2017/4/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)
- (void)tableViewDisplayWithImage:(NSString *)imageStr ifNecessaryForRowCount:(NSUInteger)rowCount withSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

@end

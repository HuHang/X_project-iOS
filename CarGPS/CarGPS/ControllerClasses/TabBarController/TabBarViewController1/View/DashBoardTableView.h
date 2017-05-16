//
//  DashBoardTableView.h
//  CarGPS
//
//  Created by Charlot on 2017/4/27.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DashBoardTableViewDelegate
-(void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface DashBoardTableView : UITableView

@property(assign,nonatomic)CGFloat contentOffsetY;
@property(nonatomic,assign) id <DashBoardTableViewDelegate>dashBoardDelegate;

-(void)startRefreshing;

@end

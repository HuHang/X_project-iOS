//
//  DeviceListTableViewController.h
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SearchInputtingDelegate <NSObject>

- (void)searchMyInput:(NSString *)inputStr;

@end
@interface DeviceListTableViewController : UITableViewController
@property(nonatomic,weak)id<SearchInputtingDelegate>delegate;
@end

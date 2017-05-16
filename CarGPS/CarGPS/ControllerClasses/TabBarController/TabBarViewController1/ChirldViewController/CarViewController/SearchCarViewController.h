//
//  SearchCarViewController.h
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarListTableViewController.h"
@interface SearchCarViewController : UIViewController<UISearchResultsUpdating,SearchInputtingDelegate>

@property(nonatomic,copy)void(^backBlock)(void);
@property(nonatomic,strong)UISearchController *searchVC;

@end

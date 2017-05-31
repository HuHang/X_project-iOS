//
//  ShopViewController.h
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShopSelectChangeDelegate
- (void)shopChanged;
@end

@interface ShopViewController : UIViewController
@property BOOL singleSelection;

@property (nonatomic, assign) id <ShopSelectChangeDelegate> delegate;
@end

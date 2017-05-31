//
//  SignalDeviceOrCarMapViewController.h
//  CarGPS
//
//  Created by Charlot on 2017/5/22.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignalDeviceOrCarMapViewController : UIViewController
@property NSInteger deviceID;
@property (nonatomic,strong)NSString *vinNumber;
@property BOOL is_Car;
@end

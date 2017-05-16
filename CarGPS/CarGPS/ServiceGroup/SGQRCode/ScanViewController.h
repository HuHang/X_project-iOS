//
//  ScanViewController.h
//  WTSProject
//
//  Created by Charlot on 2017/3/30.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGQRCode.h"

@protocol ScanViewControllerDelegate
- (void)passDataBack: (NSString *)data;
@end

@interface ScanViewController : SGQRCodeScanningVC
@property (nonatomic, weak) id <ScanViewControllerDelegate> delegate;
@end

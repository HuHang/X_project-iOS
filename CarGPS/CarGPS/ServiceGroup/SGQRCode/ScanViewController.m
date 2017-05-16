//
//  ScanViewController.m
//  WTSProject
//
//  Created by Charlot on 2017/3/30.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;
     SGQRCodeLog(@"SGQRCodeInformationFromeAibum - - %@", string);
//    ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//    jumpVC.jump_URL = string;
//    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
    
    NSString *string = noti.object;
//    SGQRCodeLog(@"SGQRCodeInformationFromeScanning - - %@", string);
    [self.delegate passDataBack:string];
//    if ([string hasPrefix:@"http"]) {
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.jump_URL = string;
//        [self.navigationController pushViewController:jumpVC animated:YES];
//        
//    } else { // 扫描结果为条形码
//        
//        ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
//        jumpVC.jump_bar_code = string;
//        [self.navigationController pushViewController:jumpVC animated:YES];
//    }
}

- (void)dealloc {
    SGQRCodeLog(@"dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
}

@end

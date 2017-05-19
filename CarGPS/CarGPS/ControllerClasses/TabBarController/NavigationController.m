//
//  NavigationController.m
//  WTSProject
//
//  Created by Charlot on 2017/4/6.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "NavigationController.h"


@interface NavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationBar.translucent = YES;
    
    [self.navigationBar lt_setBackgroundColor:ZDRedColor];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    if (![[super topViewController] isKindOfClass:[viewController class]]) {
        [super pushViewController:viewController animated:animated];
    }
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backBtn.frame = CGRectMake(0, 0, 15, 10);
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_backWhite"] forState:UIControlStateNormal];
//    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    viewController.navigationItem.backBarButtonItem = leftbutton;
    
    
}
- (void)back {
    //返回上一个控制器
    [self popViewControllerAnimated:YES];
}

@end

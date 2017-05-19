//
//  TabBarViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationController.h"


#import "HomeViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"

#import "MainMapListViewController.h"



@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewAppearance];
    [self CreateTabBar];
    NSLog(@"1");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)initViewAppearance{
    UIView *bgView = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    self.tabBar.tintColor = ZDRedColor;
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ZDRedColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0],NSFontAttributeName, nil] forState:UIControlStateSelected];
}
- (void)CreateTabBar{
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
//    [homeViewController.tabBarItem setTitle:@"首页"];
//    [homeViewController.tabBarItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabBarIcon%d",0]]];
//    //[homeViewController setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabBarSelectedIcon%d",i]]];
//    
//    
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
//    NavigationController *messageViewControllerNav = [[NavigationController alloc] initWithRootViewController:messageViewController];
//    [messageViewControllerNav.tabBarItem setTitle:@"消息"];
//    [messageViewControllerNav.tabBarItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabBarIcon%d",1]]];
//    //[messageViewControllerNav setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabBarSelectedIcon%d",i]]];
//    
//    
//    
    SettingViewController *settingViewController = [[SettingViewController alloc] init];
//    NavigationController *settingViewControllerNav = [[NavigationController alloc] initWithRootViewController:settingViewController];
//    [settingViewControllerNav.tabBarItem setTitle:@"我的"];
//    [settingViewControllerNav.tabBarItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabBarIcon%d",2]]];
//    //[settingViewControllerNav setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"tabBarSelectedIcon%d",i]]];
//    self.viewControllers = @[homeViewController,messageViewControllerNav,settingViewControllerNav];
    

    NSArray *navigationArry = @[homeViewController,messageViewController,settingViewController];
    NSArray *navigationTitleArry = @[@"首页",@"消息",@"我的"];
    
    for (int i = 0; i < [navigationArry count]; i ++) {
        UIViewController *viewController = navigationArry[i];
        NavigationController *navc = [[NavigationController alloc] initWithRootViewController:viewController];
        
        [navc.tabBarItem setTitle:navigationTitleArry[i]];
        [navc.tabBarItem setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_tabBar%d",i]]];
        [navc.tabBarItem setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_tabBar_selected%d",i]]];
        [self addChildViewController:navc];
//        if (i != 3) {
//            viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toMap"] style:UIBarButtonItemStylePlain target:self action:@selector(reSetRootView)];
//        }
        
    }

    
    
    
}


@end

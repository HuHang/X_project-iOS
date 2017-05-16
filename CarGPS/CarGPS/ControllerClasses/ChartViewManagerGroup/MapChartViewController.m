//
//  MapChartViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/11.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MapChartViewController.h"
#import "AppDelegate.h"
#import "iOS-Echarts.h"
#import "RMMapper.h"



@interface MapChartViewController ()
@property (nonatomic, strong) PYEchartsView *yEchartView;

@end

@implementation MapChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//    appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
//    
//    [self setNewOrientation:YES];//调用转屏代码
//    // Do any additional setup after loading the view.
//    UIButton *button = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_backWhite" withSelectedImage:nil];
//    button.frame = CGRectMake(0, 0, 44, 44);
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = item;
//    [button addTarget:self action:@selector(back) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.yEchartView = [[PYEchartsView alloc] init];
//    [self.view addSubview:_yEchartView];
//    [_yEchartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(20, 20, 20, 20));
//    }];
//    [self showStandardMap1Demo];
//    [self.yEchartView loadEcharts];
}

//- (PYEchartsView *)yEchartView{
//    if (_yEchartView == nil) {
//        
//    }
//}

//- (void)showStandardMap1Demo {
//    NSString *json = @"{\"title\":{\"text\":\"iphone销量\",\"subtext\":\"纯属虚构\",\"x\":\"center\"},\"tooltip\":{\"trigger\":\"item\"},\"legend\":{\"orient\":\"vertical\",\"x\":\"left\",\"data\":[\"iphone3\",\"iphone4\",\"iphone5\"]},\"dataRange\":{\"min\":0,\"max\":2500,\"x\":\"left\",\"y\":\"bottom\",\"text\":[\"高\",\"低\"],\"calculable\":true},\"toolbox\":{\"show\":true,\"orient\":\"vertical\",\"x\":\"right\",\"y\":\"center\",\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"roamController\":{\"show\":false,\"x\":\"right\",\"mapTypeControl\":{\"china\":true}},\"series\":[{\"name\":\"iphone3\",\"type\":\"map\",\"mapType\":\"china\",\"roam\":false,\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}},\"emphasis\":{\"label\":{\"show\":true}}},\"data\":[{\"name\":\"北京\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"天津\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"上海\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"重庆\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"河北\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"河南\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"云南\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"辽宁\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"黑龙江\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"湖南\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"安徽\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"山东\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"新疆\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"江苏\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"浙江\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"江西\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"湖北\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"广西\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"甘肃\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"山西\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"内蒙古\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"陕西\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"吉林\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"福建\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"贵州\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"广东\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"青海\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"西藏\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"四川\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"宁夏\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"海南\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"台湾\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"香港\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"澳门\",\"value\":\"Math.round(Math.random()*1000)\"}]},{\"name\":\"iphone4\",\"type\":\"map\",\"mapType\":\"china\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}},\"emphasis\":{\"label\":{\"show\":true}}},\"data\":[{\"name\":\"北京\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"天津\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"上海\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"重庆\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"河北\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"安徽\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"新疆\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"浙江\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"江西\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"山西\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"内蒙古\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"吉林\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"福建\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"广东\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"西藏\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"四川\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"宁夏\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"香港\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"澳门\",\"value\":\"Math.round(Math.random()*1000)\"}]},{\"name\":\"iphone5\",\"type\":\"map\",\"mapType\":\"china\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}},\"emphasis\":{\"label\":{\"show\":true}}},\"data\":[{\"name\":\"北京\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"天津\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"上海\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"广东\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"台湾\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"香港\",\"value\":\"Math.round(Math.random()*1000)\"},{\"name\":\"澳门\",\"value\":\"Math.round(Math.random()*1000)\"}]}]}";
//    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
//    [_yEchartView setOption:option];
//}



//#pragma mark - 屏幕方向
//- (void)setNewOrientation:(BOOL)fullscreen
//
//{
//    if (fullscreen) {
//        
//        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
//        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//        
//    }else{
//        
//        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//        
//        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
//
//        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//        
//        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//        
//    }
//    
//}
//- (void)back
//
//{
//    
//    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    
//    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
//    
//    [self setNewOrientation:NO];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
////    [self.navigationController popViewControllerAnimated:YES];
//    
//}

@end

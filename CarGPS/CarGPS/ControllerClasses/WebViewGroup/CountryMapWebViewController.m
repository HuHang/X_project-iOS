//
//  CountryMapWebViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CountryMapWebViewController.h"
//#import "AppDelegate.h"

@interface CountryMapWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation CountryMapWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self forceOrientationLandscape];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    [self createWebView];
    [self loadWebViewData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:YES];
//    //释放约束
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    appdelegate.isForcePortrait=NO;
//    appdelegate.isForceLandscape=NO;
//    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
//    //退出界面前恢复竖屏
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//    
//}


- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (void)createWebView{
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
        make.left.and.top.mas_equalTo(0);
    }];
}

- (void)loadWebViewData{
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ECharts" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
//    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://139.224.134.254:9001/Report_DailySupervision/Mui?request_from=app"]];
    [self.webView loadRequest:request];

}

//webview加载完成后加载图表数据
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    HHCodeLog(@"finish");
    //传值标题
    NSString *setTitle = @"数量（吨)";
    [_webView stringByEvaluatingJavaScriptFromString:setTitle];
    
    //传值X轴
    [_webView stringByEvaluatingJavaScriptFromString:@"setData(['桔子','香蕉','苹果','西瓜'])"];
    //柱状图
    NSString *setValueData = [NSString stringWithFormat:@"setValueData([%@,%@,%@,%@])",@"200",@"100",@"260",@"400"];
    
    //传值Y轴数据
    [_webView stringByEvaluatingJavaScriptFromString:setValueData];
    
    
    
}

#pragma  mark 横屏设置
/**
 *  强制横屏
 */
//-(void)forceOrientationLandscape{
//    //这种方法，只能旋转屏幕不能达到强制横屏的效果
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeLeft;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//    //加上代理类里的方法，旋转屏幕可以达到强制横屏的效果
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    appdelegate.isForceLandscape=YES;
//    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
//    
//}
///**
// *  强制竖屏
// */
//-(void)forceOrientationPortrait{
//    
//    //加上代理类里的方法，旋转屏幕可以达到强制竖屏的效果
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    appdelegate.isForcePortrait=YES;
//    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
//    
//}
@end

//
//  CountryMapWebViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CountryMapWebViewController.h"
#import "ChartDataModel.h"
#import "YJWebProgressLayer.h"


@interface CountryMapWebViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong) YJWebProgressLayer *webProgressLayer;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation CountryMapWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar lt_setBackgroundColor:UIColorFromHEX(0x333333, 1.0)];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = self.titleStr;
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    [self.view addSubview:self.tableView];
//    [self callHttpForMapData];
    // Do any additional setup after loading the view.
    [self reloadWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:ZDRedColor];
    
}
- (void)dealloc {
    
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}



- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = UIColorFromHEX(0xFBF4F4, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 1)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
//        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://139.224.134.254:9001/Report_DailySupervision/AllCharts?request_from=app&request_type=enterStock&token=Basic%20YWRtaW46YWRtaW4="]]];

    }
    return _webView;
}
- (YJWebProgressLayer *)webProgressLayer{
    if (_webProgressLayer == nil) {
        _webProgressLayer = [[YJWebProgressLayer alloc] init];
        _webProgressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);

    }
    return _webProgressLayer;
}

#pragma mark - http 
- (void)callHttpForMapData{
    __weak CountryMapWebViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"type=%@",@"enterStock"];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]
                              success:^(id data) {
                                  weakself.dataArray = [[ChartDataModel alloc] getData:data[0][@"data"]];
                                  [weakself reloadWebView];

        
    }
                              failure:^(NSError *error) {
        
                              }];
}



- (void)reloadWebView{
//    ChartDataModel *item = (ChartDataModel *)self.dataArray[0];
//    NSString *urlStr = @"http://139.224.134.254:9001/Report_DailySupervision/AllCharts?request_from=app&request_type=enterStock&token=Basic YWRtaW46YWRtaW4=";
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",item.url,[[NSUserDefaults standardUserDefaults] valueForKey:TOKEN]];
//    HHCodeLog(@"%@",urlStr);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];

}

#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        [cell.contentView addSubview:self.webView];
        /* 忽略点击效果 */
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _webView.frame.size.height;
}


#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_webProgressLayer finishedLoadWithError:nil];
    HHCodeLog(@"finish");
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, SCREEN_WIDTH, height);
    [self.tableView reloadData];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [_webProgressLayer startLoad];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_webProgressLayer finishedLoadWithError:error];
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

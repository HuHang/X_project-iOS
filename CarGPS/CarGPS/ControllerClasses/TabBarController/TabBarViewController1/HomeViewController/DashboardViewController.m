//
//  DashboardViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashboardViewController.h"
#import "ChartDataModel.h"
#import "YJWebProgressLayer.h"
#import "WebviewTableViewCell.h"
#import "SegmentCustomStyleManager.h"


@interface DashboardViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,SegmentCustomViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic, strong) YJWebProgressLayer *webProgressLayer;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong) SegmentCustomStyleManager *segmentView;
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
//    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    [self viewLayout];
    [self callHttpForMapData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        _tableView = [[UITableView alloc] init];
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
        //        [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        
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
- (SegmentCustomStyleManager *)segmentView{
    if (_segmentView == nil) {
        NSArray *arrar = [NSArray arrayWithObjects:@"车辆入库统计",@"车辆出库统计",@"日均在库统计",nil];
        _segmentView = [[SegmentCustomStyleManager alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.type = PiecewiseInterfaceTypeMobileLin;
        _segmentView.delegate = self;
        _segmentView.textFont = [UIFont systemFontOfSize:14.f];
        _segmentView.textNormalColor = [UIColor grayColor];
        _segmentView.textSeletedColor = ZDRedColor;
        _segmentView.linColor = ZDRedColor;
        [_segmentView loadTitleArray:arrar];
    }
    return _segmentView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelWithString:@"日常监管情况" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(16.f)];
    }
    return _titleLabel;
}



- (void)viewLayout{
    UIButton *button = [UIButton buttonWithString:@"返回" withBackgroundColor:ZDRedColor withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    [self.view addSubview:button];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleLabel];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 20));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 20));
        make.left.mas_equalTo(0);
        make.top.equalTo(button.mas_bottom);
    }];
    [button addTarget:self action:@selector(dissMissView) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - http
- (void)callHttpForMapData{
    __weak DashboardViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"type=%@",@"enterStock"];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]
                              success:^(id data) {
                                  weakself.dataArray = [[ChartDataModel alloc] getData:data[0][@"data"]];
                                  [weakself.tableView reloadData];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}



- (void)reloadWebView{
    ChartDataModel *item = (ChartDataModel *)self.dataArray[0];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",item.url,[[NSUserDefaults standardUserDefaults] valueForKey:TOKEN]];
    HHCodeLog(@"%@",urlStr);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
}

#pragma mark -
#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    HHCodeLog(@"%lu-%ld",(unsigned long)[self.dataArray count],(long)indexPath.row);


    WebviewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WebviewTableViewCell class])];
    
    if (cell == nil) {
        HHCodeLog(@"hahah");
        cell = [[WebviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WebviewTableViewCell class])];
        
//        ChartDataModel *item = (ChartDataModel *)self.dataArray[indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        NSString *urlStr = [NSString stringWithFormat:@"%@%@",item.url,[[NSUserDefaults standardUserDefaults] valueForKey:TOKEN]];
        NSString *urlStr = @"http://139.224.134.254:9001/Report_DailySupervision/ProvinceMap?request_from=app&request_type=enterStock&token=Basic YWRtaW46YWRtaW4=";
        [cell loadDataForCellWithURl:urlStr];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.segmentView;
}

#pragma mark - segment delegate
- (void)segmentCustomView:(SegmentCustomStyleManager *)segmentCustomView index:(NSInteger)index{

    
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
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_webProgressLayer finishedLoadWithError:error];
    NSLog(@"didFailLoadWithError===%@", error);
}

@end

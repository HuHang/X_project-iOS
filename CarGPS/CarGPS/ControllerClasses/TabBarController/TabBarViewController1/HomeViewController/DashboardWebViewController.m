//
//  DashboardWebViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/18.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashboardWebViewController.h"
#import <WebKit/WebKit.h>
#import "SegmentCustomStyleManager.h"
#import "ChartDataModel.h"
#import "PopoverView.h"

@interface DashboardWebViewController ()<SegmentCustomViewDelegate,WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic,strong) SegmentCustomStyleManager *segmentView;
@property NSInteger selectedIndex;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *typeButton;

@end

@implementation DashboardWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotate{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
//    [self reloadWebViewWithURLStr:sel];

//    [self callHttpForMapDataWithType:@"enterStock"];
}

-(void)dealloc{
    HHCodeLog(@"dealloc");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _scrollView;
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
- (UIButton *)typeButton{
    if (_typeButton == nil) {
         _typeButton = [UIButton buttonWithString:@".." withBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
        _typeButton.layer.cornerRadius = 10.f;
        _typeButton.layer.masksToBounds= YES;
        
    }
    return _typeButton;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelWithString:@"日常监管情况" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(16.f)];
    }
    return _titleLabel;
}

- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = ZDRedColor;
        _progressView.trackTintColor = [UIColor brownColor];
    }
    return _progressView;
}
- (WKWebView *)webView{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        _webView.backgroundColor = ZDRedColor;
    }
    return _webView;
}

- (void)addObserverForWebview{
    NSKeyValueObservingOptions observingOptions = NSKeyValueObservingOptionNew;
    // KVO 监听属性，除了下面列举的两个，还有其他的一些属性，具体参考 WKWebView 的头文件
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:observingOptions context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:observingOptions context:nil];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:observingOptions context:nil];
}

#pragma mark - view
- (void)viewLayout{
    UIView *titleView = [[UIView alloc] init];
    UIButton *backButton = [UIButton buttonWithString:@"返回" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
   
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:titleView];
    [self.scrollView addSubview:self.segmentView];
    [self.scrollView addSubview:self.webView];
    [titleView addSubview:backButton];
    [titleView addSubview:self.typeButton];
    [titleView addSubview:self.titleLabel];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2));
        make.left.and.top.mas_equalTo(0);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 2));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(2);
    }];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 40));
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 30));
        make.center.mas_equalTo(0);
    }];
    [_typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.top.equalTo(_titleLabel);
        make.left.mas_equalTo(10);
        make.right.equalTo(_titleLabel.mas_left);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 30));
        make.left.mas_equalTo(0);
        make.top.equalTo(titleView.mas_bottom);
    }];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_segmentView.mas_bottom);
    }];
   
    [_typeButton addTarget:self action:@selector(titleViewSelect:) forControlEvents:(UIControlEventTouchUpInside)];
    [backButton addTarget:self action:@selector(dissMissView) forControlEvents:(UIControlEventTouchUpInside)];

    titleView.backgroundColor = [UIColor brownColor];
    [self addObserverForWebview];
}

- (void)reloadWebViewWithURLStr:(NSString *)url
{
//    NSString *urlStr = @"https://www.baidu.com";
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",url,[[NSUserDefaults standardUserDefaults] valueForKey:TOKEN]];
    HHCodeLog(@"%@",urlStr);
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}

#pragma mark - http
- (void)callHttpForMapDataWithType:(NSString *)type{
    [PCMBProgressHUD showLoadingImageInView:self.view isResponse:YES];
    __weak DashboardWebViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"type=%@",type];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]
                              success:^(id data) {
                                  [PCMBProgressHUD hideWithView:weakself.view];
                                  weakself.dataArray = [[ChartDataModel alloc] getData:data[0][@"data"]];
                                  [weakself reloadWebViewWithURLStr:[(ChartDataModel *)weakself.dataArray[0] url]];
//                                  [weakself.typeButton setTitle:[(ChartDataModel *)weakself.dataArray[0] name] forState:(UIControlStateNormal)];
                                  
                              }
                              failure:^(NSError *error) {
                                  [PCMBProgressHUD hideWithView:weakself.view];
                              }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
        if (self.webView.estimatedProgress < 1.0) {
            self.delayTime = 1 - self.webView.estimatedProgress;
            return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.progress = 0;
        });
    }
//        else if ([keyPath isEqualToString:@"title"]) {
//            HHCodeLog(@"%@",self.webView.title);
//        } else if ([keyPath isEqualToString:@"contentSize"]) {
//            self.scrollView.contentSize = self.webView.scrollView.contentSize;
//            [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(self.webView.scrollView.contentSize.height);
//            }];
//            HHCodeLog(@"----------%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
//        }
}


#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    HHCodeLog(@"didStartProvisionalNavigation   ====    %@", navigation);
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    HHCodeLog(@"didFinishNavigation   ====    %@", navigation);
    CGSize newSize = self.scrollView.contentSize;
    newSize.height = self.webView.scrollView.contentSize.height + 70;
    self.scrollView.contentSize = newSize;
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.webView.scrollView.contentSize.height);
    }];
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    HHCodeLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
}

#pragma mark - segment delegate
- (void)segmentCustomView:(SegmentCustomStyleManager *)segmentCustomView index:(NSInteger)index{
    self.selectedIndex = index;
    switch (index) {
        case 0:
            [self callHttpForMapDataWithType:@"enterStock"];
            break;
        case 1:
            [self callHttpForMapDataWithType:@"outStock"];
            break;
        case 2:
            [self callHttpForMapDataWithType:@""];
            break;
            
        default:
            break;
    }
}

#pragma mark - action

- (void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)titleViewSelect:(UIButton *)sender{
    NSMutableArray *popoverActionArray = [[NSMutableArray alloc] init];

    for (NSInteger i = 0; i < [self.dataArray count]; i ++) {
        ChartDataModel *item = (ChartDataModel *)self.dataArray[i];
//        PopoverAction *action = [PopoverAction actionWithTitle:item.name handler:^(PopoverAction *action) {
//            [self reloadWebViewWithURLStr:item.url];
//            sender.titleLabel.text = action.title;
//            [sender setTitle:action.title forState:(UIControlStateNormal)];
//        }];
//        [popoverActionArray addObject:action];
    }

    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.showShade = YES;
    [popoverView showToView:sender withActions:popoverActionArray];
}

@end

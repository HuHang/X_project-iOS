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

@interface DashboardWebViewController ()<WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
@property NSInteger selectedIndex;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation DashboardWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self viewLayout];
     [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];

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
    [self.scrollView addSubview:self.webView];
    [titleView addSubview:backButton];
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

    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(titleView.mas_bottom);
    }];
   
    [backButton addTarget:self action:@selector(dissMissView) forControlEvents:(UIControlEventTouchUpInside)];

    titleView.backgroundColor = [UIColor brownColor];
    [self addObserverForWebview];
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


#pragma mark - action

- (void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

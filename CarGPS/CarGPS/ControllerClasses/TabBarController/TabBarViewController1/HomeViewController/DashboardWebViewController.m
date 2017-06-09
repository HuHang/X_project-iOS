//
//  DashboardWebViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/18.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashboardWebViewController.h"
#import <WebKit/WebKit.h>


@interface DashboardWebViewController ()<WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;
//@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation DashboardWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
//        _fpsLabel = [YYFPSLabel new];
//        _fpsLabel.frame = CGRectMake(200, 200, 50, 30);
//        [_fpsLabel sizeToFit];
//        [self.view addSubview:_fpsLabel];

}

-(void)dealloc{
    HHCodeLog(@"dealloc");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
    self.webView.navigationDelegate = nil;
    if ([[[UIDevice currentDevice] systemVersion] intValue ] > 8) {
        NSArray * types = @[WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeDiskCache];  // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}


- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = UIColorFromHEX(0xffb7b7, 1.0);
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}
- (WKWebView *)webView{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
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
    self.navigationItem.title = self.titleStr;
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.webView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2));
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(64);
    }];

    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(66, 0, 0, 0));
    }];
   
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
    [PCMBProgressHUD showLoadingImageInView:self.view isResponse:YES];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [PCMBProgressHUD hideWithView:self.view];
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    HHCodeLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
    [PCMBProgressHUD showLoadingTipsInView:self.view title:@"网页错误" detail:@"请稍后重试" withIsAutoHide:YES];
}






@end

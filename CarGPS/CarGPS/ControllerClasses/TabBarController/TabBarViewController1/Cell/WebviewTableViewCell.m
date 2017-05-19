//
//  WebviewTableViewCell.m
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "WebviewTableViewCell.h"


@implementation WebviewTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout{
    [self.contentView addSubview:self.progressView];
    [self.contentView addSubview:self.webView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 2));
        make.left.and.top.mas_equalTo(0);
    }];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(2, 0, 2, 0));
    }];
    _webView.scrollView.scrollEnabled = NO;
    self.backgroundColor = [UIColor lightGrayColor];
    [self addObserverForWebview];
}

- (void)loadDataForCellWithURl:(NSString *)urlStr{
    HHCodeLog(@"%@", urlStr);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}
-(void)dealloc{
    HHCodeLog(@"dealloc");
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.webView removeObserver:self forKeyPath:@"title"];
//    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (UIProgressView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = ZDRedColor;
        _progressView.trackTintColor = [UIColor clearColor];
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
//    [self.webView addObserver:self forKeyPath:@"title" options:observingOptions context:nil];
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:observingOptions context:nil];
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
//    else if ([keyPath isEqualToString:@"title"]) {
//        HHCodeLog(@"%@",self.webView.title);
//    } else if ([keyPath isEqualToString:@"contentSize"]) {
//        HHCodeLog(@"----------%@", NSStringFromCGSize(self.webView.scrollView.contentSize));
//    }
}


#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    HHCodeLog(@"didStartProvisionalNavigation   ====    %@", navigation);
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    HHCodeLog(@"didFinishNavigation   ====    %@", navigation);
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    HHCodeLog(@"didFailProvisionalNavigation   ====    %@\nerror   ====   %@", navigation, error);
}

@end

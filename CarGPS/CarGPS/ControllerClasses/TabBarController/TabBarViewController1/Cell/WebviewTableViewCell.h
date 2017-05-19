//
//  WebviewTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<WebKit/WebKit.h>

@interface WebviewTableViewCell : UITableViewCell<WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat delayTime;

- (void)loadDataForCellWithURl:(NSString *)urlStr;
@end

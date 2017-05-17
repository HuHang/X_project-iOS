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
    self.webView = [[UIWebView alloc] init];
    [self.contentView addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _webView.scrollView.scrollEnabled = NO;
    
}

- (void)loadDataForCellWithURl:(NSString *)urlStr{
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
}

@end

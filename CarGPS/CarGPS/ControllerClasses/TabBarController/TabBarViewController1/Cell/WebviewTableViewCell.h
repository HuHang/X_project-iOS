//
//  WebviewTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebviewTableViewCell : UITableViewCell
@property (nonatomic,strong)UIWebView *webView;

- (void)loadDataForCellWithURl:(NSString *)urlStr;
@end

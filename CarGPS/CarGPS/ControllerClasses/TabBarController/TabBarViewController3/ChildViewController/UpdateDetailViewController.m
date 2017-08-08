//
//  UpdateDetailViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/7/14.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UpdateDetailViewController.h"

@interface UpdateDetailViewController ()
@property (nonatomic,strong)UITextView *textView;
@end

@implementation UpdateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更新日志";
    [self.view addSubview:self.textView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.textView.text = @"-更新日志：\n 1.修改已知bug； \n 2.优化了网络环境； \n 新增关于app的版本功能介绍。";
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _textView.font = [UIFont fontWithName:@"Arial" size:16.5f];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = false;
    }
    return _textView;
}

@end

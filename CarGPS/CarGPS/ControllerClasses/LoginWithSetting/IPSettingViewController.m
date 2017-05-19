//
//  IPSettingViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "IPSettingViewController.h"

@interface IPSettingViewController ()
@property (nonatomic,strong)UITextField *IPTextField;
@property (nonatomic,strong)UITextField *countTextField;

@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *saveButton;
@end

@implementation IPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromHEX(0xF0FFFF,1.0);
    [self viewLayout];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - view
- (void)viewLayout{
    
    [self initSubView];
    UIView *lineView01 = [self viewWithColor:UIColorFromHEX(0xD9D9D9,1.0)];
    UIView *lineView02 = [self viewWithColor:UIColorFromHEX(0xD9D9D9,1.0)];
    [self.view addSubview:self.IPTextField];
    [self.view addSubview:self.countTextField];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.saveButton];
    [self.view addSubview:lineView01];
    [self.view addSubview:lineView02];
    
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.IPTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.right.mas_equalTo(-28);
        make.top.mas_equalTo(SCREEN_HEIGHT*0.382);
        make.height.mas_equalTo(35);
    }];
    [lineView01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.IPTextField).with.mas_offset(25);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.IPTextField);
        make.top.equalTo(self.IPTextField.mas_bottom);
    }];
    
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(self.IPTextField);
        make.top.equalTo(self.IPTextField.mas_bottom).with.mas_offset(40);
    }];
    [lineView02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(lineView01);
        make.top.equalTo(self.countTextField.mas_bottom);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCREEN_HEIGHT*2/3);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(180, 40));
    }];
    
    
    self.IPTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.countTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.saveButton.layer.cornerRadius = 20;
    self.saveButton.layer.masksToBounds = YES;
    
    [self.cancelButton addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveIP) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initSubView{
    UILabel *IPTextFieldLeft = [UILabel labelWithString:FontAweStr(FAIconHome)
                                      withTextAlignment:(NSTextAlignmentCenter)
                                          withTextColor:ZDRedColor
                                               withFont:FontAweStrFont(20)];
    UILabel *countTextFieldLeft = [UILabel labelWithString:FontAweStr(FAIconKey)
                                         withTextAlignment:(NSTextAlignmentCenter)
                                             withTextColor:ZDRedColor
                                                  withFont:FontAweStrFont(20)];
    
    IPTextFieldLeft.frame = CGRectMake(0, 0, 30, 30);
    countTextFieldLeft.frame = IPTextFieldLeft.frame;
    
    self.IPTextField = [UITextField textFieldWithPlaceholder:@"示例:42.121.111.38"
                                           withTextAlignment:(NSTextAlignmentLeft)
                                               withTextColor:UIColorFromHEX(0x2F2F4F, 1.0)
                                                    withFont:SystemFont(12.f)
                                                withLeftView:IPTextFieldLeft
                                               withRightView:nil];
    self.countTextField = [UITextField textFieldWithPlaceholder:@"示例:80"
                                              withTextAlignment:(NSTextAlignmentLeft)
                                                  withTextColor:UIColorFromHEX(0x2F2F4F, 1.0)
                                                       withFont:SystemFont(12.f)
                                                   withLeftView:countTextFieldLeft
                                                  withRightView:nil];
    
    
    self.cancelButton = [UIButton buttonWithString:FontAweStr(FAIconRemove)
                               withBackgroundColor:[UIColor clearColor]
                                 withTextAlignment:NSTextAlignmentCenter
                                     withTextColor:ZDRedColor
                                          withFont:FontAweStrFont(30.f)];
    
    
    self.saveButton = [UIButton buttonWithString:@"保 存"
                             withBackgroundColor:ZDRedColor
                               withTextAlignment:NSTextAlignmentCenter
                                   withTextColor:[UIColor whiteColor]
                                        withFont:SystemFont(14.f)];
}


#pragma mark - action
- (void)getData{
    self.IPTextField.text = [URLDictionary baseURLStr];
    self.countTextField.text = [URLDictionary basePort];
}
- (void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveIP{
    if ([self.IPTextField.text length] != 0 &&[self.countTextField.text length] != 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.IPTextField.text forKey:BaseURL];
        [[NSUserDefaults standardUserDefaults] setObject:self.countTextField.text forKey:BasePORT];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self dissMissView];
    }
}




#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}
@end

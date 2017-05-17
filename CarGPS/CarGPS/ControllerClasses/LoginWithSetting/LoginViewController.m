//
//  LoginViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "LoginViewController.h"
#import "IPSettingViewController.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"
#import "UIButton+MHExtra.h"
#import "Base64.h"
#import "UserInfoModel.h"
#import "DefaultModel.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *userNameTextField;
@property (nonatomic,strong)UITextField *passWordTextField;
@property (nonatomic,strong)UIButton *loginButton;
@property (nonatomic,strong)UIActivityIndicatorView *loginActivityIndicator;
@property BOOL is_Save;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.is_Save = [[NSUserDefaults standardUserDefaults]boolForKey:SAVE_PWD];
    [self viewLayout];
    [self getData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}




- (void)viewLayout{
    UIImageView *backgroundImage = [[UIImageView alloc]init];
    UIImageView *logoImage = [[UIImageView alloc] init];
    //输入框
    UILabel *usernameLeft = [UILabel labelWithString:FontAweStr(FAIconUser)
                                   withTextAlignment:(NSTextAlignmentCenter)
                                       withTextColor:ZDRedColor
                                            withFont:FontAweStrFont(20)];
    UILabel *passwordLeft = [UILabel labelWithString:FontAweStr(FAIconLock)
                                   withTextAlignment:(NSTextAlignmentCenter)
                                       withTextColor:ZDRedColor
                                            withFont:FontAweStrFont(20)];
    
    usernameLeft.frame = CGRectMake(0, 0, 30, 30);
    passwordLeft.frame = usernameLeft.frame;
    

    self.userNameTextField = [UITextField textFieldWithPlaceholder:@"账号"
                                                 withTextAlignment:(NSTextAlignmentLeft)
                                                     withTextColor:[UIColor blackColor]
                                                          withFont:SystemFont(14.f)
                                                      withLeftView:usernameLeft
                                                     withRightView:nil];
    self.passWordTextField = [UITextField textFieldWithPlaceholder:@"密码"
                                                 withTextAlignment:(NSTextAlignmentLeft)
                                                     withTextColor:[UIColor blackColor]
                                                          withFont:SystemFont(14.f)
                                                      withLeftView:passwordLeft
                                                     withRightView:nil];
    
    
    UIButton *saveButton = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_psdUnselect" withSelectedImage:@"icon_psdSelect"];
    UILabel *autoAddLabel = [UILabel labelWithString:@"记住密码"
                                   withTextAlignment:(NSTextAlignmentLeft)
                                       withTextColor:[UIColor whiteColor]
                                            withFont:SystemFont(12.f)];
    
    self.loginButton = [UIButton buttonWithString:@"登 录"
                              withBackgroundImage:nil
                              withBackgroundColor:ZDRedColor
                                withTextAlignment:NSTextAlignmentCenter
                                    withTextColor:[UIColor whiteColor]
                                         withFont:SystemFont(16.f)];
    UILabel *title = [UILabel labelWithString:@"中都物流"
                             withTextAlignment:NSTextAlignmentCenter
                                 withTextColor:ZDRedColor
                                      withFont:SystemFont(22.f)];
    UILabel *subTitle = [UILabel labelWithString:@"质押车辆智能监控系统"
                               withTextAlignment:NSTextAlignmentCenter
                                   withTextColor:[UIColor whiteColor]
                                        withFont:SystemFont(16.f)];
    
    UIButton *settingButton = [UIButton buttonWithString:@"更多"
                                     withBackgroundImage:nil
                                     withBackgroundColor:[UIColor clearColor]
                                       withTextAlignment:NSTextAlignmentCenter
                                           withTextColor:[UIColor whiteColor]
                                                withFont:SystemFont(10.f)];

    
    [self.view addSubview:backgroundImage];
    [backgroundImage addSubview:logoImage];
    [backgroundImage addSubview:title];
    [backgroundImage addSubview:subTitle];
    [backgroundImage addSubview:self.userNameTextField];
    [backgroundImage addSubview:self.passWordTextField];

    [backgroundImage addSubview:saveButton];
    [backgroundImage addSubview:autoAddLabel];
    [backgroundImage addSubview:self.loginButton];
    [backgroundImage addSubview:settingButton];
    
    
    [backgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(self.view);
    }];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundImage);
        make.top.mas_equalTo(64);
        make.size.mas_equalTo(CGSizeMake(0.33*SCREEN_WIDTH, 0.25*SCREEN_WIDTH));
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logoImage);
        make.top.equalTo(logoImage.mas_bottom).with.mas_offset(16);
        make.size.mas_equalTo(CGSizeMake(100, 36));
    }];
    
    [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(title);
        make.top.equalTo(title.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(174, 34));
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(backgroundImage);
        make.width.mas_equalTo(0.8*SCREEN_WIDTH);
        make.height.mas_equalTo(40);
    }];

    
    
    [self.passWordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(self.userNameTextField);
        make.top.equalTo(self.userNameTextField.mas_bottom).with.mas_offset(20);
    }];

    
    //记住密码
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.equalTo(self.passWordTextField.mas_bottom).with.mas_offset(20);
        make.left.equalTo(self.passWordTextField);
    }];
    [autoAddLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(saveButton);
        make.height.mas_equalTo(20);
        make.left.equalTo(saveButton.mas_right).with.mas_offset(10);
        make.width.mas_equalTo(100);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(self.passWordTextField);
        make.top.equalTo(saveButton.mas_bottom).with.mas_offset(20);
    }];
    
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroundImage);
        make.bottom.equalTo(backgroundImage).with.mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(70, 35));
    }];
    
    
    backgroundImage.image = [UIImage imageNamed:@"loginbackground"];
    backgroundImage.userInteractionEnabled = YES;
    logoImage.image = [UIImage imageNamed:@"ZDlogo"];
    
    self.userNameTextField.layer.cornerRadius = 20;
    self.userNameTextField.layer.masksToBounds = YES;
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.passWordTextField.layer.cornerRadius = 20;
    self.passWordTextField.layer.masksToBounds = YES;
    self.passWordTextField.backgroundColor = [UIColor whiteColor];
    
//    [self.userNameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passWordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.userNameTextField.secureTextEntry = NO;
    self.passWordTextField.secureTextEntry = YES;
    self.loginButton.layer.cornerRadius = 20;
    self.loginButton.layer.masksToBounds = YES;
    
    saveButton.selected = self.is_Save;
    [saveButton addMHCallBackAction:^(UIButton *button) {
        button.selected = !button.selected;
        self.is_Save = button.selected;
    } forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton addTarget:self action:@selector(actionSheetShow:) forControlEvents:UIControlEventTouchUpInside];
    
    self.loginActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loginActivityIndicator.center = CGPointMake(30, 22);
    [self.loginButton addSubview:self.loginActivityIndicator];
    self.loginActivityIndicator.color = [UIColor whiteColor];
    [self.loginActivityIndicator setHidesWhenStopped:YES];
    
}
#pragma mark - getData
- (void)getData{
        self.userNameTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USERLOGINNAME];
        self.passWordTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:PASSWORD];
}


#pragma mark - http
- (void)callHttpForLogin:(NSString *)userName passWord:(NSString *)passWord{
    __weak typeof(self) weakself = self;
    NSString *urlData = [NSString stringWithFormat:@"email=%@&pwd=%@",userName,passWord];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary login_url],urlData]);
    [CallHttpManager postWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary login_url],urlData]
                            parameters:nil
                               success:^(id data) {
                                   if (data) {
                                       DefaultModel *result = [[DefaultModel alloc] getData:data];
                                       if (result.Success) {
                                           [weakself setUserInfomation:[[UserInfoModel alloc] getData:result.UserInfo] withName:userName withPassWord:passWord];
                                           [weakself successForLogin];
                                       }else{
                                           [PCMBProgressHUD showLoadingTipsInView:weakself.view title:result.Content detail:nil withIsAutoHide:YES];
                                       }
                                    }
                                   [weakself.loginActivityIndicator stopAnimating];
                                   self.loginButton.enabled = YES;
                               }
                               failure:^(NSError *error) {
                                   self.loginButton.enabled = YES;
                                   [weakself.loginActivityIndicator stopAnimating];
                                   [weakself.loginButton setTitle:@"登 录" forState:UIControlStateNormal];
                               }];
}


#pragma mark - action
- (void)actionSheetShow:(UIButton *)sender{
    IPSettingViewController *ipSetVC = [[IPSettingViewController alloc] init];
    [self presentViewController:ipSetVC animated:YES completion:nil];
}

- (void)login:(UIButton *)sender{
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passWordTextField.text;
    if (username.length > 0 || password.length > 0) {
        [self.loginActivityIndicator startAnimating];
        self.loginButton.enabled = NO;
        [self callHttpForLogin:username passWord:password];
    }else{
        [PCMBProgressHUD showLoadingTipsInView:self.view title:@"温馨提示" detail:@"请填写用户名密码" withIsAutoHide:YES];
    }
    
    
    
//    [self reSetRootView];
    
}

- (void)setUserInfomation:(UserInfoModel *)infoDic withName:(NSString *)userName withPassWord:(NSString *)passWord{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *kerWithValue = [NSString stringWithFormat:@"%@:%@",userName,passWord];
    NSString *basicAuth = [NSString stringWithFormat:@"Basic %@",[kerWithValue base64EncodedString]];
    [user setObject:basicAuth forKey:Basic_Auth];
    
    
    [user setValue:[NSString stringWithFormat:@"%u",infoDic.ID] forKey:USERID];
    [user setValue:infoDic.name forKey:USERNAME];
    [user setValue:infoDic.loginId forKey:USERLOGINNAME];
    [user setValue:infoDic.phone forKey:USERPHONE];
    [user setValue:infoDic.email forKey:USEREMAIL];
    [user setValue:[NSString stringWithFormat:@"%u",infoDic.roleType ]forKey:USERROLETYPE];
    [user setValue:infoDic.roleTypeDisplay forKey:USERROLETYPEDISPLAY];
    [user setValue:infoDic.shopName forKey:USERSHOP];
    [user setValue:[NSString stringWithFormat:@"shopids[]=%u",infoDic.shopId]forKey:USERSHOPID];
    [user setValue:infoDic.bankName forKey:USERBANCK];
    [user setValue:[NSString stringWithFormat:@"%u",infoDic.bankId]forKey:USERBANCKID];
    [user setValue:infoDic.token forKey:TOKEN];
    [user synchronize];

}
- (void)successForLogin{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setBool:self.is_Save forKey:SAVE_PWD];
    if (self.is_Save) {
        [user setObject:self.passWordTextField.text forKey:PASSWORD];
    }else{
        [user setObject:@"" forKey:PASSWORD];
    }
    [user synchronize];
    [self.loginActivityIndicator stopAnimating];
    [self performSelector:@selector(reSetRootView) withObject:nil afterDelay:0.3];
   
}
- (void)reSetRootView{
    TabBarViewController *mainView = [[TabBarViewController alloc]init];
//    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:mainView];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    typedef void (^Animation)(void);
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        app.window.rootViewController = mainView;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:app.window
     
                      duration:0.9f
     
                       options:UIViewAnimationOptionTransitionFlipFromRight
     
                    animations:animation
     
                    completion:nil];
}


#pragma mark 懒加载
- (UIView *)viewWithColor:(UIColor *)viewColor {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = viewColor;
    return view;
}
@end

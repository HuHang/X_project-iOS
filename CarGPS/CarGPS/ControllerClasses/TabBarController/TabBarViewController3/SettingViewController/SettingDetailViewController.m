//
//  SettingDetailViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "SettingDetailViewController.h"
#import "SZKCleanCache.h"
#import "CenterLabelTableViewCell.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface SettingDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation SettingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CenterLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CenterLabelTableViewCell class])];
        if (cell == nil) {
            cell = [[CenterLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CenterLabelTableViewCell class])];
        }
        cell.centerLabel.text = @"注销账号";
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = @"清理缓存";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fM",[SZKCleanCache folderSizeAtPath]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    __weak SettingDetailViewController *weakself = self;
                    [SZKCleanCache cleanCache:^{
                        [weakself.tableView reloadData];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [self reSetRootView];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

#pragma mark - action
- (void)reSetRootView{
    [self logOFF];
    LoginViewController *mainView = [[LoginViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:mainView];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    typedef void (^Animation)(void);
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        app.window.rootViewController = navc;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:app.window
     
                      duration:0.5f
     
                       options:UIViewAnimationOptionTransitionFlipFromLeft
     
                    animations:animation
     
                    completion:nil];
}
- (void)logOFF{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    [user removePersistentDomainForName:bundle];
    [user setBool:YES forKey:FIRSTLUNCH];
    [user synchronize];
}
@end

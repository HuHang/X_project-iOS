//
//  SettingViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/4/27.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#define USERS [NSUserDefaults standardUserDefaults]
#import "SettingViewController.h"
#import "SettingDetailViewController.h"
#import "UserInfomationViewController.h"


@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.label.text = [NSString stringWithFormat:@"%.2fm",[SZKCleanCache folderSizeAtPath]];

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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"icon_admin"];
            cell.textLabel.text = [USERS valueForKey:USERLOGINNAME];
            cell.detailTextLabel.text = [USERS valueForKey:USERROLETYPEDISPLAY];
            return cell;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
                    }
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.imageView.image = [UIImage imageNamed:@"icon_appVersion"];
                    cell.textLabel.text = @"版本信息";
                    cell.detailTextLabel.text = app_Version;
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.imageView.image = [UIImage imageNamed:@"icon_appSetup"];
            cell.textLabel.text = @"设置";
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            UserInfomationViewController *view = [[UserInfomationViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 1:
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
        case 2:
        {
            SettingDetailViewController *view = [[SettingDetailViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80.f;
    }else{
        return 40.f;
    }
    
}

@end

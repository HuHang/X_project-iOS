//
//  AboutAPPViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/7/14.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "AboutAPPViewController.h"
#import "BasicFunctionTableViewController.h"
#import "UpdateDetailViewController.h"

@interface AboutAPPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation AboutAPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - createView
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self tableViewHeaderView];
    }
    return _tableView;
}


- (UIView *)tableViewHeaderView{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120.f)];
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ZDlogo"]];
    UILabel *versionLabel = [UILabel labelWithString:[NSString stringWithFormat:@"中都智能 v%@",app_Version] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(18.f)];
    
    [contentView addSubview:logoImage];
    [contentView addSubview:versionLabel];
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.top.equalTo(logoImage.mas_bottom).with.mas_offset(20);
    }];
    return contentView;
}

#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"版本更新";
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"基本功能";
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
    switch (indexPath.row) {
        case 0:
        {
            
            UpdateDetailViewController *view = [[UpdateDetailViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 1:
        {
            BasicFunctionTableViewController *view = [[BasicFunctionTableViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
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

@end

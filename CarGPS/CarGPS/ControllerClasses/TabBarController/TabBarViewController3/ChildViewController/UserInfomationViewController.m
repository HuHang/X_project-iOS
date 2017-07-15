//
//  UserInfomationViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//
#define USERS [NSUserDefaults standardUserDefaults]

#import "UserInfomationViewController.h"

@interface UserInfomationViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation UserInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";

    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@[@"用户名",@"姓名",@"角色"],@[@"电话",@"邮箱"],@[@"经销商",@"银行"]];
    }
    return _titleArray;
}
- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = @[@[[USERS valueForKey:USERNAME],
                         [USERS valueForKey:USERLOGINNAME],
                         [USERS valueForKey:USERROLETYPEDISPLAY]],@[[USERS valueForKey:USERPHONE],
                                                         [USERS valueForKey:USEREMAIL]],@[[USERS valueForKey:USERSHOP],
                                                                                         [USERS valueForKey:USERBANCK]]];
    }
    return _dataArray;
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
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}
@end

//
//  BasicFunctionTableViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/7/14.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "BasicFunctionTableViewController.h"
#import "FunctionDetailTableViewCell.h"

@interface BasicFunctionTableViewController ()
@property (nonatomic,strong)NSArray *sectionArray;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *imageArray;

@end

@implementation BasicFunctionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"功能概览";
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@[@"您可以在监控界面综览车辆",@"也可以在车辆界面查看某辆车"],@[@"在设备界面您可以管理所有设备"],@[@"通过绑定&解绑，您可以维护设备与车辆"],@[@"在这里您可以及时处理已关注的报警项，当然也可以随时(取消)订阅它们"],@[@"Dashboard方便您查看各类报表详情"]];
    }
    return _titleArray;
}
- (NSArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = @[@[@"des_monitor",@"des_car"],@[@"des_device"],@[@"des_bind"],@[@"des_msg"],@[@"des_dashboard"]];
    }
    return _imageArray;
}

- (NSArray *)sectionArray{
    if (_sectionArray == nil) {
        _sectionArray = @[@"一. 监控车辆",@"二. 管理设备",@"三. 维护",@"四. 消息通知",@"五. Dashboard"];
    }
    return _sectionArray;
}

#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FunctionDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [[FunctionDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([FunctionDetailTableViewCell class])];
    }
    [cell loadDataForCellWithfunctionLabel:self.titleArray[indexPath.section][indexPath.row] FunctionImageName:self.imageArray[indexPath.section][indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 440.f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionArray[section];
}

@end

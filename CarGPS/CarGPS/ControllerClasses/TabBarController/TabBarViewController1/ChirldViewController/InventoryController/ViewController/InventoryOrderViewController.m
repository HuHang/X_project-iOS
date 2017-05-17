//
//  InventoryOrderViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/16.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "InventoryOrderViewController.h"
#import "InventoryOrderTableViewCell.h"
#import "InventoryDetailViewController.h"

@interface InventoryOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation InventoryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"盘点单";
    [self viewlayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - view
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)viewlayout{
    [self.view addSubview:self.tableView];
}
#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InventoryOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([InventoryOrderTableViewCell class])];
    if (cell == nil) {
        cell = [[InventoryOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([InventoryOrderTableViewCell class])];
    }
    [cell loadDataForCell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    InventoryDetailViewController *detailView = [[InventoryDetailViewController alloc] init];
    [self.navigationController pushViewController:detailView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

@end

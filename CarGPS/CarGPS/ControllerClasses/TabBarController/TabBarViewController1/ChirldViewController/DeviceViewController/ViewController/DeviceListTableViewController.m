//
//  DeviceListTableViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DeviceListTableViewController.h"
#import "DeviceTableViewCell.h"
#import "UnusedDeviceTableViewCell.h"
#import "DeviceModel.h"
#import "GroupInfomationModel.h"
#import "PopoverView.h"
#import "SignalDeviceOrCarMapViewController.h"



@interface DeviceListTableViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    BOOL isbool;
}
@property (strong, nonatomic) NSArray *searchResultArray;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSArray *groupInfoArray;
@property (nonatomic,strong)UIButton *shopSelectButton;
@property (nonatomic,strong)UIButton *titleButton;
@property (nonatomic,strong)NSString *selectesShopIDStr;
@property NSInteger selectedIndex;
@property NSInteger pageIndex;
@property (strong, nonatomic)UISearchBar *searchBar;
@end

@implementation DeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectedIndex = 1;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectesShopIDStr = [[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID];
    [self createNavigationView];
    [self callHttpForDeviceCount];
    
    __weak DeviceListTableViewController *weakself = self;
    self.tableView.mj_header = [HLNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex = 0;
        [weakself setMJRefreshHeader];
        [weakself.tableView.mj_footer resetNoMoreData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself setMJRefreshFooter];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setMJRefreshHeader{
    __weak DeviceListTableViewController *weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself callHttpWithType];
        [weakself.tableView.mj_header endRefreshing];
    });
}
- (void)setMJRefreshFooter{
    __weak DeviceListTableViewController *weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself callHttpWithType];
        [weakself.tableView.mj_footer endRefreshing];
    });
}

- (void)callHttpWithType{
    switch (self.selectedIndex) {
        case 1:
            [self callHttpForBindData:@"true"];
            break;
        case 2:
            [self callHttpForBindData:@"false"];
            break;
        case 3:
            [self callHttpForBindData:@""];
            break;
        default:
            break;
    }
}

- (NSArray *)groupInfoArray{
    if (_groupInfoArray == nil) {
        _groupInfoArray = [NSArray new];
    }
    return _groupInfoArray;
}

- (NSArray *)searchResultArray{
    if (_searchResultArray == nil) {
        _searchResultArray = [NSArray new];
    }
    return _searchResultArray;
}
#pragma mark - view
- (UISearchBar * )searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0 , SCREEN_WIDTH/2, 40);
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;

    }
    return _searchBar;
}

- (void)createNavigationView{
    self.titleButton = [UIButton buttonWithString:@"使用中" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(14.f)];
    self.titleButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 40);
    self.navigationItem.titleView = self.titleButton;
    [self.titleButton addTarget:self action:@selector(titleViewSelect:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - http
- (void)callHttpForDeviceCount{
    __weak DeviceListTableViewController *weakself= self;
    NSDictionary *params = @{@"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray]};
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary groupDeviceCount_url],params]);
    [CallHttpManager postWithUrlString:[URLDictionary groupDeviceCount_url]
                            parameters:params
                              success:^(id data) {
        if ([data count] == 0) {
            [PCMBProgressHUD showLoadingTipsInView:weakself.view title:nil detail:@"获取统计信息失败" withIsAutoHide:YES];
        }else{
            weakself.groupInfoArray = [[GroupInfomationModel alloc]getData:data];
            [self.titleButton setTitle:[NSString stringWithFormat:@"%@ %u ▾",[[weakself.groupInfoArray firstObject] name],[[weakself.groupInfoArray firstObject] Count]] forState:(UIControlStateNormal)];
        }
        
    }
                              failure:^(NSError *error) {
        
    }];
    
}

- (void)callHttpForBindData:(NSString *)isUsedStr{
    __weak DeviceListTableViewController *weakself = self;
    [PCMBProgressHUD showLoadingImageInView:self.view.window isResponse:NO];
    NSDictionary *params = @{@"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray],
                             @"pageIndex":[NSNumber numberWithInteger:self.pageIndex],
                             @"isBind":isUsedStr
                             };
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allDevice_url],params]);
    [CallHttpManager postWithUrlString:[URLDictionary allDevice_url]
                            parameters:params
                              success:^(id data) {
                                  if ([data count] == 0) {
                                      [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                                  }else{
                                      if (weakself.pageIndex == 0) {
                                          [weakself.dataArray removeAllObjects];
                                      }
                                      weakself.pageIndex ++;
                                      [weakself.dataArray addObjectsFromArray:[[DeviceModel alloc] getData:data]];
                                      [weakself.tableView reloadData];
                                  }
                                  [PCMBProgressHUD hideWithView:weakself.view.window];


                              }
                              failure:^(NSError *error) {
                                  [PCMBProgressHUD hideWithView:weakself.view.window];

                                  
                              }];
}


- (void)callHttpForSearch:(NSString *)searchString{
    __weak DeviceListTableViewController *weakself= self;
    NSDictionary *params = @{@"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray],
                             @"pageIndex":[NSNumber numberWithInteger:0],
                             @"isBind":@"",
                             @"searchStr":searchString
                             };
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary searchDevice_url],params]);
    [CallHttpManager postWithUrlString:[URLDictionary searchDevice_url]
                            parameters:params
                               success:^(id data) {
        weakself.searchResultArray = [[DeviceModel alloc] getData:data];
        [weakself.tableView reloadData];
        //            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];

    }
                               failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isbool) {
        return [self.searchResultArray count];
    }
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DeviceTableViewCell class])];
    if (cell == nil) {
        cell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DeviceTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    DeviceModel *item = isbool ? (DeviceModel *)self.searchResultArray[indexPath.row] : (DeviceModel *)self.dataArray[indexPath.row];

    [cell loadDataWithIMEI:item.imei
                    number:item.vin
                      time:[NSString formatDateTimeForCN:item.signalTime]
                signalType:item.singleType
              signalStatus:item.signalLevelDisplay
          workStateDisplay:item.workStateDisplay
                    status:item.fenceStateDisplay
                     elect:item.batteryPercent
                      shop:item.currentShopName
                      bank:item.currentShopTypeDisplay
            withBatteryInt:item.battery
            withFenceState:item.fenceState
             withWorkState:item.workState
           withSignalLevel:item.signalLevel
              isBindedMark:item.vin];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceModel *item = isbool ? (DeviceModel *)self.searchResultArray[indexPath.row] : (DeviceModel *)self.dataArray[indexPath.row];
    SignalDeviceOrCarMapViewController *mapView = [[SignalDeviceOrCarMapViewController alloc] init];
    mapView.deviceID = item.ID;
    mapView.is_Car = NO;
    [self presentViewController:mapView animated:YES completion:nil];


}

#pragma mark - UISearchBarDelegate

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    if(text.length == 0)
    {
        isbool = NO;
        self.searchResultArray = @[];
        [self.tableView reloadData];
    }
    else
    {
        isbool = YES;
        
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    HHCodeLog(@"123");
    [self callHttpForSearch:self.searchBar.text];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    isbool= NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}


#pragma mark - action

- (void)titleViewSelect:(UIButton *)sender{
    if (self.groupInfoArray.count == 0) {
        return;
    }
    NSMutableArray *actionArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.groupInfoArray.count; i ++) {
        PopoverAction *action = [PopoverAction actionWithTitle:[NSString stringWithFormat:@"%@ %u",[self.groupInfoArray[i] name],[self.groupInfoArray[i] Count]] handler:^(PopoverAction *action) {
            self.selectedIndex= i + 1;
            [self.titleButton setTitle:[NSString stringWithFormat:@"%@ %u ▾",[self.groupInfoArray[i] name],[self.groupInfoArray[i] Count]] forState:(UIControlStateNormal)];
            [self.tableView.mj_header beginRefreshing];
        }];
        [actionArray addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDefault;
    popoverView.showShade = YES;
    [popoverView showToView:sender withActions:actionArray];
}





#pragma mark - nodata
#pragma mark - DZNEmptyDataSetDelegate Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"icon_noData"];
}


// 标题文本，富文本样式
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无设备信息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


// 空白页的背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

// 图片与标题文本,以及标题文本和详细描述之间的垂直距离,默认是11pts
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 11;
}

// 是否 显示空白页,默认是YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
}


// 是否 允许上下滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

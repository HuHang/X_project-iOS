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
#import "DeviceMapViewController.h"
#import "PopoverView.h"
#import "SearchDeviceViewController.h"


@interface DeviceListTableViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIButton *shopSelectButton;
@property (nonatomic,strong)UIButton *titleButton;
@property (nonatomic,strong)NSString *selectesShopIDStr;
@property NSInteger selectedIndex;
@property NSInteger pageIndex;

@property (nonatomic, strong) SearchDeviceViewController *searchVC;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation DeviceListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar lt_setTranslationY:(0)];

    self.dataArray = [[NSMutableArray alloc] init];
    self.selectedIndex = 1;
    self.pageIndex = 0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectesShopIDStr = [[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID];
    [self createNavigationView];
    [self initMySearchBar];
    self.tableView.mj_header = [HLNormalHeader headerWithRefreshingBlock:^{
        [self setMJRefreshHeader];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (self.selectedIndex) {
                case 1:
                    [self callHttpForMoreCarData:@"true"];
                    break;
                case 2:
                    [self callHttpForMoreCarData:@"false"];
                    break;
                case 3:
                    [self callHttpForMoreCarData:@""];
                    break;
                    
                default:
                    break;
            }
        });
        [self.tableView.mj_footer endRefreshing];
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setTranslationY:(0)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > 0) {
//        if (offsetY >= 44) {
//            [self setNavigationBarTransformProgress:1];
//        } else {
//            [self setNavigationBarTransformProgress:(offsetY / 44)];
//        }
//    } else {
//        [self setNavigationBarTransformProgress:0];
//        //        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
//    }
//}
- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
}

- (void)setMJRefreshHeader{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        [self.tableView.mj_header endRefreshing];
    });
}

#pragma mark - view
- (void) initMySearchBar
{
    // 搜索页
    _searchVC = [[SearchDeviceViewController alloc] init];
    //遵守代理，用于后面传值
    self.delegate = _searchVC;
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchVC];
    //设置后可以看到实时输入内容,可以在结果页的代理里面设置输入长度
    [_searchController setSearchResultsUpdater: _searchVC];
    [_searchController.searchBar setPlaceholder:@"搜索"];
    [_searchController.searchBar setBarTintColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    //设置搜索logo
    [_searchController.searchBar setImage:[UIImage imageNamed:@"last.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchController.searchBar sizeToFit];
    [_searchController.searchBar setDelegate:self];
    [_searchController.searchBar.layer setBorderWidth:0.5f];
    [_searchController.searchBar.layer setBorderColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor];
    [self.tableView setTableHeaderView:_searchController.searchBar];
    
    _searchVC.searchVC = _searchController;
    __weak UISearchController *searchVC = _searchController;
    
    _searchVC.backBlock = ^{
        [searchVC dismissViewControllerAnimated:YES completion:nil];
        searchVC.searchBar.text = @"";
    };
}

- (void)createNavigationView{
    self.titleButton = [UIButton buttonWithString:@"使用中 ▾" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(14.f)];
    self.titleButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 40);
    self.navigationItem.titleView = self.titleButton;
    [self.titleButton addTarget:self action:@selector(titleViewSelect:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - http
- (void)callHttpForBindData:(NSString *)isUsedStr{
    __weak DeviceListTableViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&pageIndex=%d&isBind=%@",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],0,isUsedStr];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allDevice_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary allDevice_url],dataStr]
                              success:^(id data) {
                                  [weakself.dataArray removeAllObjects];
                                  weakself.dataArray = [NSMutableArray arrayWithArray:[[DeviceModel alloc] getData:data]];
                                  [weakself.tableView reloadData];
                                  weakself.pageIndex = 1;
                                  [weakself.tableView.mj_footer resetNoMoreData];


                              }
                              failure:^(NSError *error) {
                                  
                              }];
}

- (void)callHttpForMoreCarData:(NSString *)isBindStr{
    __weak DeviceListTableViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&pageIndex=%ld&isBind=%@",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],(long)self.pageIndex,isBindStr];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allDevice_url],dataStr]);
    
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary allDevice_url],dataStr]
                              success:^(id data) {
                                  if ([data count] == 0) {
                                      [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                                  }else{
                                      [weakself.dataArray addObjectsFromArray:[[DeviceModel alloc] getData:data]];
                                      [weakself.tableView reloadData];
                                      weakself.pageIndex ++;
                                  }
                                  
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HHCodeLog(@"[self.dataArray count] :%lu",(unsigned long)[self.dataArray count]);
    return [self.dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DeviceTableViewCell class])];
    if (cell == nil) {
        cell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DeviceTableViewCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeviceModel *item = (DeviceModel *)self.dataArray[indexPath.row];
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
    if (self.selectedIndex == 1) {
        DeviceMapViewController *mapView = [[DeviceMapViewController alloc] init];
        mapView.deviceID = [(DeviceModel *)self.dataArray[indexPath.row] ID];
        [self.navigationController pushViewController:mapView animated:YES];
    }else{
        [PCMBProgressHUD showLoadingTipsInView:self.view title:@"提示" detail:@"请切换至使用中设备列表查看" withIsAutoHide:YES];
    }



}

#pragma mark - UISearchBarDelegate

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tabBarController.tabBar setHidden:YES];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //这里也可以不做取消操作，而是该用确认搜索的操作，使用.h中的代理把值传到搜索结果那里进行网络请求
    [self.tabBarController.tabBar setHidden:NO];
    NSLog(@"---------------Cancel");
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"---------------%@",searchBar.text);
    
    if ([self.delegate respondsToSelector:@selector(searchMyInput:)]) {
        [self.delegate searchMyInput:searchBar.text];
    }
}


#pragma mark - action

- (void)titleViewSelect:(UIButton *)sender{
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"使用中" handler:^(PopoverAction *action) {
        self.selectedIndex= 1;
        [self.titleButton setTitle:@"使用中 ▾" forState:(UIControlStateNormal)];
        [self.tableView.mj_header beginRefreshing];
        
    }];
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"闲置" handler:^(PopoverAction *action) {
        self.selectedIndex= 2;
        [self.titleButton setTitle:@"闲置 ▾" forState:(UIControlStateNormal)];
        [self.tableView.mj_header beginRefreshing];

        
    }];
    PopoverAction *action3 = [PopoverAction actionWithTitle:@"全部" handler:^(PopoverAction *action) {
        self.selectedIndex= 3;
        [self.titleButton setTitle:@"全部 ▾" forState:(UIControlStateNormal)];
        [self.tableView.mj_header beginRefreshing];

        
    }];

    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.showShade = YES;
    [popoverView showToView:sender withActions:@[action1, action2,action3]];
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

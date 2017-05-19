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
#import "CarMapViewController.h"
#import "PopoverView.h"


@interface DeviceListTableViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    BOOL isbool;
}
@property (strong, nonatomic) NSArray *searchResultArray;
@property (nonatomic,strong)NSMutableArray *dataArray;
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
    self.pageIndex = 0;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectesShopIDStr = [[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID];
    [self createNavigationView];
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
    }
    return _searchBar;
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

- (void)callHttpForSearch:(NSString *)searchString{
    __weak DeviceListTableViewController *weakself= self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&searchStr=%@&isBind=&pageIndex=%d",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],searchString,0];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary searchDevice_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary searchDevice_url],dataStr] success:^(id data) {
        weakself.searchResultArray = [[DeviceModel alloc] getData:data];
        [weakself.tableView reloadData];
        //            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];

    } failure:^(NSError *error) {
        
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
    if ([item.vin isEqualToString:@""]) {
        [PCMBProgressHUD showLoadingTipsInView:self.view title:@"提示" detail:@"设备未使用，暂无定位信息" withIsAutoHide:YES];
    }else{
        CarMapViewController *mapView = [[CarMapViewController alloc] init];
        mapView.deviceID = item.ID;
        [self presentViewController:mapView animated:YES completion:nil];
    }


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

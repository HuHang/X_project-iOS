//
//  CarListTableViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CarListTableViewController.h"
#import "CarTableViewCell.h"
#import "UnBindTableViewCell.h"
#import "CarModel.h"
#import "GroupInfomationModel.h"
#import "SignalDeviceOrCarMapViewController.h"
#import "PopoverView.h"
#import "UINavigationBar+Awesome.h"

@interface CarListTableViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    BOOL isbool;
}
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSArray *groupInfoArray;
@property (nonatomic,strong)UIButton *titleButton;
@property NSInteger selectedIndex;
@property NSInteger pageIndex;
@property (strong, nonatomic)UISearchBar *searchBar;
@end

@implementation CarListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 1;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self createNavigationView];
    [self callHttpForCarCount];
    __weak CarListTableViewController *weakself = self;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
#pragma mark - view
- (NSMutableArray *)searchResultArray{
    if (_searchResultArray == nil) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    return _searchResultArray;
}
- (NSArray *)groupInfoArray{
    if (_groupInfoArray == nil) {
        _groupInfoArray = [NSArray new];
    }
    return _groupInfoArray;
}

- (void)createNavigationView{
    self.titleButton = [UIButton buttonWithString:@"已绑定" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(14.f)];
    self.titleButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, 40);
    self.navigationItem.titleView = self.titleButton;
    [self.titleButton addTarget:self action:@selector(titleViewSelect:) forControlEvents:(UIControlEventTouchUpInside)];
}

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


- (void)setMJRefreshHeader{
    __weak CarListTableViewController *weakself = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself callHttpWithType];
        [weakself.tableView.mj_header endRefreshing];
    });
}

- (void)setMJRefreshFooter{
    __weak CarListTableViewController *weakself = self;

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself callHttpWithType];
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

- (void)callHttpWithType{
    switch (self.selectedIndex) {
        case 1:
            [self callHttpForCarData:@"true"];
            break;
        case 2:
            [self callHttpForCarData:@"false"];
            break;
        case 3:
            [self callHttpForCarData:@""];
            break;
            
        default:
            break;
    }

}

- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
}


#pragma mark - http
- (void)callHttpForCarCount{
    __weak CarListTableViewController *weakself= self;
    NSDictionary *params = @{@"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray]};
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary groupCarsCount_url],params]);
    [CallHttpManager postWithUrlString:[URLDictionary groupCarsCount_url]
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

- (void)callHttpForCarData:(NSString *)isBindStr{
    __weak CarListTableViewController *weakself = self;
    [PCMBProgressHUD showLoadingImageInView:self.view.window isResponse:NO];

    NSDictionary *params = @{@"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray],
                             @"pageIndex":[NSNumber numberWithInteger:self.pageIndex],
                             @"isBind":isBindStr
                             };
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allCar_url],params]);
    
    [CallHttpManager postWithUrlString:[URLDictionary allCar_url]
                            parameters:params
                              success:^(id data) {
                                  if ([data count] == 0) {
                                      [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                                  }else{
                                      if (weakself.pageIndex == 0) {
                                          [weakself.dataArray removeAllObjects];
                                      }
                                      weakself.pageIndex ++;
                                      [weakself.dataArray addObjectsFromArray:[[CarModel alloc] getData:data]];
                                      [weakself.tableView reloadData];
                                  }
                                  [PCMBProgressHUD hideWithView:weakself.view.window];
                              }
                              failure:^(NSError *error) {
                                  [PCMBProgressHUD hideWithView:weakself.view.window];

                              }];
}


- (void)callHttpForSearch:(NSString *)searchString{
    __weak CarListTableViewController *weakself= self;

    NSDictionary *params = @{@"searchStr":searchString,
                             @"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray],
                             @"pageIndex":@0,
                             @"isBind":@""
                             };
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary searchCar_url],params]);
    [CallHttpManager postWithUrlString:[URLDictionary searchCar_url]
                            parameters:params
                              success:^(id data) {
        [weakself.searchResultArray addObjectsFromArray:[[CarModel alloc] getData:data]];
        [weakself.tableView reloadData];
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
    
    CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CarTableViewCell class])];
    if (cell == nil) {
        cell = [[CarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CarTableViewCell class])];
    }
    CarModel *item = isbool ? (CarModel *)self.searchResultArray[indexPath.row] : (CarModel *)self.dataArray[indexPath.row];
    [cell loadDataWithVin:item.vin
                 shopType:item.currentShopTypeDisplay
                 shopName:item.carCurrentShopName
                 bankName:item.bankName
                    brand:item.brand
                  carType:item.carType
                 carColor:item.carColor
                     time:[NSString formatDateTimeForCN:item.signalTime]
                   status:item.fenceStateDisplay
               withStatus:item.fenceState
               isUsedMark:item.imei];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarModel *item = isbool ? (CarModel *)self.searchResultArray[indexPath.row] : (CarModel *)self.dataArray[indexPath.row];
    if (item.deviceId == 0) {
        [PCMBProgressHUD showLoadingTipsInView:self.view.window title:@"提示" detail:@"车辆未绑定，暂无定位信息" withIsAutoHide:YES];
    }else{
        SignalDeviceOrCarMapViewController *mapView = [[SignalDeviceOrCarMapViewController alloc] init];
        mapView.deviceID = item.deviceId;
        mapView.vinNumber = item.vin;
        mapView.is_Car = YES;
        [self presentViewController:mapView animated:YES completion:nil];
    }
    
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    if(text.length == 0)
    {
        isbool = NO;
        [self.searchResultArray removeAllObjects];
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
    NSString *text = @"暂无车辆信息";
    
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

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
#import "CarMapViewController.h"
#import "PopoverView.h"
#import "UINavigationBar+Awesome.h"

@interface CarListTableViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UIScrollViewDelegate,UISearchBarDelegate,UISearchControllerDelegate>
{
    BOOL isbool;
}
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIButton *titleButton;
@property NSInteger selectedIndex;
@property NSInteger pageIndex;
@property (strong, nonatomic)UISearchBar *searchBar;
@end

@implementation CarListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 1;
    self.pageIndex = 0;
    self.dataArray = [[NSMutableArray alloc] init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self createNavigationView];
    __weak CarListTableViewController *weakself = self;
    self.tableView.mj_header = [HLNormalHeader headerWithRefreshingBlock:^{
        [weakself setMJRefreshHeader];
    }];
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.mj_header beginRefreshing];
    [self setMJRefreshFooter];

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

- (void)createNavigationView{
    self.titleButton = [UIButton buttonWithString:@"绑定车辆 ▾" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(14.f)];
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
    }
    return _searchBar;
}


- (void)setMJRefreshHeader{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)setMJRefreshFooter{
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
//    }
//}
- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
}


#pragma mark - http
- (void)callHttpForCarData:(NSString *)isBindStr{
    __weak CarListTableViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&pageIndex=%d&isBind=%@",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],0,isBindStr];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allCar_url],dataStr]);
    
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary allCar_url],dataStr]
                              success:^(id data) {
                                  [weakself.dataArray removeAllObjects];
                                  weakself.dataArray = [NSMutableArray arrayWithArray:[[CarModel alloc] getData:data]];
                                  [weakself.tableView reloadData];
                                  weakself.pageIndex = 1;
                                  [weakself.tableView.mj_footer resetNoMoreData];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}

- (void)callHttpForMoreCarData:(NSString *)isBindStr{
    __weak CarListTableViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&pageIndex=%ld&isBind=%@",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],(long)self.pageIndex,isBindStr];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allCar_url],dataStr]);
    
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary allCar_url],dataStr]
                              success:^(id data) {
                                  if ([data count] == 0) {
                                      [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
                                  }else{
                                      [weakself.dataArray addObjectsFromArray:[[CarModel alloc] getData:data]];
                                      [weakself.tableView reloadData];
                                      weakself.pageIndex ++;
                                  }
                                  
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}

- (void)callHttpForSearch:(NSString *)searchString{
    __weak CarListTableViewController *weakself= self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&searchStr=%@&isBind=&pageIndex=%d",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],searchString,0];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary searchCar_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary searchCar_url],dataStr] success:^(id data) {
        [weakself.searchResultArray addObjectsFromArray:[[CarModel alloc] getData:data]];
        [weakself.tableView reloadData];
//        weakself.pageIndex ++;
//        if ([data count] < 5) {
//            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
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
        CarMapViewController *mapView = [[CarMapViewController alloc] init];
        mapView.deviceID = item.deviceId;
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
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"绑定车辆" handler:^(PopoverAction *action) {
        self.selectedIndex= 1;
        [self.titleButton setTitle:@"绑定车辆 ▾" forState:(UIControlStateNormal)];
        [self.tableView.mj_header beginRefreshing];

        
    }];
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"未绑车辆" handler:^(PopoverAction *action) {
        self.selectedIndex= 2;
        [self.titleButton setTitle:@"未绑车辆 ▾" forState:(UIControlStateNormal)];
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

//
//  SearchCarViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/12.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "SearchCarViewController.h"
#import "CarTableViewCell.h"
#import "CarModel.h"
@interface SearchCarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *navigationView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property NSInteger pageIndex;
@property (nonatomic,strong)NSString *searchString;
@end

@implementation SearchCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)setMJRefreshFooter{
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self callHttpForSearch];
        });
        [self.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - view

- (UIView *)navigationView{
    if (_navigationView == nil) {
        _navigationView = [[UIView alloc] init];
        _navigationView.backgroundColor = ZDRedColor;
    }
    return _navigationView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)initViewLayout{
    UILabel *titleLabel = [UILabel labelWithString:@"搜索车辆" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(16.f)];
    UIButton *backbtn = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_backWhite" withSelectedImage:nil];
    
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.tableView];
    [self.navigationView addSubview:titleLabel];
    [self.navigationView addSubview:backbtn];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    [backbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 30));
        make.centerY.equalTo(backbtn);
        make.centerX.mas_equalTo(0);
    }];
    [self setMJRefreshFooter];
    
    backbtn.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    backbtn.contentMode = UIViewContentModeScaleAspectFit;
    [backbtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}





#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CarTableViewCell class])];
    if (cell == nil) {
        cell = [[CarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CarTableViewCell class])];
    }
    CarModel *item = (CarModel *)self.dataArray[indexPath.row];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150.f;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSLog(@"%@", searchText);
    
    
    if (searchController.searchBar.text.length >15) {
        searchController.searchBar.text = [searchText substringToIndex:15];
    }
}

#pragma mark - SearchInputtingDelegate
- (void)searchMyInput:(NSString *)inputStr
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViewLayout];
    [UIView animateWithDuration:1 animations:^{
        self.searchVC.searchBar.hidden = YES;
        _tableView.alpha = 1;
        self.navigationView.alpha = 1;
        
    }];
    self.searchString = inputStr;
    self.pageIndex = 0;
    [self callHttpForSearch];
    
}

#pragma mark - http
- (void)callHttpForSearch{
    __weak SearchCarViewController *weakself= self;
    NSString *dataStr = [NSString stringWithFormat:@"%@&searchStr=%@&isBind=&pageIndex=%ld",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID],self.searchString,(long)self.pageIndex];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary searchCar_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary searchCar_url],dataStr] success:^(id data) {
        [weakself.dataArray addObjectsFromArray:[[CarModel alloc] getData:data]];
        [weakself.tableView reloadData];
        weakself.pageIndex ++;
        if ([data count] < 5) {
            [weakself.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - action
- (void)backAction
{
    [self.dataArray removeAllObjects];
    self.searchVC.searchBar.hidden = NO;
    [_tableView removeFromSuperview];
    [_navigationView removeFromSuperview];
    self.backBlock();
}

@end

//
//  HomeViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/4/27.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "HomeViewController.h"
#import "DashBoardTableView.h"
#import "ShopViewController.h"
#import "MoreFunctionCollectionViewCell.h"

#import "MainMapListViewController.h"
#import "CarListTableViewController.h"
#import "DeviceListTableViewController.h"
#import "BindViewController.h"
#import "UnBindViewController.h"

#import "MoreFuncationTableViewController.h"
#import "CountryMapWebViewController.h"

#import "InventoryOrderViewController.h"


static CGFloat functionHeaderViewHeight = 95;
static CGFloat moreFuncationViewHeight = 70;

static CGFloat buttonHeight = 26;
static CGFloat widthFormWidth = 0.54;


@interface HomeViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ShopSelectChangeDelegate,DashBoardTableViewDelegate>
@property (nonatomic,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)UICollectionView *moreFunctionView;
@property (nonatomic,strong)UIView *navView;
@property (nonatomic,strong)UIView *mainNaiView;
@property (nonatomic,strong)UIView *coverNavView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIView *functionHeaderView;
@property (nonatomic,strong)DashBoardTableView *mainTableView;
@property (nonatomic,strong)UIButton *shopButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.mainScrollView];
//    [self.view addSubview:self.navView];
//    [self.view addSubview:self.mainNaiView];
//    [self.view addSubview:self.coverNavView];
    
    [self.mainScrollView addSubview:self.headerView];
    [self.headerView addSubview:self.functionHeaderView];
    [self.headerView addSubview:self.moreFunctionView];
    [self.mainScrollView addSubview:self.mainTableView];
    self.mainTableView.dashBoardDelegate = self;
    
    
//    __weak typeof (self) weakself = self;
//    self.mainScrollView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
//        [weakself.mainTableView loadMoreData];
//        [weakself.mainScrollView.mj_footer endRefreshing];
//    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID] length] == 0) {
        if ([[[NSUserDefaults standardUserDefaults] valueForKey:USERSHOPID] isEqualToString:@"shopids[]=0"]) {
            [self salesChange];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USERSHOPID] forKey:DefaultShopID];
            [[NSUserDefaults standardUserDefaults] setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USERSHOP] forKey:DefaultShopName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self createNavigationView];
        }
        
    }else{
        [self createNavigationView];
    }
    [self updateContentSize:self.mainTableView.contentSize];
    HHCodeLog(@"HH==%@",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID]);
    
    
}

- (void)createNavigationView{
    self.shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shopButton.frame = CGRectMake(0, 0, SCREEN_WIDTH /2, 20);
    [self.shopButton setImage:[UIImage imageNamed:@"toMap"] forState:UIControlStateNormal];
    [self.shopButton setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopName] forState:(UIControlStateNormal)];
    self.shopButton.titleLabel.font = SystemFont(14.f);
    [self.shopButton addTarget:self action:@selector(salesChange) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:self.shopButton];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -10;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, left];
}

- (void)updateContentSize:(CGSize)size{
    CGSize contentSize = size;
    contentSize.height = contentSize.height  + functionHeaderViewHeight + moreFuncationViewHeight;
    self.mainScrollView.contentSize = contentSize;

}
- (void)dealloc{
    
}

#pragma mark - view
- (UIScrollView *)mainScrollView{
    
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT_WithTabBar)];
        _mainScrollView.delegate = self;
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 100);
        _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(155, 0, 0, 0);
    }
    return _mainScrollView;
}

- (UIView *)navView{
    if (_navView == nil) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _navView.backgroundColor = ZDRedColor;
    }
    return _navView;
}
//正常nav
- (UIView *)mainNaiView{
    if (_mainNaiView == nil) {
        _mainNaiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _mainNaiView.backgroundColor = [UIColor clearColor];
    }
    return _mainNaiView;
    
}
//上滑nav
- (UIView *)coverNavView{
    if (_coverNavView == nil) {

        _coverNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _coverNavView.backgroundColor = [UIColor clearColor];
    }
    return _coverNavView;
}
//头
- (UIView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, functionHeaderViewHeight+moreFuncationViewHeight)];
        _headerView.backgroundColor = ZDRedColor;
    }
    return _headerView;
}
//功能按键 4
- (UIView *)functionHeaderView{
    if (_functionHeaderView == nil) {
        _functionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, functionHeaderViewHeight)];
        _functionHeaderView.backgroundColor = ZDRedColor;
        
        NSArray *imageArray = @[@"icon_monitorBtn",@"icon_carBtn",@"icon_deviceBtn",@"icon_inventoryBtn"];
        for (NSInteger i = 0; i < [imageArray count]; i ++) {
            UIButton *button = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:imageArray[i] withSelectedImage:nil];
            button.tag = i;
            [_functionHeaderView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(SCREEN_WIDTH/[imageArray count]);
                make.top.and.bottom.mas_equalTo(0);
                make.left.mas_equalTo(0).with.mas_offset(i * SCREEN_WIDTH/[imageArray count]);
            }];
            button.imageEdgeInsets = UIEdgeInsetsMake(buttonHeight * widthFormWidth, buttonHeight, buttonHeight * widthFormWidth, buttonHeight);
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button addTarget:self action:@selector(functionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        
    }
    return _functionHeaderView;
}

//更多按键
- (UICollectionView *)moreFunctionView{
    if (_moreFunctionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/5, moreFuncationViewHeight);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _moreFunctionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, functionHeaderViewHeight, SCREEN_WIDTH, moreFuncationViewHeight) collectionViewLayout:layout];
        _moreFunctionView.backgroundColor = [UIColor whiteColor];
        _moreFunctionView.delegate = self;
        _moreFunctionView.dataSource = self;
        _moreFunctionView.scrollsToTop = NO;
        _moreFunctionView.showsVerticalScrollIndicator = NO;
        _moreFunctionView.showsHorizontalScrollIndicator = NO;
        _moreFunctionView.scrollEnabled = NO;
        [_moreFunctionView registerClass:[MoreFunctionCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MoreFunctionCollectionViewCell class])];
        _moreFunctionView.contentSize = CGSizeMake(SCREEN_WIDTH, moreFuncationViewHeight);
        
    }
    return _moreFunctionView;
}

- (DashBoardTableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[DashBoardTableView alloc] initWithFrame:CGRectMake(0, moreFuncationViewHeight + functionHeaderViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT_WithTabBar - moreFuncationViewHeight - functionHeaderViewHeight)style:UITableViewStylePlain];
        _mainTableView.scrollEnabled = false;
    }
    
    return _mainTableView;
}

#pragma mark - methods

- (void)functionViewAnimation:(CGFloat)y{
    if (y > functionHeaderViewHeight/2.0) {
        [self.mainScrollView setContentOffset:CGPointMake(0, functionHeaderViewHeight) animated:YES];
    }else{
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}
#pragma mark - scrollView delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat y  = scrollView.contentOffset.y;
    if (y < -65) {
        [self.mainTableView startRefreshing];
    }else if (y >= 0 && y <= functionHeaderViewHeight){
        [self functionViewAnimation:y];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y;
    if (y <= 0) {
        CGRect newFrame = self.headerView.frame;
        newFrame.origin.y = y;
        self.headerView.frame = newFrame;
        
        newFrame = self.mainTableView.frame;
        newFrame.origin.y = y + functionHeaderViewHeight + moreFuncationViewHeight;
        self.mainTableView.frame = newFrame;
        HHCodeLog(@"tableview.y :%f",self.mainTableView.frame.origin.y);

        self.mainTableView.contentOffsetY = y;
        
        newFrame = self.functionHeaderView.frame;
        newFrame.origin.y = 0;
        self.functionHeaderView.frame = newFrame;
        self.functionHeaderView.alpha = 1.0;

    }else if (y < functionHeaderViewHeight && y > 0){
        CGRect newFrame = self.functionHeaderView.frame;
        newFrame.origin.y = y/2;
        self.functionHeaderView.frame = newFrame;
        
        CGFloat alpha = (1 - y/functionHeaderViewHeight * 2.5 ) > 0 ? (1 - y/functionHeaderViewHeight * 2.5 ) : 0;
        self.functionHeaderView.alpha = alpha;
        
        if (alpha > 0.5) {
            CGFloat newAlpha = alpha * 2 - 1;
            self.mainNaiView.alpha = newAlpha;
            self.coverNavView.alpha = 0;
        }else{
            CGFloat newAlpha = alpha * 2;
            self.mainNaiView.alpha = 0;
            self.coverNavView.alpha = 1 - newAlpha;
        }
    }
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:USERROLETYPE] integerValue] == 100 || [[[NSUserDefaults standardUserDefaults]valueForKey:USERROLETYPE] integerValue] == 200) {
        return 3;
    }
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MoreFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MoreFunctionCollectionViewCell class]) forIndexPath:indexPath];
    [cell initImageViewImage:[NSString stringWithFormat:@"icon_moreFunction_%ld",(long)indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            BindViewController *view = [[BindViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 1:
        {
            UnBindViewController *view = [[UnBindViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
        case 2:
        {
            MoreFuncationTableViewController *view = [[MoreFuncationTableViewController alloc] init];
            [self.navigationController pushViewController:view animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - action
- (void)functionBtnClick:(UIButton *)sender{
   
    switch (sender.tag) {
        case 0:
        {
            MainMapListViewController *deviceView = [[MainMapListViewController alloc] init];
            [self.navigationController pushViewController:deviceView animated:YES];
        }
            
            break;
        case 1:
        {
            CarListTableViewController *carView = [[CarListTableViewController alloc] init];
            [self.navigationController pushViewController:carView animated:YES];
        }
            break;
        case 2:
        {
            DeviceListTableViewController *deviceView = [[DeviceListTableViewController alloc] init];
            [self.navigationController pushViewController:deviceView animated:YES];
        }
            
            break;
        case 3:
        {
            //InventoryOrderViewController CarGPS-Bridging-Header
            InventoryOrderViewController *deviceView = [[InventoryOrderViewController alloc] init];
            [self.navigationController pushViewController:deviceView animated:YES];
        }
            
            break;
            
        default:
            break;
    }

}

- (void)salesChange{
    ShopViewController *shopView = [[ShopViewController alloc] init];
    UINavigationController *shopNav = [[UINavigationController alloc] initWithRootViewController:shopView];
    shopView.singleSelection = NO;
    [self presentViewController:shopNav animated:YES completion:nil];
}

- (void)shopChanged{
    [self.shopButton setTitle:[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopName] forState:(UIControlStateNormal)];
}

- (void)cellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CountryMapWebViewController *chartView = [[CountryMapWebViewController alloc] init];
//    [self.navigationController pushViewController:chartView animated:YES];
    [self presentViewController:chartView animated:YES completion:nil];
}

@end

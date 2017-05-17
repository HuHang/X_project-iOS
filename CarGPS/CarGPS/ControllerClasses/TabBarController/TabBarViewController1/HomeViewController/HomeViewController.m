//
//  HomeViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/4/27.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "HomeViewController.h"
#import "ShopViewController.h"
#import "MoreFunctionCollectionViewCell.h"
#import "DashBoardTableViewCell.h"
#import "MainMapListViewController.h"
#import "CarListTableViewController.h"
#import "DeviceListTableViewController.h"
#import "BindViewController.h"
#import "UnBindViewController.h"

#import "MoreFuncationTableViewController.h"
#import "DashboardViewController.h"

#import "InventoryOrderViewController.h"


static CGFloat functionHeaderViewHeight = 95;
static CGFloat moreFuncationViewHeight = 70;

static CGFloat buttonHeight = 26;
static CGFloat widthFormWidth = 0.54;


@interface HomeViewController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ShopSelectChangeDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UICollectionView *moreFunctionView;
@property (nonatomic,strong)UIView *functionHeaderView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *shopButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self viewLayout];
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

- (void)viewLayout{
    [self.view addSubview:self.functionHeaderView];
    [self.view addSubview:self.tableView];
    [_functionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, functionHeaderViewHeight));
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(0);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_functionHeaderView.mas_bottom);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT_WithNavAndTabBar-functionHeaderViewHeight);
    }];
}

- (void)dealloc{
    
}

#pragma mark - view

//功能按键 4
- (UIView *)functionHeaderView{
    if (_functionHeaderView == nil) {
        _functionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, functionHeaderViewHeight)];
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

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.moreFunctionView;
        _tableView.tableFooterView = [UIView new];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = UIColorFromHEX(0xFBF4F4, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DashBoardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardTableViewCell class])];
    if (cell == nil) {
        cell = [[DashBoardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardTableViewCell class])];
    }
    [cell setCellDataWithtitleImageNamge:@"dash_titleImage0" title:@"日常监管情况" titleBackColor:[UIColor whiteColor] chartImageName:@"dash_chartImage0" titleArray:@[@"入库",@"出库",@"在库"] counArray:@[@"400",@"100",@"500"] unitArray:@[@"台",@"台",@"台"] titleColorArray:@[UIColorFromHEX(0xFFBF00,1.0),UIColorFromHEX(0xFF9094,1.0),UIColorFromHEX(0x7DAFEA,1.0)]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DashboardViewController *chartView = [[DashboardViewController alloc] init];
//    [self.navigationController pushViewController:chartView animated:YES];
    [self presentViewController:chartView animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
//            InventoryOrderViewController *deviceView = [[InventoryOrderViewController alloc] init];
//            [self.navigationController pushViewController:deviceView animated:YES];
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




#pragma mark - DZNEmptyDataSetDelegate Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"dashBoard"];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 1.0, 0.0)];
    
    animation.duration = 1.0;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

// 标题文本，富文本样式
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"This is your Dashboard.";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 标题文本下面的详细描述，富文本样式
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"When you subscribe to what you are interested in,their latest posts will show up here.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
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

// 是否 允许图片有动画效果，默认NO(设置为YES后,动画效果才会有效)
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView{
    return NO;
}

// 是否 允许上下滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

// 是否 允许点击,默认是YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView{
    return YES;
}

// 点击中间的图片和文字时调用
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView{
    NSLog(@"点击了view");
}


@end

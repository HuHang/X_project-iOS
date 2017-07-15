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
#import "MainMapListViewController.h"
#import "CarListTableViewController.h"
#import "DeviceListTableViewController.h"
#import "BindViewController.h"
#import "UnBindViewController.h"

#import "MoreFuncationTableViewController.h"
#import "DashboardViewController.h"
#import "DashboardWebViewController.h"
#import "CountryMapWebViewController.h"
#import "InventoryOrderViewController.h"

#import "DashBoardWithLabelTableViewCell.h"
#import "DashBoardWithSublabelTableViewCell.h"
#import "DashBoardWithListTableViewCell.h"
#import "DashBoardWithImageTableViewCell.h"
#import "DashBoardWithSubTwoDataTableViewCell.h"
#import "DashBoardWithSubTitleThreeDataTableViewCell.h"
#import "DefaultTableViewCell.h"

#import "ChartDataModel.h"
#import "ShopModel.h"

static CGFloat functionHeaderViewHeight = 95;
static CGFloat moreFuncationViewHeight = 70;
static CGFloat buttonHeight = 26;
static CGFloat widthFormWidth = 0.54;


@interface HomeViewController ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ShopSelectChangeDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UICollectionView *moreFunctionView;
@property (nonatomic,strong)UIView *functionHeaderView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *shopButton;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationView];
    [self viewLayout];
    [self callHttpForShopData];
    
    __weak HomeViewController *weakself = self;
    self.tableView.mj_header = [HLGifHeader headerWithRefreshingBlock:^{
        [weakself setMJRefreshHeader];
    }];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)setMJRefreshHeader{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self callHttpForDashBoard];
        [self.tableView.mj_header endRefreshing];
    });
}

- (void)createNavigationView{
    self.shopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shopButton.frame = CGRectMake(0, 0, SCREEN_WIDTH *2/3, 20);
    [self.shopButton setImage:[UIImage imageNamed:@"toMap"] forState:UIControlStateNormal];
    [self.shopButton setTitle:@"选择经销商" forState:(UIControlStateNormal)];
    self.shopButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.shopButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)dealloc{
    
}

#pragma mark - view

//功能按键 4
- (UIView *)functionHeaderView{
    if (_functionHeaderView == nil) {
        _functionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, functionHeaderViewHeight)];
        _functionHeaderView.backgroundColor = ZDRedColor;
//        NSArray *imageArray = @[@"icon_monitorBtn",@"icon_carBtn",@"icon_deviceBtn",@"icon_inventoryBtn"];
        NSArray *imageArray = @[@"icon_monitorBtn",@"icon_carBtn",@"icon_deviceBtn"];

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
//        _tableView.estimatedRowHeight = 100;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}


#pragma mark - http
- (void)callHttpForDashBoard{
    __weak HomeViewController *weakself = self;
    HHCodeLog(@"%@",[URLDictionary dashBoard_url]);
    [CallHttpManager getWithUrlString:[URLDictionary dashBoard_url] success:^(id data) {
        [weakself.dataArray removeAllObjects];
        for (ChartDataModel *item in [[ChartDataModel alloc] getData:data]) {
            if (item.isOpen) {
                [weakself.dataArray addObject:item];
            }
        }
        [weakself.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)callHttpForShopData{
    __weak typeof(self) weakself = self;
    HHCodeLog(@"%@",[URLDictionary allShop_url]);
    [CallHttpManager getWithUrlString:[URLDictionary allShop_url] success:^(id data) {
        NSMutableArray *shopArrayID = [[NSMutableArray alloc] init];
        for (ShopModel *shop in [[ShopModel alloc] getData:data]) {
            [shopArrayID addObject:[NSNumber numberWithInteger:shop.ID]];
            for (ShopModel *item in [[ShopModel alloc] getData:shop.ChildShops]) {
                [shopArrayID addObject:[NSNumber numberWithInteger:item.ID]];
            }
        }
        [[NSUserDefaults standardUserDefaults]setObject:shopArrayID forKey:DefaultShopIDArray];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failure:^(NSError *error) {
        [PCMBProgressHUD hideWithView:weakself.view];
    }];
}
#pragma mark -
#pragma mark - tableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChartDataModel *item = (ChartDataModel *)self.dataArray[indexPath.row];
    switch (item.chartType) {
        case 1:case 6:
        {
            DashBoardWithLabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardWithLabelTableViewCell class])];
            if (cell == nil) {
                cell = [[DashBoardWithLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardWithLabelTableViewCell class])];
            }
            [cell setCellDataWithData:item.summary withtitle:item.header withType:item.headerId];
            return cell;
        }
            
            break;
        case 2:case 4:
        {
            DashBoardWithSublabelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardWithSublabelTableViewCell class])];
            if (cell == nil) {
                cell = [[DashBoardWithSublabelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardWithSublabelTableViewCell class])];
            }
            [cell setCellDataWithData:item.summary withtitle:item.header withType:item.headerId];
            return cell;
        }
            
            break;
            
        case 5:
        {
            DashBoardWithSubTitleThreeDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardWithSubTitleThreeDataTableViewCell class])];
            if (cell == nil) {
                cell = [[DashBoardWithSubTitleThreeDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardWithSubTitleThreeDataTableViewCell class])];
            }
            [cell setCellDataWithData:item.summary withtitle:item.header withType:item.headerId];
            return cell;
        }
            break;
            
        case 3:case 7:
        {
            
            DashBoardWithListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardWithListTableViewCell class])];
            if (cell == nil) {
                cell = [[DashBoardWithListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardWithListTableViewCell class])];
            }
            [cell setCellDataWithData:item.summary withtitle:item.header withType:item.headerId];
            return cell;
        }
            break;
            
        case 8:
        {
            DashBoardWithImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardWithImageTableViewCell class])];
            if (cell == nil) {
                cell = [[DashBoardWithImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardWithImageTableViewCell class])];
            }
            [cell setCellDataWithData:item.summary withtitle:item.header withType:item.headerId];
            return cell;
        }
        case 9:
        {
            DashBoardWithSubTwoDataTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DashBoardWithSubTwoDataTableViewCell class])];
            if (cell == nil) {
                cell = [[DashBoardWithSubTwoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DashBoardWithSubTwoDataTableViewCell class])];
            }
            [cell setCellDataWithData:item.summary withtitle:item.header withType:item.headerId];
            return cell;
        }
            break;
            
        default:
        {
            DefaultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DefaultTableViewCell class])];
            if (cell == nil) {
                cell = [[DefaultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([DefaultTableViewCell class])];
            }
            [cell loadDataForCellWithImageUrl:item.defaultUrl];
            return cell;
        }
            break;
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChartDataModel *item = (ChartDataModel *)self.dataArray[indexPath.row];

//    CountryMapWebViewController *chartView = [[CountryMapWebViewController alloc] init];
//    chartView.urlStr = item.url;
//    chartView.titleStr = item.header;
//    [self.navigationController pushViewController:chartView animated:YES];
    
    DashboardWebViewController *chartView = [[DashboardWebViewController alloc] init];
    chartView.urlStr = item.url;
    chartView.titleStr = item.header;
    [self.navigationController pushViewController:chartView animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 180;
}


#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:USERROLETYPE] integerValue] == 100 || [[[NSUserDefaults standardUserDefaults]valueForKey:USERROLETYPE] integerValue] == 200) {
        return 2;
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
    shopView.delegate = self;
    [self presentViewController:shopNav animated:YES completion:nil];
}

- (void)shopChanged{
    self.shopButton.titleLabel.text = @"选择经销商";
    [self.shopButton setTitle:@"选择经销商" forState:(UIControlStateNormal)];
    HHCodeLog(@"1233555==%@",[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopName]);
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
}


@end

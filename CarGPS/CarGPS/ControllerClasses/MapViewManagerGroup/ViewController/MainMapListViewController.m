//
//  MainMapListViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/4/21.
//  Copyright © 2017年 Charlot. All rights reserved.
//


#import "MainMapListViewController.h"
#import <MapKit/MapKit.h>
#import "WGS84TOGCJ02.h"
#import "MonitorModel.h"
#import "ShopInfoModel.h"
#import "ShopGroupModel.h"
#import "MyAnnotation.h"
#import "MyAnnotationNormal.h"
#import "ShopAnnotation.h"
#import "MKMapView+ZoomLevel.h"
#import "MainMapDetailMapViewController.h"
#import "MonitorTableViewCell.h"
#import "MonitorShopHeaderiew.h"

#import "AFNetworking/AFNetworking.h"

static CGFloat showTableButton_Height = 44.f;

@interface MainMapListViewController ()<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) MKMapView *mapView;
//@property (nonatomic,strong)UIButton *shopButton;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *annotationsArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIVisualEffectView *effectView;
@property (nonatomic,strong)UILabel *carCountLabel;
@property (nonatomic,strong)UILabel *shopCountLabel;
@end

@implementation MainMapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSArray new];
    self.annotationsArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.mapView];
    [self createNavigationView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    [self.shopButton setTitle:[user valueForKey:DefaultShopName] forState:(UIControlStateNormal)];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[user valueForKey:DefaultLatitude] doubleValue],[[user valueForKey:DefaultLongitude] doubleValue]) zoomLevel:7 animated:YES];
    [self callHttpForAllCars];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    HHCodeLog(@"MainMapListViewController didReceiveMemoryWarning");
    
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [_annotationsArray removeAllObjects];
}

- (void)dealloc{

    if (_effectView) {
        [self.effectView removeFromSuperview];
    }
    switch (self.mapView.mapType) {
        case MKMapTypeHybrid:
        {
            self.mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            self.mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    self.mapView.mapType = MKMapTypeStandard;
    _mapView.showsUserLocation = NO;
    [_mapView.layer removeAllAnimations];
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeFromSuperview];
    _mapView.delegate = nil;
    _mapView = nil;
    HHCodeLog(@"dealloc");
}
- (MKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _mapView.delegate = self;
    }
    return _mapView;
}

#pragma mark - view
- (void)createNavigationView{
    UIButton *backButton = [UIButton buttonWithBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] withNormalImage:@"icon_back" withSelectedImage:nil];
    backButton.frame = CGRectMake(0, 0, 36, 36);
    backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    backButton.layer.cornerRadius = 18;
    backButton.layer.masksToBounds = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backToSuperView) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.mapView addSubview:self.shopCountLabel];
    [self.mapView addSubview:self.carCountLabel];
    [_shopCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(20);
    }];
    [_carCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.left.equalTo(_shopCountLabel);
        make.top.equalTo(_shopCountLabel.mas_bottom).with.mas_offset(1);
    }];
    
}

- (void)createTableView{
    [_mapView addSubview:self.effectView];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, showTableButton_Height, SCREEN_WIDTH, SCREEN_HEIGHT - showTableButton_Height - 20) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIVisualEffectView *)effectView{
    if (_effectView == nil) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        _effectView.frame = CGRectMake(0, SCREEN_HEIGHT - showTableButton_Height, SCREEN_WIDTH, SCREEN_HEIGHT);
        _effectView.layer.cornerRadius = 18.f;
        _effectView.layer.masksToBounds = YES;
        UIButton *button = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_showTable" withSelectedImage:@"icon_disMisTable"];
        button.selected = NO;
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, showTableButton_Height);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button addTarget:self action:@selector(showTableView:) forControlEvents:(UIControlEventTouchUpInside)];
        [_effectView addSubview:button];
    }
    return _effectView;
}
- (UILabel *)carCountLabel{
    if (_carCountLabel == nil) {
        _carCountLabel = [UILabel labelWithString:@"车辆数：" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withBackgroundColor:[ZDRedColor colorWithAlphaComponent:0.6] withFont:SystemFont(12.f)];
        _carCountLabel.layer.cornerRadius = 5.f;
        _carCountLabel.layer.masksToBounds = YES;
    }
    return _carCountLabel;
}
- (UILabel *)shopCountLabel{
    if (_shopCountLabel == nil) {
        _shopCountLabel = [UILabel labelWithString:@"商店数：" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withBackgroundColor:[ZDRedColor colorWithAlphaComponent:0.6] withFont:SystemFont(12.f)];
        _shopCountLabel.layer.cornerRadius = 5.f;
        _shopCountLabel.layer.masksToBounds = YES;
    }
    return _shopCountLabel;
}

#pragma mark - http
- (void)callHttpForAllCars{
    __weak typeof (self) weakself = self;
    NSDictionary *params = @{@"shopIds":[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray]};
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allMonitorDevice_url],params]);
    [CallHttpManager postWithUrlString:[URLDictionary allMonitorDevice_url]
                            parameters:params
                              success:^(id data) {
                                  if ([weakself.annotationsArray count] != 0) {
                                      [weakself.mapView removeAnnotations:weakself.annotationsArray];
                                      [weakself.annotationsArray removeAllObjects];
                                  }
                                  weakself.dataArray = [[ShopGroupModel alloc] getData:data];
                                  [weakself loadAnnotationDataForMap];
                                  [weakself createTableView];
    }
                              failure:^(NSError *error) {
                              }];
}

- (void)loadAnnotationDataForMap{
    NSInteger i = 0;
    NSInteger j = 0;
    for (ShopGroupModel *groupItem in self.dataArray) {
        j ++;
        ShopInfoModel *shop = [[ShopInfoModel alloc] getData:groupItem.shop];
         [self.annotationsArray addObject:[[ShopAnnotation alloc] initWithCoordinates:[WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(shop.latitude, shop.longitude)] title:shop.name subTitle:[NSString stringWithFormat:@"车辆数:%lu台",(unsigned long)[groupItem.cars count]]]];
        for (NSDictionary *car in groupItem.cars) {
            i ++;
            MonitorModel *carInfo = [[MonitorModel alloc] getData:car];
            if (carInfo.fenceState == 100) {
                [self.annotationsArray addObject:[[MyAnnotationNormal alloc] initWithCoordinates:[WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(carInfo.lat, carInfo.lng)] title:carInfo.vin subTitle:carInfo.imei]];
            }else{
                [self.annotationsArray addObject:[[MyAnnotation alloc] initWithCoordinates:[WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(carInfo.lat, carInfo.lng)] title:carInfo.vin subTitle:carInfo.imei]];
            }
        }
    }
    [self.mapView addAnnotations:self.annotationsArray];
    [self.shopCountLabel setText:[NSString stringWithFormat:@"商店数：%lu",(long)j]];
    [self.carCountLabel setText:[NSString stringWithFormat:@"车辆数：%lu",(long)i]];
    if ([self.dataArray count] > 0) {
        ShopGroupModel *shop = (ShopGroupModel *)[self.dataArray firstObject];
        ShopInfoModel *item = [[ShopInfoModel alloc] getData:shop.shop];
        [self.mapView setCenterCoordinate:[WGS84TOGCJ02 transformFromWGSToGCJ:CLLocationCoordinate2DMake(item.latitude, item.longitude)] zoomLevel:7 animated:YES];
      }
}

#pragma mark - mapview delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *result = nil;
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"icon_annotation"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    if ([annotation isKindOfClass:[MyAnnotationNormal class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"icon_annotationBlue"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    if ([annotation isKindOfClass:[ShopAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"icon_mapShop"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }

    if([annotation isKindOfClass:[MyAnnotation class]] == NO)
    {
        return result;
    }
    
    if([mapView isEqual:self.mapView] == NO)
    {
        return result;
    }
    
   
    

    return result;
    
}


- (void)applyMapViewMemoryHotFix{
    
    switch (self.mapView.mapType) {
        case MKMapTypeHybrid:
        {
            HHCodeLog(@"MKMapTypeHybrid");
            self.mapView.mapType = MKMapTypeStandard;
        }
            
            break;
        case MKMapTypeStandard:
        {
            HHCodeLog(@"MKMapTypeStandard");
            self.mapView.mapType = MKMapTypeHybrid;
        }
            
            break;
        default:
            break;
    }
    
    
//    self.mapView.mapType = MKMapTypeStandard;
    
    
    
}
-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.mapView removeFromSuperview];
    [self.view addSubview:mapView];
//    [self applyMapViewMemoryHotFix];
}



#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![self.dataArray[section] is_Opened]) {
        return 0;
    }
    return [[self.dataArray[section] cars] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MonitorTableViewCell class])];
    MonitorModel *item = [[MonitorModel alloc] getData:[self.dataArray[indexPath.section] cars][indexPath.row]];
    
    if (cell == nil) {
        cell = [[MonitorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MonitorTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell loadDataWithVin:item.vin imei:item.imei shopName:item.currentShopName brand:item.brand carType:item.carType time:[NSString formatDateTimeForCN:item.signalTime]  status:item.fenceStateDisplay  withStatus:item.fenceState];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MonitorModel *item = [[MonitorModel alloc] getData:[self.dataArray[indexPath.section] cars][indexPath.row]];
    MainMapDetailMapViewController *detail = [[MainMapDetailMapViewController alloc] init];
    detail.deviceID = item.ID;
    detail.vinNumber = item.vin;
    [self presentViewController:detail animated:YES completion:nil];

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MonitorShopHeaderiew *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MonitorShopHeaderiew class])];
    if (sectionHeaderView == nil) {
        sectionHeaderView = [[MonitorShopHeaderiew alloc] initWithReuseIdentifier:NSStringFromClass([MonitorShopHeaderiew class])];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerViewClick:)];
    sectionHeaderView.tag = 300 + section;
    [sectionHeaderView addGestureRecognizer:tap];

    ShopInfoModel *item = [[ShopInfoModel alloc] getData:[self.dataArray[section] shop]];
    [sectionHeaderView loadDataForHeaderViewWith:item.name bankName:item.allBankPath withCarCount:[[self.dataArray[section] cars] count]];
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isMemberOfClass:[MonitorShopHeaderiew class]]) {
        ((MonitorShopHeaderiew *)view).backgroundView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    }
}

#pragma mark -action

- (void)headerViewClick:(UIGestureRecognizer *)tap{
    for (ShopGroupModel *shop in self.dataArray) {
        if ([shop isEqual:self.dataArray[tap.view.tag - 300]]) {
            shop.is_Opened = !shop.is_Opened;
        }else{
            shop.is_Opened = NO;
        }
    }
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag - 300] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)backToSuperView{
    [self.navigationController.navigationBar lt_setBackgroundColor:ZDRedColor];
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)showTableView:(UIButton *)sender{
    __weak MainMapListViewController *weakself = self;
    if (sender.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            [weakself.effectView setFrame:CGRectMake(0, SCREEN_HEIGHT - showTableButton_Height, SCREEN_WIDTH, SCREEN_HEIGHT - 10)];
            [weakself.navigationController.navigationBar lt_setTranslationY:(0)];
        } completion:^(BOOL finished) {
            [weakself.tableView removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [weakself.effectView setFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 10)];
            [weakself.navigationController.navigationBar lt_setTranslationY:(-64)];
        } completion:^(BOOL finished) {
            [weakself.effectView addSubview:weakself.tableView];

        }];
        

    }
    sender.selected = !sender.selected;

}



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
    return [UIColor clearColor];
}

// 图片与标题文本,以及标题文本和详细描述之间的垂直距离,默认是11pts
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 11;
}


// 是否 允许上下滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}


@end

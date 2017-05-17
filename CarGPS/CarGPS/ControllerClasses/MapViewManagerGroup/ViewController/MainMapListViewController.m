//
//  MainMapListViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/4/21.
//  Copyright © 2017年 Charlot. All rights reserved.
//


#import "MainMapListViewController.h"
#import <MapKit/MapKit.h>

#import "MonitorModel.h"
#import "MyAnnotation.h"
#import "MyAnnotationNormal.h"
#import "MKMapView+ZoomLevel.h"
#import "DeviceMapViewController.h"
#import "MonitorTableViewCell.h"

static CGFloat showTableButton_Height = 44.f;

@interface MainMapListViewController ()<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong)UIButton *shopButton;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableArray *annotationsArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIVisualEffectView *effectView;

@property (nonatomic,strong)UILabel *countLabel;
@end

@implementation MainMapListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSArray new];
    self.annotationsArray = [[NSMutableArray alloc] init];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self createNavigationView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [self.shopButton setTitle:[user valueForKey:DefaultShopName] forState:(UIControlStateNormal)];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([[user valueForKey:DefaultLatitude] doubleValue],[[user valueForKey:DefaultLongitude] doubleValue]) zoomLevel:7 animated:YES];
    [self callHttpForAllCars];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
}

- (void)dealloc{
    if (_effectView) {
        [self.effectView removeFromSuperview];
    }
    self.mapView.delegate = nil;
    HHCodeLog(@"dealloc");
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

    UILabel *titleLabel = [UILabel labelWithString:[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopName] withTextAlignment:(NSTextAlignmentCenter) withTextColor:ZDRedColor withBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] withFont:SystemFont(14.f)];
    titleLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 36);
    titleLabel.layer.cornerRadius = 5.f;
    titleLabel.layer.masksToBounds = YES;
    self.navigationItem.titleView = titleLabel;
    [self.mapView addSubview:self.countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 30));
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(70);
    }];
    
}

- (void)createTableView{
    [_mapView addSubview:self.effectView];
    [_effectView addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, showTableButton_Height, SCREEN_WIDTH, SCREEN_HEIGHT - showTableButton_Height - 20) style:(UITableViewStylePlain)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIVisualEffectView *)effectView{
    if (_effectView == nil) {
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
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
- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [UILabel labelWithString:@"车辆数：" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withBackgroundColor:[ZDRedColor colorWithAlphaComponent:0.6] withFont:SystemFont(12.f)];
        _countLabel.layer.cornerRadius = 5.f;
        _countLabel.layer.masksToBounds = YES;
    }
    return _countLabel;
}
#pragma mark - http
- (void)callHttpForAllCars{
    __weak typeof (self) weakself = self;
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary allMonitorDevice_url],[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID]]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary allMonitorDevice_url],[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopID]]
                              success:^(id data) {
                                  if ([weakself.annotationsArray count] != 0) {
                                      [weakself.mapView removeAnnotations:weakself.annotationsArray];
                                      [weakself.annotationsArray removeAllObjects];
                                  }
                                  weakself.dataArray = [[MonitorModel alloc] getData:data];
                                  for (MonitorModel *item in weakself.dataArray) {
                                      if (item.fenceState == 100) {
                                          [weakself.annotationsArray addObject:[[MyAnnotationNormal alloc] initWithCoordinates:CLLocationCoordinate2DMake(item.lat, item.lng) title:item.vin subTitle:item.imei]];
                                      }else{
                                          [weakself.annotationsArray addObject:[[MyAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(item.lat, item.lng) title:item.vin subTitle:item.imei]];
                                      }
                                      
                                  }
                                  if ([weakself.dataArray count] > 0) {
                                      MonitorModel *item = (MonitorModel *)[weakself.dataArray firstObject];
                                      [weakself.mapView setCenterCoordinate:CLLocationCoordinate2DMake(item.lat,item.lng) zoomLevel:7 animated:YES];
                                  }
                                  
                                  [weakself.countLabel setText:[NSString stringWithFormat:@"车辆数：%lu",(unsigned long)[weakself.dataArray count]]];
                                  [weakself.mapView addAnnotations:weakself.annotationsArray];
                                  [weakself createTableView];
    
    }
                              failure:^(NSError *error) {
        
                              }];
   
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MonitorTableViewCell class])];
    MonitorModel *item = (MonitorModel *)self.dataArray[indexPath.row];
    if (cell == nil) {
        cell = [[MonitorTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MonitorTableViewCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    [cell loadDataWithVin:item.vin imei:item.imei shopName:item.currentShopName brand:item.brand carType:item.carType time:[NSString formatDateTimeForCN:item.signalTime]  status:item.fenceStateDisplay  withStatus:item.fenceState];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MonitorModel *item = (MonitorModel *)self.dataArray[indexPath.row];
    DeviceMapViewController *detail = [[DeviceMapViewController alloc] init];
    detail.deviceID = item.ID;
    detail.vinNumber = item.vin;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark -action
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
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [weakself.effectView setFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 10)];
            [weakself.navigationController.navigationBar lt_setTranslationY:(-64)];

        } completion:nil];
        

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

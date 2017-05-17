//
//  CarMapViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "CarMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "MyAnnotationNormal.h"
#import "MKMapView+ZoomLevel.h"
#import "DeviceCoordinateModel.h"
#import "CoordinatesModel.h"
#import "DeviceInfoModel.h"
#import "WSDatePickerView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WhenTappedBlocks.h"
#import "StartAnnotation.h"
#import "EndAnnotation.h"



@interface CarMapViewController ()<MKMapViewDelegate>
@property(nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) MKPolyline *trailLine;
@property (nonatomic,strong)UIButton *shopButton;
@property (nonatomic,strong)UIButton *historyButton;


@property (nonatomic,strong)NSArray *coordinateArray;
@property (nonatomic,strong)NSMutableArray *annitationArray;
@property (nonatomic,strong)UIView *coverView;
@property (nonatomic,strong)UIVisualEffectView *effectView;

@property (nonatomic,strong)UIView *timeContentView;
@property (nonatomic,strong)UIButton *editStartTimeButton;
@property (nonatomic,strong)UIButton *editEndTimeButton;

@property (nonatomic,strong)UILabel *imeiLabel;
@property (nonatomic,strong)UILabel *locationLabel;
@property (nonatomic,strong)UILabel *latLabel;
@property (nonatomic,strong)UILabel *lngLabel;

@property (nonatomic,strong)NSString *startString;
@property (nonatomic,strong)NSString *endString;

@property (nonatomic,strong)UIImageView *bindImage1;
@property (nonatomic,strong)UIImageView *bindImage2;

@property (nonatomic,strong)UITapGestureRecognizer *tapGesture;
@end

@implementation CarMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;
    [self createNavigationView];
    self.coordinateArray = [NSArray new];
    [self dateLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self callHttpForLastCoordinate];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}
-(void)dateLoad
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    self.endString = [[today stringWithFormat:@"yyyy-MM-dd HH:mm"] substringToIndex:16];
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    self.startString = [[yesterday stringWithFormat:@"yyyy-MM-dd HH:mm"] substringToIndex:16];
    
}
- (void)dealloc{
    HHCodeLog(@"dealloc");
    if (_coverView) {
        [self.coverView removeFromSuperview];
    }
    if (_effectView) {
        [self.effectView removeFromSuperview];
    }
    self.mapView.delegate = nil;
}

- (void)backToSuperView{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableArray *)annitationArray{
    if (_annitationArray == nil) {
        _annitationArray = [[NSMutableArray alloc] init];
    }
    return _annitationArray;
}
#pragma mark - view
- (void)createNavigationView{
    UIButton *backButton = [UIButton buttonWithBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] withNormalImage:@"icon_back" withSelectedImage:nil];
    UIButton *rightButton = [UIButton buttonWithBackgroundColor:[UIColor whiteColor] withNormalImage:@"icon_historySetup" withSelectedImage:nil];
    self.historyButton = [UIButton buttonWithBackgroundColor:[UIColor whiteColor] withNormalImage:@"icon_historyLineDefalut" withSelectedImage:@"icon_historyLine"];
    
    [self.mapView addSubview:backButton];
    [self.mapView addSubview:rightButton];
    [self.mapView addSubview:self.historyButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    [self.historyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.top.equalTo(backButton);
        make.right.mas_equalTo(-20);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.right.equalTo(self.historyButton);
        make.top.equalTo(self.historyButton.mas_bottom).with.mas_offset(1);
    }];
    
    
    backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    backButton.layer.cornerRadius = 18;
    backButton.layer.masksToBounds = YES;
    [backButton addTarget:self action:@selector(backToSuperView) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.historyButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    self.historyButton.selected = NO;
    self.historyButton.layer.cornerRadius = 5;
    self.historyButton.layer.masksToBounds = YES;
    [self.historyButton addTarget:self action:@selector(showHistoryLine:) forControlEvents:(UIControlEventTouchUpInside)];
    
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    rightButton.layer.cornerRadius = 5;
    rightButton.layer.masksToBounds = YES;
    [rightButton addTarget:self action:@selector(showActionView) forControlEvents:(UIControlEventTouchUpInside)];
    
}

//遮罩层
- (UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
        _coverView.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:0.5f];
        _coverView.alpha = 0.f;
        self.tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSubView)];
        [_coverView addGestureRecognizer:_tapGesture];
        [_tapGesture setNumberOfTapsRequired:1];
    }
    return _coverView;
}

//毛玻璃
- (UIVisualEffectView *)effectView{
    if (_effectView == nil) {
        //毛玻璃
        _effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        _effectView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _effectView.layer.cornerRadius = 8.f;
        _effectView.layer.masksToBounds = YES;
        [self.view.window addSubview:_effectView];
        //关闭按钮
        UIButton *button = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_dismissBtn" withSelectedImage:nil];
        [_effectView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.layer.cornerRadius = 10.f;
        [button addTarget:self action:@selector(closeSubView) forControlEvents:(UIControlEventTouchUpInside)];
        //标题
        UILabel *titleLabel = [UILabel labelWithString:@"设置及详情" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(16.f)];
        [_effectView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.and.height.equalTo(button);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        
        //历史轨迹
        [_effectView addSubview:self.timeContentView];
    }
    return _effectView;
}

//详情view
- (UIView *)timeContentView{
    if (_timeContentView == nil) {
        _timeContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, SCREEN_HEIGHT/2 - 36)];
        //时间选择
        UILabel *startTimeLabel = [UILabel labelWithString:@"开始时间" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
        UILabel *endTimeLabel = [UILabel labelWithString:@"结束时间" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
        //分割线
        UIView *lineView01 = [self lineView];
        
        [_timeContentView addSubview:lineView01];
        [_timeContentView addSubview:startTimeLabel];
        [_timeContentView addSubview:endTimeLabel];
        [_timeContentView addSubview:self.editStartTimeButton];
        [_timeContentView addSubview:self.editEndTimeButton];
        //布局
        [lineView01 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
            make.top.mas_equalTo(SCREEN_HEIGHT/7);
        }];
        
        [startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 30));
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.top.equalTo(startTimeLabel);
            make.right.mas_equalTo(0);
        }];
        [_editStartTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(startTimeLabel).with.mas_equalTo(0);
            make.right.equalTo(startTimeLabel).with.mas_equalTo(-5);
            make.top.equalTo(startTimeLabel.mas_bottom);
            make.bottom.equalTo(lineView01.mas_top);
        }];
        [_editEndTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(endTimeLabel).with.mas_equalTo(5);
            make.right.equalTo(endTimeLabel).with.mas_equalTo(0);
            make.top.equalTo(endTimeLabel.mas_bottom);
            make.bottom.equalTo(lineView01.mas_top);
        }];
        
        //详情信息
        
        UILabel *imeiTitleLabel = [UILabel labelWithString:@"设备号：" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
        UIImageView *latImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lat"]];
        UIImageView *lngImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_lng"]];
        UIImageView *addressImage = [self imageViewWithName:@"icon_address"];
        [_timeContentView addSubview:imeiTitleLabel];
        [_timeContentView addSubview:self.imeiLabel];
        [_timeContentView addSubview:self.locationLabel];
        [_timeContentView addSubview:self.latLabel];
        [_timeContentView addSubview:self.lngLabel];
        [_timeContentView addSubview:addressImage];
        [_timeContentView addSubview:latImageView];
        [_timeContentView addSubview:lngImageView];
        [_timeContentView addSubview:self.bindImage1];
        [_timeContentView addSubview:self.bindImage2];
        
        //布局
        
        [imeiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.left.mas_equalTo(10);
            make.top.equalTo(lineView01.mas_bottom).with.mas_offset(10);
        }];
        [_imeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.height.equalTo(imeiTitleLabel);
            make.left.equalTo(imeiTitleLabel.mas_right);
            make.right.mas_equalTo(-SCREEN_WIDTH/3);
        }];
        
        
        [_latLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(startTimeLabel);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
        [latImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(16, 16));
            make.right.equalTo(_latLabel.mas_left);
            make.centerY.equalTo(_latLabel);
        }];
        
        [_lngLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(endTimeLabel);
            make.size.and.top.equalTo(_latLabel);
        }];
        [lngImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerY.equalTo(latImageView);
            make.right.equalTo(_lngLabel.mas_left);
        }];
        
        [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imeiTitleLabel).with.mas_offset(30);
            make.bottom.equalTo(_latLabel.mas_top);
            make.right.equalTo(_imeiLabel);
            make.height.mas_equalTo(30);
        }];
        [addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imeiTitleLabel);
            make.centerY.equalTo(_locationLabel);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        [_bindImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imeiTitleLabel.mas_bottom);
            make.bottom.equalTo(_locationLabel.mas_top);
            make.left.mas_equalTo(imeiTitleLabel.mas_right);
            make.right.equalTo(_timeContentView.mas_centerX).with.mas_offset(-5);
        }];
        [_bindImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timeContentView.mas_centerX).with.mas_offset(5);
            make.size.and.top.mas_equalTo(_bindImage1);
        }];
    }
    return _timeContentView;
}


/**
 开始时间view
 
 @return 开始时间view
 */
- (UIButton *)editStartTimeButton{
    if (_editStartTimeButton == nil) {
        _editStartTimeButton = [UIButton buttonWithString:self.startString withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
        
        [_editStartTimeButton addTarget:self action:@selector(selectedTime:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editStartTimeButton;
}

/**
 结束时间view
 
 @return 结束时间view
 */
- (UIButton *)editEndTimeButton{
    if (_editEndTimeButton == nil) {
        _editEndTimeButton = [UIButton buttonWithString:self.endString withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
        [_editEndTimeButton addTarget:self action:@selector(selectedTime:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editEndTimeButton;
}


/**
 vinlabel
 
 @return vinlabel
 */

- (UILabel *)imeiLabel{
    if (_imeiLabel == nil) {
        _imeiLabel = [UILabel labelWithString:@"" withTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
    }
    return _imeiLabel;
}

/**
 地址
 
 @return 地址
 */
- (UILabel *)locationLabel{
    if (_locationLabel == nil) {
        _locationLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentLeft) withTextColor:[UIColor blackColor] withFont:SystemFont(12.f)];
        _locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locationLabel.numberOfLines = 0;
    }
    return _locationLabel;
}

/**
 纬度
 
 @return 纬度
 */
- (UILabel *)latLabel{
    if (_latLabel == nil) {
        _latLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    }
    return  _latLabel;
}

/**
 经度
 
 @return 经度
 */
- (UILabel *)lngLabel{
    if (_lngLabel == nil) {
        _lngLabel = [UILabel labelWithTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(12.f)];
    }
    return  _lngLabel;
}

- (UIImageView *)bindImage1{
    if (_bindImage1 == nil) {
        _bindImage1 = [[UIImageView alloc] init];
        [_bindImage1 whenTapped:^{
            HHCodeLog(@"112");
        }];
        
    }
    return _bindImage1;
}

- (UIImageView *)bindImage2{
    if (_bindImage2 == nil) {
        _bindImage2 = [[UIImageView alloc] init];
        [_bindImage2 whenTapped:^{
            HHCodeLog(@"221");
        }];
    }
    return _bindImage2;
}

- (UIView *)lineView{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromHEX(0xD9D9D9,1.0);
    return view;
}
- (UIImageView *)imageViewWithName:(NSString *)imageName{
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    view.contentMode = UIViewContentModeScaleAspectFit;
    return view;
}

#pragma mark - http
- (void)callHttpForLastCoordinate{
    __weak CarMapViewController *weakself = self;
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@id=%ld",[URLDictionary lastCoordinate_url],(long)self.deviceID]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@id=%ld",[URLDictionary lastCoordinate_url],(long)self.deviceID]
                              success:^(id data) {
                                  DeviceCoordinateModel *item = [[DeviceCoordinateModel alloc] getData:data];
                                  [weakself.mapView setCenterCoordinate:CLLocationCoordinate2DMake(item.lat, item.lng) zoomLevel:9 animated:YES];
                                  if (item.fenceState == 100) {
                                      [weakself.mapView addAnnotation:[[MyAnnotationNormal alloc] initWithCoordinates:CLLocationCoordinate2DMake(item.lat, item.lng) title:@"当前位置(围栏内)" subTitle:[NSString stringWithFormat:@"车架号:%@",item.vin]]];
                                  }else{
                                      [weakself.mapView addAnnotation:[[MyAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(item.lat, item.lng) title:@"当前位置（围栏外）" subTitle:[NSString stringWithFormat:@"车架号:%@",item.vin]]];
                                  }
                                  
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}
- (void)callHttpForBindInfo{
    __weak CarMapViewController *weakself = self;
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@vin=%@",[URLDictionary bindDeviceInfo_url],self.vinNumber]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@vin=%@",[URLDictionary bindDeviceInfo_url],self.vinNumber]
                              success:^(id data) {
                                  DeviceInfoModel *item = [[DeviceInfoModel alloc] getData:data];
                                  weakself.imeiLabel.text = item.imei;
                                  weakself.lngLabel.text = [NSString stringWithFormat:@"%f",item.currentLatitude];
                                  weakself.latLabel.text = [NSString stringWithFormat:@"%f",item.currentLongitude];
                                  [weakself.bindImage1 sd_setImageWithURL:[NSURL URLWithString:[item.imagesUrl firstObject]] placeholderImage:[UIImage imageNamed:@"icon_webImageDefault"]];
                                  [weakself.bindImage2 sd_setImageWithURL:[NSURL URLWithString:[item.imagesUrl lastObject]] placeholderImage:[UIImage imageNamed:@"icon_webImageDefault"]];
                                  [weakself formatAddressWithLatitude:item.currentLatitude longitude:item.currentLongitude];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}

- (void)callHttpForCoordinates{
    __weak CarMapViewController *weakself = self;
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@id=%ld&startTime=%@&endTime=%@",[URLDictionary allCoordinate_url],(long)self.deviceID,self.editStartTimeButton.titleLabel.text,self.editEndTimeButton.titleLabel.text]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@id=%ld&startTime=%@&endTime=%@",[URLDictionary allCoordinate_url],(long)self.deviceID,self.editStartTimeButton.titleLabel.text,self.editEndTimeButton.titleLabel.text]
                              success:^(id data) {
                                  if ([data count] > 0) {
                                      [weakself removeTrailLine];
                                      weakself.coordinateArray = [[CoordinatesModel alloc] getData:data[@"gps"]];
                                      if ([weakself.coordinateArray count] == 0) {
                                          [PCMBProgressHUD showLoadingTipsInView:weakself.view.window title:nil detail:@"该时段内暂无移动信息" withIsAutoHide:YES];
                                          weakself.historyButton.selected = NO;
                                      }else{
                                          [weakself loadMapLineData];
                                      }
                                  }
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
    if ([annotation isKindOfClass:[StartAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"icon_mapbegin"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    if ([annotation isKindOfClass:[EndAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"icon_mapend"];
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

#pragma mark - create line view
- (void)loadMapLineData{
    CLLocationCoordinate2D pointsToUse[self.coordinateArray.count];
    for (NSInteger i = 0; i < [self.coordinateArray count]; i ++) {
        pointsToUse[i] = CLLocationCoordinate2DMake([(CoordinatesModel *)self.coordinateArray[i] lat], [(CoordinatesModel *)self.coordinateArray[i] lng]);
    }
    self.trailLine = [MKPolyline polylineWithCoordinates:pointsToUse count:self.coordinateArray.count];
    [self.mapView addOverlay:self.trailLine];
    [self addAnnotationsForHistory];
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        MKPolylineView *polyLineView = [[MKPolylineView alloc] initWithPolyline:(id)overlay];
        polyLineView.lineWidth = 5; //折线宽度
        polyLineView.strokeColor = ZDRedColor; //折线颜色
        return (MKOverlayRenderer *)polyLineView;
#pragma clang diagnostic pop
    }
    return nil;
}
- (void)removeTrailLine{
    if (self.trailLine != nil) {
        [self.mapView removeOverlay:self.trailLine];
    }
    if ([self.annitationArray count] > 0) {
        [self.mapView removeAnnotations:self.annitationArray];
    }
}

- (void)addAnnotationsForHistory{
    [self.annitationArray removeAllObjects];
    [self.annitationArray addObject:[[StartAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake([(CoordinatesModel *)self.coordinateArray.firstObject lat], [(CoordinatesModel *)self.coordinateArray.firstObject lng]) title:@"起点" subTitle:[(CoordinatesModel *)self.coordinateArray.firstObject signalTime]]];
    [self.annitationArray addObject:[[EndAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake([(CoordinatesModel *)self.coordinateArray.lastObject lat], [(CoordinatesModel *)self.coordinateArray.lastObject lng]) title:@"终点" subTitle:[(CoordinatesModel *)self.coordinateArray.lastObject signalTime]]];
    [self.mapView addAnnotations:self.annitationArray];
}


#pragma mark - action
- (void)showActionView{
    [self callHttpForBindInfo];
    if (_coverView == nil) {
        HHCodeLog(@"_coverView == nil");
        [self.view.window addSubview:self.coverView];
        [self.view.window insertSubview:self.effectView aboveSubview:_coverView];
        __weak CarMapViewController *weakself = self;
        [UIView animateWithDuration:0.5 animations:^{
            [weakself.effectView setFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        } completion:^(BOOL finished) {
            weakself.coverView.alpha = 0.8f;
        }];
    }else{
        HHCodeLog(@"_coverView != nil");
        
        __weak CarMapViewController *weakself = self;
        [UIView animateWithDuration:0.5 animations:^{
            [weakself.effectView setFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
        } completion:^(BOOL finished) {
            weakself.coverView.alpha = 0.8f;
        }];
    }
    
    
    
}
- (void)closeSubView{
    __weak CarMapViewController *weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.effectView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    } completion:^(BOOL finished) {
        weakself.coverView.alpha = 0.f;
    }];
}
- (void)showHistoryLine:(UIButton *)sender{
    if (sender.selected) {
        [self removeTrailLine];
    }else{
        [self callHttpForCoordinates];
    }
    sender.selected = !sender.selected;
}
- (void)selectedTime:(UIButton *)sender{
    __weak CarMapViewController *weakself = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithCompleteBlock:^(NSDate *startDate) {
        NSString *resultForDate = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        sender.titleLabel.text = resultForDate;
        [sender setTitle:resultForDate forState:(UIControlStateNormal)];
        if (!weakself.historyButton.selected) {
            weakself.historyButton.selected = YES;
        }
        //        [weakself closeSubView];
        [weakself callHttpForCoordinates];
    }];
    
    datepicker.datePickerStyle = DateStyleShowYearMonthDayHourMinute;
    datepicker.minLimitDate = [NSDate date:@"1970-1-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    datepicker.maxLimitDate = [NSDate date:@"2049-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    [datepicker show];
}

#pragma mark - 反编码
- (void)formatAddressWithLatitude:(double)latitude longitude:(double)longitude{
    __weak CarMapViewController *weakSelf = self;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark * placemark = [placemarks firstObject];
            NSString *locality = placemark.locality ? placemark.locality : @"";
            NSString *subLocality = placemark.subLocality ? placemark.subLocality : @"";
            NSString *thoroughfare = placemark.thoroughfare ? placemark.thoroughfare : @"";
            NSString *subThoroughfare = placemark.subThoroughfare ? placemark.subThoroughfare : @"";
            NSString *locationStr = [NSString stringWithFormat:@"%@%@%@%@",locality, subLocality,thoroughfare,subThoroughfare];
            weakSelf.locationLabel.text = locationStr;
        }else{
            weakSelf.locationLabel.text =  @"暂无地址";
        }
        
    }];
}

@end

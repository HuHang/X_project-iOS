//
//  DashboardViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "DashboardViewController.h"
#import "ChartDataModel.h"
#import "YJWebProgressLayer.h"
#import "WebviewTableViewCell.h"
#import "SegmentCustomStyleManager.h"


@interface DashboardViewController ()<UITableViewDelegate,UITableViewDataSource,SegmentCustomViewDelegate>
@property (nonatomic, strong) YJWebProgressLayer *webProgressLayer;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong) SegmentCustomStyleManager *segmentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property NSInteger selectedIndex;
@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedIndex = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)shouldAutorotate{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
//    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
//    
//    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar.layer addSublayer:self.webProgressLayer];
//    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //    [[UIDevice currentDevice] setValue: [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    [self viewLayout];
    [self callHttpForMapDataWithType:@"enterStock"];
}


- (void)dissMissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_webProgressLayer closeTimer];
    [_webProgressLayer removeFromSuperlayer];
    _webProgressLayer = nil;
}



- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray new];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        //        _tableView.emptyDataSetSource = self;
        //        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = UIColorFromHEX(0xFBF4F4, 1.0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (YJWebProgressLayer *)webProgressLayer{
    if (_webProgressLayer == nil) {
        _webProgressLayer = [[YJWebProgressLayer alloc] init];
        _webProgressLayer.frame = CGRectMake(0, 42, SCREEN_WIDTH, 2);
        
    }
    return _webProgressLayer;
}
- (SegmentCustomStyleManager *)segmentView{
    if (_segmentView == nil) {
        NSArray *arrar = [NSArray arrayWithObjects:@"车辆入库统计",@"车辆出库统计",@"日均在库统计",nil];
        _segmentView = [[SegmentCustomStyleManager alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.type = PiecewiseInterfaceTypeMobileLin;
        _segmentView.delegate = self;
        _segmentView.textFont = [UIFont systemFontOfSize:14.f];
        _segmentView.textNormalColor = [UIColor grayColor];
        _segmentView.textSeletedColor = ZDRedColor;
        _segmentView.linColor = ZDRedColor;
        [_segmentView loadTitleArray:arrar];
    }
    return _segmentView;
}
- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [UILabel labelWithString:@"日常监管情况" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(16.f)];
    }
    return _titleLabel;
}



- (void)viewLayout{
    UIButton *button = [UIButton buttonWithString:@"返回" withBackgroundColor:ZDRedColor withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f)];
    [self.view addSubview:button];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.titleLabel];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 20));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 20));
        make.left.mas_equalTo(0);
        make.top.equalTo(button.mas_bottom);
    }];
    [button addTarget:self action:@selector(dissMissView) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - http
- (void)callHttpForMapDataWithType:(NSString *)type{
    [PCMBProgressHUD showLoadingImageInView:self.view isResponse:YES];
    __weak DashboardViewController *weakself = self;
    NSString *dataStr = [NSString stringWithFormat:@"type=%@",type];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary getFirstDashboard_url],dataStr]
                              success:^(id data) {
                                  [PCMBProgressHUD hideWithView:weakself.view];
                                  weakself.dataArray = [[ChartDataModel alloc] getData:data[0][@"data"]];
                                  [weakself.tableView reloadData];
                              }
                              failure:^(NSError *error) {
                                  [PCMBProgressHUD hideWithView:weakself.view];
                              }];
}





#pragma mark -
#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier;
//    switch (self.selectedIndex) {
//        case 0:
//            identifier = @"WebviewTableViewCell0";
//            break;
//        case 1:
//            identifier = @"WebviewTableViewCell1";
//            break;
//        case 2:
//            identifier = @"WebviewTableViewCell2";
//            break;
//        default:
//            break;
//    }
    WebviewTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WebviewTableViewCell class])];
    if (cell == nil) {
        cell = [[WebviewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([WebviewTableViewCell class])];
    }
    ChartDataModel *item = (ChartDataModel *)self.dataArray[indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",item.url,[[NSUserDefaults standardUserDefaults] valueForKey:TOKEN]];
    //        NSString *urlStr = @"http://139.224.134.254:9001/Report_DailySupervision/ProvinceMap?request_from=app&request_type=enterStock&token=Basic YWRtaW46YWRtaW4=";
    [cell loadDataForCellWithURl:urlStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.segmentView;
}

#pragma mark - segment delegate
- (void)segmentCustomView:(SegmentCustomStyleManager *)segmentCustomView index:(NSInteger)index{
    self.selectedIndex = index;
    switch (index) {
        case 0:
            [self callHttpForMapDataWithType:@"enterStock"];
            break;
        case 1:
            [self callHttpForMapDataWithType:@"outStock"];
            break;
        case 2:
            [self callHttpForMapDataWithType:@""];
            break;
            
        default:
            break;
    }
    
}

@end

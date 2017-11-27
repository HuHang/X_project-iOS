//
//  MessageDetailTableViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "MessageDetailTableViewController.h"
#import "MessageDetailTableViewCell.h"
#import "MessageDetailModel.h"
#import "DefaultModel.h"
#import <MapKit/MapKit.h>
#import "MKMapView+ZoomLevel.h"
#import "MyAnnotation.h"
#import "SegmentCustomStyleManager.h"
static NSInteger segmentViewHeight = 40;

@interface MessageDetailTableViewController ()<MKMapViewDelegate,SegmentCustomViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UIView *coverView;
@property(nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) SegmentCustomStyleManager *segmentView;
@property NSInteger segmentViewSelectedIndex;
@property NSInteger pageIndex;
@end
//getMessageTypeList_url
@implementation MessageDetailTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    [self createNavigationView];
    [self initTableView];
    __weak MessageDetailTableViewController *weakself = self;
    self.tableView.mj_header = [HLNormalHeader headerWithRefreshingBlock:^{
        weakself.pageIndex = 0;
        [weakself setMJRefreshHeader];
        [weakself.tableView.mj_footer resetNoMoreData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself setMJRefreshFooter];
    }];

    [self.tableView.mj_header beginRefreshing];
    HHCodeLog(@"hahahhahaq");

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    HHCodeLog(@"hahahhaha2");
    HHCodeLog(@"hahahhaha2");
    HHCodeLog(@"hahahhaha2");
    HHCodeLog(@"hahahhaha2");
    
    @try {
    } @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    } @finally {
        
    }
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    HHCodeLog(@"hahahhaha");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}
- (void)callHttpForMessageWithSelectedIndex{
    switch (self.segmentViewSelectedIndex) {
        case 0:
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [self callHttpForMessages:@"false"];
            break;
        case 1:
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [self callHttpForMessages:@"true"];
            break;
        default:
            break;
    }
}

- (void)setMJRefreshHeader{
    __weak MessageDetailTableViewController *weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself callHttpForMessageWithSelectedIndex];
        [weakself.tableView.mj_header endRefreshing];
    });
}

- (void)setMJRefreshFooter{
    __weak MessageDetailTableViewController *weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself callHttpForMessageWithSelectedIndex];
        [weakself.tableView.mj_footer endRefreshing];
    });

}

- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - view

- (void)createNavigationView{
    self.navigationItem.title = _titleName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部已读" style:(UIBarButtonItemStylePlain) target:self action:@selector(readAllMsg)];
    
}
- (SegmentCustomStyleManager *)segmentView{
    if (_segmentView == nil) {
        NSArray *arrar = [NSArray arrayWithObjects:@"未读消息",@"已读消息", nil];
        _segmentView = [[SegmentCustomStyleManager alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, segmentViewHeight)];
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
- (UIView *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] init];
        _coverView.frame = CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT);
        _coverView.backgroundColor = [UIColor colorWithRed:(40/255.0f) green:(40/255.0f) blue:(40/255.0f) alpha:0.5f];
        _coverView.alpha = 0.f;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSubView)];
        [_coverView addGestureRecognizer:tapGesture];
        [tapGesture setNumberOfTapsRequired:1];
    }
    return _coverView;
}


- (MKMapView *)mapView{
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, SCREEN_HEIGHT/2)];
        _mapView.center = self.view.window.center;
        _mapView.delegate = self;
        UIButton *enlargeBtn = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"icon_enLarge" withSelectedImage:@"icon_deLarge"];
        [_mapView addSubview:enlargeBtn];
        [enlargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        [enlargeBtn addTarget:self action:@selector(enlargeMap:) forControlEvents:(UIControlEventTouchUpInside)];
        [enlargeBtn setSelected:NO];
        _mapView.layer.cornerRadius = 5.f;
        _mapView.layer.masksToBounds = YES;
        [enlargeBtn.layer setShadowColor:ZDRedColor.CGColor];
        [enlargeBtn.layer setShadowOpacity:0.8f];
        [enlargeBtn.layer setShadowOffset:CGSizeMake(1.0, 0)];
        [enlargeBtn.layer masksToBounds];
    }
    return _mapView;
}
- (void)initTableView{
    self.tableView.tableHeaderView = self.segmentView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        if (offsetY >= 44) {
            [self setNavigationBarTransformProgress:1];
        } else {
            [self setNavigationBarTransformProgress:(offsetY / 44)];
        }
    } else {
        [self setNavigationBarTransformProgress:0];
        //        self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    }
}
- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.navigationController.navigationBar lt_setTranslationY:(-44 * progress)];
    [self.navigationController.navigationBar lt_setElementsAlpha:(1-progress)];
}

#pragma mark - Http
- (void)callHttpForMessages:(NSString *)is_read{
    __weak MessageDetailTableViewController *weakSelf = self;
    [PCMBProgressHUD showLoadingImageInView:self.view.window isResponse:NO];
    NSString *dataStr = [NSString stringWithFormat:@"type=%ld&isRead=%@&pageIndex=%ld",(long)self.keyValue,is_read,(long)self.pageIndex];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary getAllMsgWithType_url],dataStr]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary getAllMsgWithType_url],dataStr]
                              success:^(id data) {
                                  if ([data count] == 0) {
                                      [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                  }else{
                                      if (weakSelf.pageIndex == 0) {
                                          [weakSelf.dataArray removeAllObjects];
                                      }
                                      weakSelf.pageIndex ++;
                                      [weakSelf.dataArray addObjectsFromArray:[[MessageDetailModel alloc] getData:data]];
                                      [weakSelf.tableView reloadData];
                                  }
                                  [PCMBProgressHUD hideWithView:weakSelf.view.window];
        
    }
                              failure:^(NSError *error) {
                                  [PCMBProgressHUD hideWithView:weakSelf.view.window];
        
    }];
}


- (void)callHttpForReadAllMessage{
    __weak MessageDetailTableViewController *weakself = self;
    [PCMBProgressHUD showLoadingImageInView:self.view.window isResponse:NO];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@type=%ld",[URLDictionary redAllMsg_url],(long)self.keyValue]);
    [CallHttpManager postWithUrlString:[NSString stringWithFormat:@"%@type=%ld",[URLDictionary redAllMsg_url],(long)self.keyValue] parameters:nil success:^(id data) {
        [PCMBProgressHUD hideWithView:weakself.view.window];
        DefaultModel *resultMsg = [[DefaultModel alloc] getData:data];
        if (resultMsg.Success) {
            [weakself.tableView.mj_header beginRefreshing];
        }else{
            [PCMBProgressHUD showLoadingTipsInView:weakself.view title:@"失败" detail:resultMsg.Content withIsAutoHide:YES];
        }
    } failure:^(NSError *error) {
        [PCMBProgressHUD hideWithView:weakself.view.window];
    }];
}

- (void)callHttpForReadMessage:(NSIndexPath *)indexPath{
    __weak MessageDetailTableViewController *weakself = self;
    MessageDetailModel *item = (MessageDetailModel *)self.dataArray[indexPath.row];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@id=%u",[URLDictionary readMsg_url],item.ID]);
    [PCMBProgressHUD showLoadingImageInView:self.view.window isResponse:NO];
    [CallHttpManager postWithUrlString:[NSString stringWithFormat:@"%@id=%u",[URLDictionary readMsg_url],item.ID] parameters:nil success:^(id data) {
        [PCMBProgressHUD hideWithView:weakself.view.window];
        DefaultModel *resultMsg = [[DefaultModel alloc] getData:data];
        if (resultMsg.Success) {
            [weakself.dataArray removeObjectAtIndex:indexPath.row];
            [weakself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationLeft)];
        }else{
            [PCMBProgressHUD showLoadingTipsInView:weakself.view title:@"失败" detail:resultMsg.Content withIsAutoHide:YES];
        }
    } failure:^(NSError *error) {
        [PCMBProgressHUD hideWithView:weakself.view.window];
    
    }];
}
#pragma mark - segment delegate
- (void)segmentCustomView:(SegmentCustomStyleManager *)segmentCustomView index:(NSInteger)index{
    self.segmentViewSelectedIndex = index;
    [self callHttpForMessageWithSelectedIndex];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageDetailTableViewCell class])];
    if (cell == nil) {
        cell = [[MessageDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MessageDetailTableViewCell class])];
    }
    HHCodeLog(@"%lu",(unsigned long)self.dataArray.count);
    MessageDetailModel *item = (MessageDetailModel *)self.dataArray[indexPath.row];
    [cell loadDataWithVin:item.vin
                     imei:item.imei
            alarmShopName:item.AlarmCurrentShopName
                 shopName:item.AlarmShopName
                  carType:item.carType
                 carColor:item.carColor
              shopTypeStr:item.shopTypeDisplay
                     time:[NSString formatDateTimeForCN:item.createdAt]
                   status:item.AlarmFenceStateDisplay
               withStatus:[item.AlarmFenceState integerValue]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showMapView:(MessageDetailModel *)self.dataArray[indexPath.row]];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segmentViewSelectedIndex == 0) {
         return YES;
    }
     return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self callHttpForReadMessage:indexPath];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"标为已读";
}
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - mapview delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *result = nil;
    
    if([annotation isKindOfClass:[MyAnnotation class]] == NO)
    {
        return result;
    }
    
    if([mapView isEqual:self.mapView] == NO)
    {
        return result;
    }
    
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc]init];
        annotationView.image = [UIImage imageNamed:@"icon_annotation"];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    return result;
    
}

#pragma mark -action
- (void)showMapView:(MessageDetailModel *)item{
    if (_coverView == nil) {
        [self.view.window addSubview:self.coverView];
        self.coverView.alpha = 0.8;
    }else{
        self.coverView.alpha = 0.8;
    }
    if (_mapView == nil) {
        HHCodeLog(@"_mapView == nil");
    }
    [self.view.window insertSubview:self.mapView aboveSubview:self.coverView];
    self.mapView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    [UIView animateWithDuration:0.8 animations:^{
        self.mapView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(item.lat, item.lng) zoomLevel:9 animated:YES];
        [self.mapView addAnnotation:[[MyAnnotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(item.lat, item.lng) title:@"当前位置" subTitle:item.imei]];
        
    }];
    
    
}
- (void)closeSubView{
    [UIView animateWithDuration:0.5 animations:^{
        self.mapView.transform = CGAffineTransformMakeScale(0.05, 0.05);
    } completion:^(BOOL finished) {
        _mapView.delegate = nil;
        [_mapView removeFromSuperview];
        _mapView = nil;
        self.coverView.alpha = 0.f;
    }];
    
}

- (void)enlargeMap:(UIButton *)sender{
    if (sender.selected) {
        CGRect newFrame = self.mapView.frame;
        newFrame.size = CGSizeMake(SCREEN_WIDTH - 40, SCREEN_HEIGHT/2);
        [UIView animateWithDuration:0.2 animations:^{
            self.mapView.frame = newFrame;
            self.mapView.center = self.view.window.center;
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
        }];
    }
    
    sender.selected = !sender.selected;
}
- (void)readAllMsg{
    __weak MessageDetailTableViewController *weakself = self;
    [UIAlertViewManager actionSheettWithTitle:@"全部已读？" message:@"将删除全部未读消息！" withCancelButton:YES actionTitles:@[@"确认全读"] actionHandler:^(UIAlertAction *action, NSUInteger index) {
        if (index == 0) {
            [weakself callHttpForReadAllMessage];
        }
    }];
}



#pragma mark - DZNEmptyDataSetDelegate Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"icon_noData"];
}



// 标题文本，富文本样式
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无报警信息";
    
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


// 是否 允许上下滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}

@end

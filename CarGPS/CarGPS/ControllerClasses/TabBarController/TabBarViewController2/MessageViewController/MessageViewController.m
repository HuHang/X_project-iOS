//
//  MessageViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//
static NSInteger segmentViewHeight = 40;

#import "MessageViewController.h"
#import "SegmentCustomStyleManager.h"
#import "MessageTypeTableViewCell.h"
#import "MessageDetailTableViewController.h"
#import "MessageTypeModel.h"

@interface MessageViewController ()<SegmentCustomViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) SegmentCustomStyleManager *segmentView;
@property NSInteger segmentViewSelectedIndex;
@property BOOL viewIsFirstLoad;
@property (nonatomic,strong)NSArray *dataArray;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewIsFirstLoad = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"消息";
    self.dataArray = [NSArray new];
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.tableView];
    self.segmentViewSelectedIndex = 0;
    self.tableView.mj_header = [HLGifHeader headerWithRefreshingBlock:^{
        [self setMJRefreshHeader];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.viewIsFirstLoad) {
        self.viewIsFirstLoad = NO;
        [self.tableView.mj_header beginRefreshing];
    }else{
        
    }
}

- (void)setMJRefreshHeader{
    __weak MessageViewController *weakself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself callHttpWithSelectedIndex];
        [weakself.tableView.mj_header endRefreshing];
    });
}

- (void)callHttpWithSelectedIndex{
    switch (self.segmentViewSelectedIndex) {
        case 0:
            [self callHttpForFavoriteMessageTypeList];
            break;
        case 1:
            [self callHttpForAllMessageTypeList];
            break;
        default:
            break;
    }
}
#pragma mark - view
- (SegmentCustomStyleManager *)segmentView{
    if (_segmentView == nil) {
        NSArray *arrar = [NSArray arrayWithObjects:@"订阅",@"全部", nil];
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

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentViewHeight+64, SCREEN_WIDTH, SCREEN_HEIGHT_WithNavAndTabBar - segmentViewHeight) style:(UITableViewStylePlain)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [UIView new];
        
    }
    return _tableView;
}


#pragma mark - Http
- (void)callHttpForAllMessageTypeList{
    HHCodeLog(@"%@",[URLDictionary getMessageTypeList_url]);
    __weak MessageViewController *weakSelf = self;
    [CallHttpManager getWithUrlString:[URLDictionary getMessageTypeList_url]
                              success:^(id data) {
                                  weakSelf.dataArray = [[MessageTypeModel alloc] getData:data];
                                  [weakSelf.tableView reloadData];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}
- (void)callHttpForFavoriteMessageTypeList{
    HHCodeLog(@"%@",[URLDictionary getFavoriteMessageTypeList_url]);
    __weak MessageViewController *weakSelf = self;
    [CallHttpManager getWithUrlString:[URLDictionary getFavoriteMessageTypeList_url]
                              success:^(id data) {
                                  weakSelf.dataArray = [[MessageTypeModel alloc] getData:data];
                                  [weakSelf.tableView reloadData];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}

- (void)callHttpForSubAndDissubMsg:(NSString *)urlStr alarmType:(NSInteger)alarmType{
    __weak MessageViewController *weakself = self;
    [CallHttpManager postWithUrlString:[NSString stringWithFormat:@"%@alarmType=%ld",urlStr,(long)alarmType] parameters:nil success:^(id data) {
        if (data[@"Success"]) {
            switch (self.segmentViewSelectedIndex) {
                case 0:
                    [self callHttpForFavoriteMessageTypeList];
                    break;
                case 1:
                    [self callHttpForAllMessageTypeList];
                    break;
                default:
                break;
            }
        }
        [PCMBProgressHUD showLoadingTipsInView:weakself.view title:data[@"Content"] detail:nil withIsAutoHide:YES];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - segment delegate
- (void)segmentCustomView:(SegmentCustomStyleManager *)segmentCustomView index:(NSInteger)index{
    self.segmentViewSelectedIndex = index;
    [self callHttpWithSelectedIndex];

}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageTypeTableViewCell class])];
    MessageTypeModel *item = (MessageTypeModel *)self.dataArray[indexPath.row];;
    if (cell == nil) {
        cell = [[MessageTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MessageTypeTableViewCell class])];
    }
    
    [cell loadDataWithMessageType:item.KeyValue messageName:item.KeyStr isSubscribed:item.isFavorite meaageCount:item.Count];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    __weak MessageViewController *weakself = self;
    cell.subscribeButtonTapAction = ^(UIButton *sender) {
        if (!sender.selected) {
            [weakself callHttpForSubAndDissubMsg:[URLDictionary subscribeMessageTypeList_url] alarmType:item.KeyValue];
            
        }else{
            [weakself callHttpForSubAndDissubMsg:[URLDictionary unSubscribeMessageTypeList_url] alarmType:item.KeyValue];
        }
    };

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segmentViewSelectedIndex == 0) {
        return 90.f;
    }
    return 70.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageTypeModel *item = (MessageTypeModel *)self.dataArray[indexPath.row];

    MessageDetailTableViewController *detailView = [[MessageDetailTableViewController alloc] init];
    detailView.titleName = item.KeyStr;
    detailView.keyValue = item.KeyValue;
    [self.navigationController pushViewController:detailView animated:YES];
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UIImage imageNamed:@"icon_noData"];
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
    NSString *text = @"没有订阅内容";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

// 标题文本下面的详细描述，富文本样式
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"订阅您感兴趣的消息种类，您将在这里第一时间阅读并处理！";
    
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


// 是否 允许上下滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}



@end

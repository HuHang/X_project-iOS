//
//  InventoryDetailViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/16.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "InventoryDetailViewController.h"
#import "PNChart.h"

@interface InventoryDetailViewController ()<PNChartDelegate>
@property (nonatomic) PNPieChart *pieChart;
@end

@implementation InventoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createChartView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadDataForPieChart];
}

#pragma mark -view
- (PNPieChart *)pieChart{
    if (_pieChart == nil) {
        _pieChart = [[PNPieChart alloc] init];
        _pieChart.descriptionTextColor = [UIColor whiteColor];
        _pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        _pieChart.descriptionTextShadowColor = [UIColor clearColor];
        _pieChart.showAbsoluteValues = NO;
        _pieChart.showOnlyValues = NO;
        _pieChart.enableMultipleSelection = YES;
        _pieChart.legendStyle = PNLegendItemStyleStacked;
        _pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        _pieChart.delegate = self;
        
    }
    return _pieChart;
}

- (void)createChartView{
    UIView *ChartView1 = [[UIView alloc] init];
    [self.view addSubview:ChartView1];
    [ChartView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(SCREEN_HEIGHT/2);
    }];
    ChartView1.backgroundColor = [UIColor whiteColor];
    
    
    [ChartView1 addSubview:self.pieChart];
    [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2));
        make.center.mas_equalTo(0);
    }];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(0, 0, legend.frame.size.width, legend.frame.size.height)];
    [ChartView1 addSubview:legend];
    [legend mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pieChart);
        make.top.equalTo(self.pieChart.mas_bottom);
    }];
    
    
}

#pragma mark - data
- (void)loadDataForPieChart{
    [self.pieChart updateChartData:@[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen],
                                     [PNPieChartDataItem dataItemWithValue:20 color:PNFreshGreen description:@"WWDC"],
                                     [PNPieChartDataItem dataItemWithValue:40 color:PNDeepGreen description:@"GOOG I/O"],
                                     ]];
    self.pieChart.displayAnimated = YES;
    [self.pieChart strokeChart];
    
}

- (void)userClickedOnPieIndexItem:(NSInteger)barIndex {
    
    NSLog(@"Click on bar %@", @(barIndex));
}
@end

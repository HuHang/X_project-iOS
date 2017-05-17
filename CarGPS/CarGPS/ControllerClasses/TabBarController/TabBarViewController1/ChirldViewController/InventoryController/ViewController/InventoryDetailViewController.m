//
//  InventoryDetailViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/16.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "InventoryDetailViewController.h"
#import "ChartsManager.h"

@interface InventoryDetailViewController ()
@property (nonatomic,strong) PieChartView *pieChart;
@end

@implementation InventoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createChartView];
}

#pragma mark -view
- (PieChartView *)pieChart{
    if (_pieChart == nil) {
        _pieChart = [[PieChartView alloc] init];
        _pieChart.backgroundColor = [UIColor whiteColor];
        [_pieChart setExtraOffsetsWithLeft:30 top:0 right:30 bottom:0];//饼状图距离边缘的间隙
        _pieChart.usePercentValuesEnabled = YES;//是否根据所提供的数据, 将显示数据转换为百分比格式
        _pieChart.dragDecelerationEnabled = YES;//拖拽饼状图后是否有惯性效果
        _pieChart.drawSliceTextEnabled = YES;//是否显示区块文本
        
        _pieChart.drawHoleEnabled = YES;//饼状图是否是空心
        _pieChart.holeRadiusPercent = 0.5;//空心半径占比
        _pieChart.holeColor = [UIColor clearColor];//空心颜色
        _pieChart.transparentCircleRadiusPercent = 0.52;//半透明空心半径占比
        _pieChart.transparentCircleColor = [UIColor colorWithRed:210/255.0 green:145/255.0 blue:165/255.0 alpha:0.3];//半透明空心的颜色
        
        if (_pieChart.isDrawHoleEnabled == YES) {
            _pieChart.drawCenterTextEnabled = YES;//是否显示中间文字
            //普通文本
            //        _pieChart.centerText = @"饼状图";//中间文字
            //富文本
            NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@"饼状图"];
            [centerText setAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16],
                                        NSForegroundColorAttributeName: [UIColor orangeColor]}
                                range:NSMakeRange(0, centerText.length)];
            _pieChart.centerAttributedText = centerText;
        }
        
        _pieChart.descriptionText = @"示例";
        _pieChart.descriptionFont = [UIFont systemFontOfSize:10];
        _pieChart.descriptionTextColor = [UIColor grayColor];
        
        _pieChart.legend.maxSizePercent = 1;//图例在饼状图中的大小占比, 这会影响图例的宽高
        _pieChart.legend.formToTextSpace = 5;//文本间隔
        _pieChart.legend.font = [UIFont systemFontOfSize:10];//字体大小
        _pieChart.legend.textColor = [UIColor grayColor];//字体颜色
        _pieChart.legend.position = ChartLegendPositionBelowChartCenter;//图例在饼状图中的位置
        _pieChart.legend.form = ChartLegendFormCircle;//图示样式: 方形、线条、圆形
        _pieChart.legend.formSize = 12;//图示大小
        
    }
    return _pieChart;
}


- (void)createChartView{
    
//    UIView *ChartView1 = [[UIView alloc] init];
    
    UIView *ChartView2 = [[UIView alloc] init];
    [self.view addSubview:ChartView2];
    [ChartView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(SCREEN_HEIGHT/2);
    }];
    ChartView2.backgroundColor = [UIColor whiteColor];
    UILabel *pieTitleLable = [UILabel labelWithString:@"盘点差异统计图" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(16.f)];
    [ChartView2 addSubview:self.pieChart];
    [ChartView2 addSubview:pieTitleLable];
    [pieTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    [_pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH *3/4, SCREEN_WIDTH *3/4));
        make.centerX.mas_equalTo(0);
        make.top.equalTo(pieTitleLable.mas_bottom);
    }];
    
    _pieChart.data = [self setPieData];
    [_pieChart animateWithXAxisDuration:1.0f easingOption:ChartEasingOptionEaseOutExpo];
    
    
}

#pragma mark - data
- (PieChartData *)setPieData{
    double mult = 100;
    int count = 3;//饼状图总共有几块组成
    //Y 值
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    NSArray *item = @[@"盘点项",@"未盘车辆",@"多盘车辆"];
    for (int i = 0; i < count; i++) {
        double randomVal = arc4random_uniform(mult + 1);
        PieChartDataEntry *entry = [[PieChartDataEntry alloc] initWithValue:randomVal label:item[i]];
        [yVals addObject:entry];
    }
    //标注
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:yVals label:@""];
    dataSet.drawValuesEnabled = YES;//是否绘制显示数据
    //颜色
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    dataSet.colors = colors;
    
    dataSet.sliceSpace = 0;//相邻区块之间的间距
    dataSet.selectionShift = 8;//选中区块时, 放大的半径
    dataSet.xValuePosition = PieChartValuePositionInsideSlice;//名称位置
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;//数据位置
    //数据与区块之间的用于指示的折线样式
    dataSet.valueLinePart1OffsetPercentage = 0.85;//折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
    dataSet.valueLinePart1Length = 0.5;//折线中第一段长度占比
    dataSet.valueLinePart2Length = 0.4;//折线中第二段长度最大占比
    dataSet.valueLineWidth = 1;//折线的粗细
    dataSet.valueLineColor = [UIColor brownColor];//折线颜色

    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    [data setValueTextColor:[UIColor brownColor]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    return data;
}

@end

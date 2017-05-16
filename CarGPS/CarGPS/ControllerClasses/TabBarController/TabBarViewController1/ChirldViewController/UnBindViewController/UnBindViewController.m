//
//  UnBindViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/5/11.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "UnBindViewController.h"
#import "ScanViewController.h"
#import "DefaultModel.h"
#import "NHMainHeader.h"
#import "QuickSearchModel.h"

@interface UnBindViewController ()<ScanViewControllerDelegate,NHAutoCompleteTextFieldDataSourceDelegate, NHAutoCompleteTextFieldDataFilterDelegate>
@property (nonatomic,strong)NHAutoCompleteTextField *unBindStrTextField;
@property (nonatomic,strong)NSMutableArray *searchDataArray;
@end

@implementation UnBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"解绑";
    self.view.backgroundColor = [UIColor whiteColor];
    [self viewLayout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)searchDataArray{
    if (_searchDataArray == nil) {
        _searchDataArray = [[NSMutableArray alloc] init];
    }
    return  _searchDataArray;
}

- (void)viewLayout{
    UIButton *scan_vinButton = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"photored" withSelectedImage:nil];
    self.unBindStrTextField = [[NHAutoCompleteTextField alloc] initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH-120, 30)];
    [self.unBindStrTextField setDropDownDirection:NHDropDownDirectionDown];
    [self.unBindStrTextField setDataSourceDelegate:self];
    [self.unBindStrTextField setDataFilterDelegate:self];
    self.unBindStrTextField.suggestionTextField.placeholder = @"输入VIN码或IMEI码";
    
    UIButton *unBindButton = [UIButton buttonWithString:@"确定解绑" withBackgroundColor:ZDRedColor withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(14.f)];
    
    UIView *lineView01 = [self lineView];
    [self.view addSubview:self.unBindStrTextField];
    [self.view addSubview:lineView01];
    [self.view addSubview:scan_vinButton];
    [self.view addSubview:unBindButton];

    
    [self.unBindStrTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(SCREEN_HEIGHT/4 + 44);
    }];
    [scan_vinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 20));
        make.centerY.equalTo(self.unBindStrTextField);
        make.left.equalTo(self.unBindStrTextField.mas_right);
    }];
    [lineView01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unBindStrTextField);
        make.right.equalTo(scan_vinButton);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.unBindStrTextField.mas_bottom);
    }];
    [unBindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 40));
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-80);
    }];
    
    [scan_vinButton addTarget:self action:@selector(scanData:) forControlEvents:(UIControlEventTouchUpInside)];
    [unBindButton addTarget:self action:@selector(unBindAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    unBindButton.layer.cornerRadius = 20.f;
    unBindButton.layer.masksToBounds = YES;
    
}
- (UIView *)lineView{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromHEX(0xD9D9D9, 1.0);
    return view;
}


#pragma mark - http
- (void)callHttpForUnbind:(NSString *)unBindDataStr{
    __weak UnBindViewController *weakself = self;
    [PCMBProgressHUD showLoadingImageInView:self.view isResponse:NO];
    NSString *urlData = [NSString stringWithFormat:@"imeiOrVin=%@",unBindDataStr];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary unbind_url],urlData]);
    [CallHttpManager postWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary unbind_url],urlData]
                            parameters:nil
                              success:^(id data) {
                                  DefaultModel *result = [[DefaultModel alloc]getData:data];
                                  if (result.Success) {
                                      [PCMBProgressHUD showLoadingTipsInView:weakself.view title:@"该设备已解绑" detail:result.Content withIsAutoHide:YES];
                                  }else{
                                      [PCMBProgressHUD showLoadingTipsInView:weakself.view title:@"错误" detail:result.Content withIsAutoHide:YES];
                                  }
                                  weakself.unBindStrTextField.suggestionTextField.text = @"";
                                  
                              }
                              failure:^(NSError *error) {
                                  [PCMBProgressHUD hideWithView:weakself.view];
                              }];
}
- (void)callHttpForQS:(NSString *)searchString{
    __weak UnBindViewController *weakself = self;
    NSString *dataString = [NSString stringWithFormat:@"searchStr=%@&shopId=&searchType=",searchString];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary QSAll_url],dataString]);
    
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary QSAll_url],dataString]
                              success:^(id data) {
                                  [weakself.searchDataArray removeAllObjects];
                                  for (NSDictionary *dic in data) {
                                      [weakself.searchDataArray addObjectsFromArray:[[[QuickSearchModel alloc] getData:dic] data]];
                                  }
                                  [weakself.unBindStrTextField tableViewReloadData];
                              }
                              failure:^(NSError *error) {
                                  
                              }];
}

#pragma mark - action
- (void)scanData:(UIButton *)sender{
    ScanViewController *scanViewController = [[ScanViewController alloc] init];
    scanViewController.delegate = self;
    [self.navigationController pushViewController:scanViewController animated:YES];
}
- (void)unBindAction{
    if (self.unBindStrTextField.suggestionTextField.text.length == 0) {
        [PCMBProgressHUD showLoadingTipsInView:self.view title:nil detail:@"请输入完整信息!" withIsAutoHide:YES];
    }else{
        [self callHttpForUnbind:self.unBindStrTextField.suggestionTextField.text];
    }
}
#pragma mark - scan delegate

- (void)passDataBack:(NSString *)data{
    self.unBindStrTextField.suggestionTextField.text = data;
    [self callHttpForUnbind:data];
}



#pragma mark - NHAutoComplete DataSource delegate functions

- (NSInteger)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox numberOfRowsInSection:(NSInteger)section
{
    return [self.searchDataArray count];
}

- (UITableViewCell *)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [autoCompleteTextBox.suggestionListView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Create cell, you can use the most recent way to create a cell.
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.textLabel setFont:[UIFont fontWithName:cell.textLabel.font.fontName size:14.f]];
        
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    // Set text
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",self.searchDataArray[indexPath.row]]];
    
    // Clear previously highlighted text
    [cell.textLabel normalizeSubstring:cell.textLabel.text];
    
    // Highlight the selection
    if(autoCompleteTextBox.filterString)
    {
        [cell.textLabel boldSubstring:autoCompleteTextBox.filterString];
        
    }
    
    return cell;
}

#pragma mark - NHAutoComplete Filter data source delegate functions

-(BOOL)shouldFilterDataSource:(NHAutoCompleteTextField *)autoCompleteTextBox
{
    return YES;
}

-(void)autoCompleteTextBox:(NHAutoCompleteTextField *)autoCompleteTextBox didFilterSourceUsingText:(NSString *)text
{
    if ([text length] == 0)
    {
        return;
    }
    [self callHttpForQS:text];
    //
    //    NSPredicate *predCountry = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", @"CountryName", text];
    //
    //    // Want to look the matches in both country name and capital
    //    NSCompoundPredicate *compoundPred = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:[NSArray arrayWithObjects:predCountry, nil]];
    //
    //    NSArray *filteredArr = [[manager dataSource] filteredArrayUsingPredicate:compoundPred];
    //    inUseDataSource = filteredArr;
}

@end

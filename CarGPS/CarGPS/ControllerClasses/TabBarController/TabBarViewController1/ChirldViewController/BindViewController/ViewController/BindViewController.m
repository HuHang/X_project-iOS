//
//  BindViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/3/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "BindViewController.h"
#import "ScanViewController.h"
#import "ShopViewController.h"
#import "SZKCleanCache.h"
#import "SZKImagePickerVC.h"
#import "DefaultModel.h"
#import "QuickSearchModel.h"

#import "NHMainHeader.h"



@interface BindViewController ()<ScanViewControllerDelegate,SZKImagePickerVCDelegate,NHAutoCompleteTextFieldDataSourceDelegate, NHAutoCompleteTextFieldDataFilterDelegate>
@property (nonatomic,strong)NHAutoCompleteTextField *vinTextField;
@property (nonatomic,strong)UIButton *imeiTextButton;
@property (nonatomic,strong)UIButton *titleButton;

@property (nonatomic,strong)NSMutableArray *photoArray;
@property (nonatomic,strong)NSMutableArray *searchDataArray;
@property BOOL isFirstImageView;
@property BOOL isVinEdit;
@property (nonatomic,strong)NSString *vinString;
@property (nonatomic,strong)NSString *imeiString;

@end

@implementation BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstImageView = YES;
    self.isVinEdit = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavigationView];
    [self viewLayout];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:BindShopID] == nil) {
        [self shopChange];
    }else{
        [self.titleButton setTitle:[NSString stringWithFormat:@"%@ ▾",[[NSUserDefaults standardUserDefaults] valueForKey:BindShopName]] forState:(UIControlStateNormal)];
    }
}

- (NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _photoArray;
}
- (NSMutableArray *)searchDataArray{
    if (_searchDataArray == nil) {
        _searchDataArray = [[NSMutableArray alloc] init];
    }
    return  _searchDataArray;
}

#pragma mark - view




- (void)createNavigationView{
    self.titleButton = [UIButton buttonWithString:[NSString stringWithFormat:@"%@ ▾",[[NSUserDefaults standardUserDefaults] valueForKey:BindShopName] ? [[NSUserDefaults standardUserDefaults] valueForKey:BindShopName] : @"选择4S商店"]
                              withBackgroundColor:[UIColor clearColor]
                                withTextAlignment:(NSTextAlignmentCenter)
                                    withTextColor:[UIColor whiteColor]
                                         withFont:SystemFont(14.f)];
    self.navigationItem.titleView = self.titleButton;
    [self.titleButton addTarget:self action:@selector(shopChange) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)viewLayout{
    
    UIButton *scan_vinButton = [UIButton buttonWithBackgroundColor:[UIColor clearColor] withNormalImage:@"photored" withSelectedImage:nil];
//    scan_vinButton.frame = CGRectMake(0, 0, 36, 20);
    
    self.vinTextField = [[NHAutoCompleteTextField alloc] initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH-120, 30)];
    [self.vinTextField setDropDownDirection:NHDropDownDirectionDown];
    [self.vinTextField setDataSourceDelegate:self];
    [self.vinTextField setDataFilterDelegate:self];
    
    
    
//    [UITextField textFieldWithPlaceholder:@"手动输入VIN或扫描VIN码" withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor blackColor] withFont:SystemFont(14.f) withLeftView:nil withRightView:scan_vinButton];
    self.imeiTextButton = [UIButton buttonWithString:@"扫描IMEI码" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor grayColor] withFont:SystemFont(14.f)];
    UIView *lineView01 = [self lineView];
    UIView *lineView02 = [self lineView];
    [self.view addSubview:scan_vinButton];
    [self.view addSubview:self.vinTextField];
    [self.view addSubview:self.imeiTextButton];
    [self.view addSubview:lineView01];
    [self.view addSubview:lineView02];


    
    
    [self.vinTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(SCREEN_HEIGHT/4);
    }];
    [scan_vinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 20));
        make.centerY.equalTo(self.vinTextField);
        make.left.equalTo(self.vinTextField.mas_right);
    }];
    [lineView01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vinTextField);
        make.right.equalTo(scan_vinButton);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.vinTextField.mas_bottom);
    }];


    [self.imeiTextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.vinTextField);
        make.center.mas_equalTo(0);
    }];
    [lineView02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.imeiTextButton);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.imeiTextButton.mas_bottom);
    }];
    
//    self.vinTextField.borderStyle = UITextBorderStyleNone;
    
    [scan_vinButton addTarget:self action:@selector(scanData:) forControlEvents:(UIControlEventTouchUpInside)];
    [_imeiTextButton addTarget:self action:@selector(scanData:) forControlEvents:(UIControlEventTouchUpInside)];
    _imeiTextButton.enabled = YES;
}
- (UIView *)lineView{

    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromHEX(0xD9D9D9, 1.0);
    return view;
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
        [cell setBackgroundColor:[UIColor whiteColor]];
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









#pragma mark - http
- (void)callHttpForCheck{
    __weak BindViewController *weakself = self;
    NSString *urlData = [NSString stringWithFormat:@"shopId=%@&imei=%@&vin=%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:BindShopID]],self.imeiString,self.vinString];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary canBind_url],urlData]);
    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary canBind_url],urlData]
                               success:^(id data) {
                                   DefaultModel *result = [[DefaultModel alloc]getData:data];
                                   if (result.Success) {
                                       [weakself handlePhoto];
                                   }else{
                                       [PCMBProgressHUD showLoadingTipsInView:weakself.view title:@"错误" detail:result.Content withIsAutoHide:YES];
                                       [weakself cleanData];
                                   }
                                   
                               }
                               failure:^(NSError *error) {
                                   [weakself cleanData];
                               }];
}

- (void)callHttpForBind:(NSArray *)uploadPhotoArray{
    __weak BindViewController *weakself = self;
    NSString *urlData = [NSString stringWithFormat:@"shopId=%@&imei=%@&vin=%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:BindShopID]],self.imeiString,self.vinString];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary bind_url],urlData]);
    [PCMBProgressHUD showLoadingImageInView:self.view text:@"上传图片..." isResponse:NO];
    [CallHttpManager uploadWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary bind_url],urlData] parameters:nil dataArray:uploadPhotoArray progress:^(NSProgress *progress) {

        HHCodeLog(@"进度---%@",progress);
    } success:^(id data) {
        [PCMBProgressHUD hideWithView:weakself.view];
        DefaultModel *result = [[DefaultModel alloc] getData:data];
        if (result.Success) {
            [PCMBProgressHUD showLoadingTipsInView:weakself.view.window title:@"绑定成功" detail:result.Content withIsAutoHideTime:2.5f];
        }else{
            [PCMBProgressHUD showLoadingTipsInView:weakself.view.window title:@"失败" detail:result.Content withIsAutoHide:YES];
        }
        [weakself cleanData];
    } failure:^(NSError *error) {
        [PCMBProgressHUD hideWithView:weakself.view];
        [weakself cleanData];
        HHCodeLog(@"error:%@",error);
    }];
    
}

- (void)callHttpForQS:(NSString *)searchString{
    __weak BindViewController *weakself = self;
    NSString *dataString = [NSString stringWithFormat:@"searchStr=%@&shopId=%@&searchType=%@",searchString,[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:BindShopID]],@"vin"];
    HHCodeLog(@"%@",[NSString stringWithFormat:@"%@%@",[URLDictionary QSAll_url],dataString]);

    [CallHttpManager getWithUrlString:[NSString stringWithFormat:@"%@%@",[URLDictionary QSAll_url],dataString]
                              success:^(id data) {
                                  [weakself.searchDataArray removeAllObjects];
                                  for (NSDictionary *dic in data) {
                                      [weakself.searchDataArray addObjectsFromArray:[[[QuickSearchModel alloc] getData:dic] data]];
                                  }
                                  [weakself.vinTextField tableViewReloadData];
    }
                              failure:^(NSError *error) {
        
    }];
}
#pragma mark - action
- (void)scanData:(UIButton *)sender{
    self.vinString = self.vinTextField.suggestionTextField.text;
   
    if ([sender isEqual:self.imeiTextButton]) {
        if (self.vinString.length == 0) {
            [PCMBProgressHUD showLoadingTipsInView:self.view title:nil detail:@"请先输入VIN码" withIsAutoHide:YES];
            return;
        }
        self.isVinEdit = NO;
    }else{
        self.isVinEdit = YES;
    }
    ScanViewController *scanViewController = [[ScanViewController alloc] init];
    scanViewController.delegate = self;
    [self.navigationController pushViewController:scanViewController animated:YES];
}

- (void)shopChange{
    ShopViewController *shopView = [[ShopViewController alloc] init];
    UINavigationController *shopNav = [[UINavigationController alloc] initWithRootViewController:shopView];
    shopView.singleSelection = YES;
    [self presentViewController:shopNav animated:YES completion:nil];
}
- (void)cleanData{
    _imeiTextButton.enabled = YES;
    self.vinTextField.suggestionTextField.text = @"";
    self.imeiTextButton.titleLabel.text = @"扫描IMEI码";
    self.vinString = @"";
    self.imeiString = @"";
    [self.photoArray removeAllObjects];
}

#pragma mark - scan delegate

- (void)passDataBack:(NSString *)data{
    if (self.isVinEdit) {
        self.vinTextField.suggestionTextField.text = data;
        self.vinString = data;
        _imeiTextButton.enabled = YES;
    }else{
        self.imeiTextButton.titleLabel.text = data;
        self.imeiString = data;
        [self callHttpForCheck];
    }
    
}


#pragma mark - photo
- (void)handlePhoto {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    
    //判断摄像头是否可用
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    
    if (!isCamera) {
        return;
    }
    [self presentViewController];

}

#pragma mark----跳转到SZKImagePickerVC
-(void)presentViewController
{
    SZKImagePickerVC *picker=[[SZKImagePickerVC alloc]initWithImagePickerStyle:ImagePickerStyleCamera];
    picker.SZKDelegate=self;
    if ([self.photoArray count] == 0) {
        picker.messageString = @"请拍摄近景";
    }else{
        [PCMBProgressHUD hideWithView:self.view];
        picker.messageString = @"请拍摄远景，完成绑定";
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark----SZKImagePickerVCDelegate
-(void)imageChooseFinish:(UIImage *)image
{
    if ([self.photoArray count] == 1) {
        [self.photoArray addObject:image];
        [self callHttpForBind:self.photoArray];
    }else{
        [self.photoArray addObject:image];
        [PCMBProgressHUD showLoadingImageInView:self.view isResponse:NO];
        [self performSelector:@selector(presentViewController) withObject:nil afterDelay:1.0];
    }
    
    //保存到沙盒中
//    [SZKImagePickerVC saveImageToSandbox:image andImageName:@"image" andResultBlock:^(BOOL success) {
//        NSLog(@"保存成功");
//    }];
}


@end

//
//  ShopViewController.m
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "ShopViewController.h"
#import <MapKit/MapKit.h>
#import "UINavigationBar+Awesome.h"
#import "RATreeView.h"
#import "ShopTableViewCell.h"
#import "ShopModel.h"

@interface ShopViewController ()<RATreeViewDelegate, RATreeViewDataSource,UISearchBarDelegate,UISearchControllerDelegate>
{
    BOOL isbool;
}
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (strong, nonatomic) NSMutableArray *selectArray;
@property (strong, nonatomic)UISearchBar *searchBar;
@property (weak, nonatomic) RATreeView *treeView;
@property (strong, nonatomic)NSMutableArray *allShopArray;
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:ZDRedColor];
//    self.navigationItem.title = @"选择4S商店";
    self.dataArray = [NSArray new];
    self.selectArray = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveChange)];
    [self creatNnavigationView];
    [self createTableView];
    [self callHttpForShopData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)searchResultArray{
    if (_searchResultArray == nil) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    return _searchResultArray;
}
- (NSMutableArray *)allShopArray{
    if (_allShopArray == nil) {
        _allShopArray = [[NSMutableArray alloc] init];
    }
    return _allShopArray;
}

- (UISearchBar * )searchBar{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0 , SCREEN_WIDTH/2, 44);
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (void)creatNnavigationView{
    self.navigationItem.titleView = self.searchBar;
}

- (void)createTableView{
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    self.treeView = treeView;
    self.treeView.frame = self.view.bounds;
    self.treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:treeView atIndex:0];
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    ShopModel *shopData = item;
    NSInteger level = [self.treeView levelForCellForItem:item];
    
    ShopTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopTableViewCell class])];
    if (cell == nil) {
        cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ShopTableViewCell class])];
    }
    [cell setupWithName:shopData.name count:[NSString stringWithFormat:@"%lu",(unsigned long)[shopData.ChildShops count]] addressText:shopData.address level:level is_additionButtonSelected:shopData.is_selected];
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        shopData.is_selected = !shopData.is_selected;
        if (shopData.is_selected) {
            [weakSelf.selectArray addObject:shopData];
        }else{
            [weakSelf.selectArray removeObject:shopData];
        }
    };
    
    
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        if (!isbool) {
            return [self.dataArray count];
        }
        return [self.searchResultArray count];
        
    }
    
    ShopModel *data = item;
    return [data.ChildShops count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    ShopModel *data = item;
    if (item == nil) {
        if (!isbool) {
            return [self.dataArray objectAtIndex:index];
        }
        return [self.searchResultArray objectAtIndex:index];
        
    }
    return data.ChildShops[index];
}

#pragma mark TreeView Delegate methods

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    NSInteger level = [self.treeView levelForCellForItem:item];
    if (level == 0) {
        return 90;
    }
    return 70;
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(nonnull id)item{
    [treeView deselectRowForItem:item animated:YES];
    ShopTableViewCell *cell = (ShopTableViewCell *)[treeView cellForItem:item];
    if ([treeView isCellForItemExpanded:item]) {
        cell.signImageView.image = [UIImage imageNamed:@"icon_shopUnselected"];
    }else{
        cell.signImageView.image = [UIImage imageNamed:@"icon_shopSelected"];
    }
}


#pragma  mark - Http
- (void)callHttpForShopData{
    __weak typeof(self) weakself = self;
    [PCMBProgressHUD showLoadingImageInView:self.view isResponse:YES];
    HHCodeLog(@"%@",[URLDictionary allShop_url]);
    [CallHttpManager getWithUrlString:[URLDictionary allShop_url] success:^(id data) {
        weakself.dataArray = [[ShopModel alloc] getData:data];
        [weakself.allShopArray addObjectsFromArray:weakself.dataArray];
        for (NSInteger i = 0; i < [self.dataArray count]; i ++) {
            ShopModel *parent = (ShopModel *)weakself.dataArray[i];
            parent.ChildShops = [[ShopModel alloc] getData:parent.ChildShops];
            [weakself.allShopArray addObjectsFromArray:parent.ChildShops];
        }
        [weakself.treeView reloadData];
        [PCMBProgressHUD hideWithView:weakself.view];
    } failure:^(NSError *error) {
        [PCMBProgressHUD hideWithView:weakself.view];
    }];
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    //NSLog(@"searchBar ... text.length: %d", text.length);
    
    if(text.length == 0)
    {
        isbool = NO;
        [self.searchResultArray removeAllObjects];
    }
    else
    {
        isbool = YES;
        for (ShopModel *item in self.allShopArray) {
            if ([item.name rangeOfString:text options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound)
            {
                if (![self.searchResultArray containsObject:item]) {
                    [self.searchResultArray addObject:item];
                }
            }
        }
    }
    
    [self.treeView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text=@"";
    isbool= NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.treeView reloadData];
}



#pragma mark - action
-(void)synchronizeForselected{
    if (self.singleSelection) {
        ShopModel *item = (ShopModel *)self.selectArray.firstObject;
        [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%u",item.ID] forKey:BindShopID];
        [[NSUserDefaults standardUserDefaults]setValue:item.name forKey:BindShopName];
    }else{
        NSMutableArray *selectedShopID = [[NSMutableArray alloc] init];
        ShopModel *item = (ShopModel *)self.selectArray.firstObject;
        for (ShopModel *shop in self.selectArray) {
            [selectedShopID addObject:[NSString stringWithFormat:@"%u",shop.ID]];
        }
        NSString *shopIDStr = [selectedShopID componentsJoinedByString:@"&shopids[]="];
        shopIDStr = [@"shopids[]=" stringByAppendingString:shopIDStr];
        [[NSUserDefaults standardUserDefaults]setValue:shopIDStr forKey:DefaultShopID];
        [[NSUserDefaults standardUserDefaults]setValue:item.name forKey:DefaultShopName];
        [[NSUserDefaults standardUserDefaults]setDouble:item.longitude forKey:DefaultLongitude];
        [[NSUserDefaults standardUserDefaults]setDouble:item.latitude forKey:DefaultLatitude];
    }
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (self.delegate) {
        [self.delegate shopChanged];
    }
}

- (void)saveChange{
    if (self.singleSelection && [self.selectArray count] > 1) {
        [PCMBProgressHUD showLoadingTipsInView:self.view title:@"提示" detail:@"您只可选择唯一商店" withIsAutoHide:YES];
        return;
    }
    
    if ([self.selectArray count] > 0) {
        [self synchronizeForselected];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        HHCodeLog(@"fafeqfeq");
    }];
}





@end

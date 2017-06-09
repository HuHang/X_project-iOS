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
    BOOL isSearched;
}
@property (strong, nonatomic) NSArray *dataArray; //所有本库
@property (strong, nonatomic) NSMutableArray *searchResultArray; //搜索结果
@property (strong, nonatomic) NSMutableArray *selectArray; //选择的ShopModel
@property (strong, nonatomic) NSMutableArray *alreadySelectedArray; //上次选择的ShopID
@property (strong, nonatomic) UISearchBar *searchBar;
@property (weak, nonatomic) RATreeView *treeView;
@property (strong, nonatomic) NSMutableArray *allShopArray;//所有商店，搜索源
@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:ZDRedColor];
    self.navigationItem.title = @"选择商店";
    self.dataArray = [NSArray new];
    self.selectArray = [[NSMutableArray alloc] init];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveChange)];

    [self createTableView];
    [self callHttpForShopData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)alreadySelectedArray{
    if (_alreadySelectedArray == nil) {
        if (self.singleSelection) {
            _alreadySelectedArray = [[NSMutableArray alloc] initWithObjects:[[NSUserDefaults standardUserDefaults]valueForKey:BindShopID], nil];
        }else{
            _alreadySelectedArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:DefaultShopIDArray]];
        }
    }
    return _alreadySelectedArray;
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
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return _searchBar;
}


- (void)createRightNavigationItem{
    if (!self.singleSelection) {
        UIButton *button = [UIButton buttonWithString:@"全选" withBackgroundColor:[UIColor clearColor] withTextAlignment:(NSTextAlignmentCenter) withTextColor:[UIColor whiteColor] withFont:SystemFont(16.f)];
        button.frame = CGRectMake(0, 0, 60, 40);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [button addTarget:self action:@selector(allSelect:) forControlEvents:(UIControlEventTouchUpInside)];
        [button setTitle:@"全不选" forState:(UIControlStateSelected)];
    }
}
- (void)createTableView{
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeHeaderView = self.searchBar;
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
//    HHCodeLog(@"treeView reload");
    ShopModel *shopData = item;
    NSInteger level = [self.treeView levelForCellForItem:item];
    
    ShopTableViewCell *cell = [treeView dequeueReusableCellWithIdentifier:NSStringFromClass([ShopTableViewCell class])];
    if (cell == nil) {
        cell = [[ShopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([ShopTableViewCell class])];
    }

    if ([self.alreadySelectedArray containsObject:[NSNumber numberWithInteger:shopData.ID]]) {
        shopData.is_selected = YES;
        [self addObjectWithCheck:shopData];
    }else{
        shopData.is_selected = NO;
    }

    [cell setupWithName:shopData.name count:[shopData.ChildShops count] addressText:shopData.address bankName:shopData.allBankPath shopType:shopData.shopType level:level is_additionButtonSelected:shopData.is_selected is_expanded:[treeView isCellForItemExpanded:item]];
    
    __weak typeof(self) weakSelf = self;
    cell.additionButtonTapAction = ^(id sender){
        shopData.is_selected = !shopData.is_selected;
        
        if (shopData.is_selected) {
            [weakSelf addObjectWithCheck:shopData];
            [weakSelf.alreadySelectedArray addObject:[NSNumber numberWithInteger:shopData.ID]];
        }else{
            [weakSelf.selectArray removeObject:shopData];
            [weakSelf.alreadySelectedArray removeObject:[NSNumber numberWithInteger:shopData.ID]];
        }
        
        if (level == 0) {
            for (ShopModel *parent in weakSelf.dataArray) {
                if ([shopData isEqual:parent]) {
                    for (ShopModel *child in parent.ChildShops) {
                        child.is_selected = shopData.is_selected;
                        if (child.is_selected) {
                            [weakSelf addObjectWithCheck:child];
                            [weakSelf.alreadySelectedArray addObject:[NSNumber numberWithInteger:child.ID]];
                        }else{
                            [weakSelf.selectArray removeObject:child];
                            [weakSelf.alreadySelectedArray removeObject:[NSNumber numberWithInteger:child.ID]];
                        }
                    }
                }
            }
            if (![treeView isCellForItemExpanded:item] && !isSearched) {
                [treeView expandRowForItem:item];
            }
            [treeView reloadRows];
        }
//        [weakSelf.treeView reloadRowsForItems:@[item] withRowAnimation:RATreeViewRowAnimationRight];
    };
    return cell;
}
- (void)addObjectWithCheck:(ShopModel *)objectData{
    if (![self.selectArray containsObject:objectData]) {
        [self.selectArray addObject:objectData];
    }
}



/**
 成员数

 @param treeView treeview
 @param item 成员
 @return 返回每一层包含成员的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        if (!isSearched) {
            return [self.dataArray count];
        }
        return [self.searchResultArray count];
    }
    ShopModel *data = item;
    return [data.ChildShops count];
}


/**
 对象

 @param treeView treeview
 @param index index
 @param item 成员
 @return 子成员数据
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    ShopModel *data = item;
    
    if (item == nil) {
        if (!isSearched) {
            //父类数据
            return [self.dataArray objectAtIndex:index];
        }
        return [self.searchResultArray objectAtIndex:index];
        
    }
//    子类数据
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

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(nonnull id)item{
    [treeView deselectRowForItem:item animated:YES];
    ShopTableViewCell *cell = (ShopTableViewCell *)[treeView cellForItem:item];
    if ([treeView isCellForItemExpanded:item]) {
        cell.signImageView.image = [UIImage imageNamed:@"icon_shopUnselected"];
    }else{
        cell.signImageView.image = [UIImage imageNamed:@"icon_shopSelected"];
    }
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item{
    if (isSearched) {
        return NO;
    }
    return YES;
}

#pragma  mark - Http
- (void)callHttpForShopData{
    __weak typeof(self) weakself = self;
    [PCMBProgressHUD showLoadingImageInView:self.view isResponse:YES];
    HHCodeLog(@"%@",[URLDictionary allShop_url]);
    [CallHttpManager getWithUrlString:[URLDictionary allShop_url] success:^(id data) {
        weakself.dataArray = [[ShopModel alloc] getData:data];
        [weakself.allShopArray addObjectsFromArray:weakself.dataArray];
        for (ShopModel *parent in weakself.dataArray) {
            parent.ChildShops = [[ShopModel alloc] getData:parent.ChildShops];
            [weakself.allShopArray addObjectsFromArray:parent.ChildShops];
        }
        [weakself.treeView reloadData];
        [PCMBProgressHUD hideWithView:weakself.view];
        [weakself createRightNavigationItem];
    } failure:^(NSError *error) {
        [PCMBProgressHUD hideWithView:weakself.view];
        weakself.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(saveChange)];
    }];
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    //NSLog(@"searchBar ... text.length: %d", text.length);
    
    if(text.length == 0)
    {
        isSearched = NO;
        [self.searchResultArray removeAllObjects];
    }
    else
    {
        isSearched = YES;
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
    isSearched= NO;
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.treeView reloadData];
}



#pragma mark - action
-(void)synchronizeForselected{
    if (self.singleSelection) {
        ShopModel *item = (ShopModel *)self.selectArray.firstObject;
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInteger:item.ID] forKey:BindShopID];
        [[NSUserDefaults standardUserDefaults]setValue:item.name forKey:BindShopName];
    }else{
        ShopModel *item = (ShopModel *)self.selectArray.firstObject;
        [[NSUserDefaults standardUserDefaults]setObject:self.alreadySelectedArray forKey:DefaultShopIDArray];
        
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
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        if ([self.dataArray count] == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        [PCMBProgressHUD showLoadingTipsInView:self.view title:@"提示" detail:@"您必须选择至少一家商店" withIsAutoHide:YES];
    }
    
}


- (void)allSelect:(UIButton *)sender{
    if (sender.selected) {
        [self.selectArray removeAllObjects];
        [self.alreadySelectedArray removeAllObjects];
    }else{
        for (ShopModel *shop in [[ShopModel alloc] getData:self.dataArray]) {
            [self.alreadySelectedArray addObject:[NSNumber numberWithInteger:shop.ID]];
            for (ShopModel *item in [[ShopModel alloc] getData:shop.ChildShops]) {
                [self.alreadySelectedArray addObject:[NSNumber numberWithInteger:item.ID]];
            }
        }
    }
    sender.selected = !sender.selected;
    [self.treeView reloadData];
}



@end

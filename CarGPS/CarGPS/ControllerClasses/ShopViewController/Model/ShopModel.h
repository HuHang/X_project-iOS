//
//  ShopModel.h
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

@property (assign, nonatomic)unsigned int ID;
@property (assign, nonatomic)double longitude;
@property (assign, nonatomic)double latitude;
@property (copy, nonatomic)NSString *name;
@property (copy, nonatomic)NSString *address;
@property (strong, nonatomic)NSArray *ChildShops;
@property BOOL is_selected;
- (NSArray *)getData:(NSArray *)array;
@end

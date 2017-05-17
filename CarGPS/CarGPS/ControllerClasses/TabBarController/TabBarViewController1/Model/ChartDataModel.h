//
//  ChartDataModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartDataModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *url;
- (NSArray *)getData:(NSArray *)array;
@end

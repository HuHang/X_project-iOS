//
//  ChartDataModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/17.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartDataModel : NSObject

@property BOOL isOpen;
@property unsigned int chartType;
@property unsigned int headerId;
@property (nonatomic,copy)NSString *header;
@property (nonatomic,copy)NSString *footer;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSArray *summary;
@property (nonatomic,copy)NSString *defaultUrl;
- (NSArray *)getData:(NSArray *)array;
@end

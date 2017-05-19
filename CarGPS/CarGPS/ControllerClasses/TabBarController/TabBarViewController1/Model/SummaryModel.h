//
//  SummaryModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/19.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SummaryModel : NSObject
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *typeDisplay;
@property (nonatomic,copy)NSString *remark;
@property unsigned int dataNr;
- (NSArray *)getData:(NSArray *)array;
@end

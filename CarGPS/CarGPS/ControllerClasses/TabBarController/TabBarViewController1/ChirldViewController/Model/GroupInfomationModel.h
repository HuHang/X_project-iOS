//
//  GroupInfomationModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/22.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfomationModel : NSObject
@property unsigned int Count;
@property (copy, nonatomic)NSString *type;
@property (copy, nonatomic)NSString *name;
- (NSArray *)getData:(NSArray *)array;
@end

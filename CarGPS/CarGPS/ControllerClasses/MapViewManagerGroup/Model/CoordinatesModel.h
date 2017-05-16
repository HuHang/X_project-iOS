//
//  CoordinatesModel.h
//  CarGPS
//
//  Created by Charlot on 2017/4/26.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatesModel : NSObject

@property (assign, nonatomic)double lng;
@property (assign, nonatomic)double lat;
@property (copy, nonatomic)NSString *signalTime;
- (NSArray *)getData:(NSArray *)array;
@end

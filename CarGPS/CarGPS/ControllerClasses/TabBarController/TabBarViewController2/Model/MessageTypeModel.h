//
//  MessageTypeModel.h
//  CarGPS
//
//  Created by Charlot on 2017/5/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTypeModel : NSObject
@property (assign, nonatomic)unsigned int KeyValue;
@property (assign, nonatomic)unsigned int Count;
@property (copy, nonatomic)NSString *KeyStr;
@property BOOL isFavorite;

- (NSArray *)getData:(NSArray *)array;
@end

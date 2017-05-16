//
//  MessageTypeTableViewCell.h
//  CarGPS
//
//  Created by Charlot on 2017/5/5.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKNotificationHub.h"


@interface MessageTypeTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *imageSign;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *subscribeButton;
@property (nonatomic,strong)RKNotificationHub *badge;

@property (nonatomic, copy) void (^subscribeButtonTapAction)(UIButton *sender);

- (void)loadDataWithMessageType:(NSInteger)type messageName:(NSString *)name isSubscribed:(BOOL)is_subscribed meaageCount:(int)count;
@end

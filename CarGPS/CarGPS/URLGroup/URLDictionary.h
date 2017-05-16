//
//  URLDictionary.h
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLDictionary : NSObject


/*--------------------------------------baseURL------------------------------------*/
+ (NSString *) baseURLStr;
+ (NSString *) basePort;


/*--------------------------------------登录------------------------------------*/

+ (NSString *) login_url;
/*--------------------------------------用户相关------------------------------------*/
+ (NSString *) userInfo_url;
/*--------------------------------------设备------------------------------------*/
+ (NSString *) allDevice_url;
+ (NSString *) allMonitorDevice_url;
+ (NSString *) bindDeviceInfo_url;
+ (NSString *) searchDevice_url;
/*--------------------------------------车辆------------------------------------*/
+ (NSString *) allCar_url;
+ (NSString *) searchCar_url;
/*--------------------------------------定位------------------------------------*/
+ (NSString *) lastCoordinate_url;
+ (NSString *) allCoordinate_url;
/*--------------------------------------消息------------------------------------*/
+ (NSString *) getFavoriteMessageTypeList_url;
+ (NSString *) getMessageTypeList_url;

+ (NSString *) subscribeMessageTypeList_url;
+ (NSString *) unSubscribeMessageTypeList_url;

+ (NSString *) getAllMsgWithType_url;
+ (NSString *) readMsg_url;
+ (NSString *) redAllMsg_url;
/*--------------------------------------绑定解绑------------------------------------*/
+ (NSString *) canBind_url;
+ (NSString *) bind_url;
+ (NSString *) unbind_url;
/*--------------------------------------商店------------------------------------*/

+ (NSString *) allShop_url;

/*--------------------------------------搜索------------------------------------*/
+ (NSString *) QSAll_url;


+ (NSString *) getByGPS_url;
+ (NSString *) allMessage_url;
@end

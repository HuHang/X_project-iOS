//
//  URLDictionary.m
//  CarGPS
//
//  Created by Charlot on 2017/4/24.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import "URLDictionary.h"

@implementation URLDictionary

/**
 接口
 
 @return URL
 */
+ (NSString *) baseURLStr{
    NSString *baseUrl;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:BaseURL]) {
        baseUrl = [[NSUserDefaults standardUserDefaults]valueForKey:BaseURL];
    }else{
        baseUrl = @"119.254.66.151";
    }
    return baseUrl;
}

/**
 端口
 
 @return port
 */
+ (NSString *) basePort{
    NSString *port;
    if ([[NSUserDefaults standardUserDefaults] valueForKey:BasePORT]) {
        port = [[NSUserDefaults standardUserDefaults] valueForKey:BasePORT];
    }else{
        port = @"80";
    }
    return port;
}

/**
 完整URL
 
 @return baseUrlWithPort
 */
+ (NSString *) baseUrlWithPort{
    return [NSString stringWithFormat:@"http://%@:%@",[self baseURLStr],[self basePort]];
}

/**
 版本 get
 
 @return version_url
 */
+ (NSString *) version_url{
    NSString *url = @"/api/AppDownloads/CheckApkVersion?os=IOS";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}


#pragma mark - API
/**
 登录
 
 @return 登录URL
 */
+ (NSString *) login_url{
    NSString *loginUrl = @"/api/Users/LoginWithInfo?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],loginUrl];
}

/**
 dashboard
 
 @return dashboard
 */
+ (NSString *) dashBoard_url{
    NSString *loginUrl = @"/api/dashboards/Dashboard";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],loginUrl];
}

/**
 所有商店
 
 @return 所有商店
 */
+ (NSString *) allShop_url{
    NSString *url = @"/api/Shops/GetAllWithChild";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 所有绑定设备
 shopId=*&pageIndex=*&isBind=*
 @return 所有设备
 */
+ (NSString *) allDevice_url{
    NSString *url = @"/api/devices/AllByShopIdsWithPageWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 设备搜索
 string searchStr: 白,
 int? shopIds[] : 127,
 int? shopIds[] : 110,
 string isBind: false,
 int pageIndex: 0
 
 @return 设备搜索
 */
+ (NSString *) searchDevice_url{
    NSString *url = @"/api/devices/FuzzySearchWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 设备统计
 shopIds
 @return 设备统计
 */
+ (NSString *) groupDeviceCount_url{
    NSString *url = @"/api/devices/GroupDeviceCountWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}



/**
 监控

 @return 监控
 */
+ (NSString *) allMonitorDevice_url{
    NSString *url = @"/api/Shops/GetBindedGroupByShopsWithListAndLimit";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 测试
 
 @return 测试监控
 */
+ (NSString *) test_allMonitorDevice_url{
    NSString *url = @"/api/Shops/GetBindedGroupByShopsWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}
/**
 绑定检查 get
 int shopId: 127,
 string imei: 868120146773707,
 string vin:LFPM4ACP1G1A73874
 @return 是否可以绑定
 */
+ (NSString *) canBind_url{
    NSString *url = @"/api/devices/CanBind?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 绑定 post
 int shopId: 127,
 string imei: 868120146773707,
 string vin:LFPM4ACP1G1A73874,
 两张图片
 @return 绑定
 */
+ (NSString *) bind_url{
    NSString *url = @"/api/devices/BindWithPic?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 解绑
 
 @return 解绑
 */
+ (NSString *) unbind_url{
    NSString *url = @"/api/Devices/UnBind?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 干嘛的？
 
 @return 所有设备
 */
+ (NSString *) allMessage_url{
    NSString *url = @"/api/cars/allByShopId?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 绑定信息
 
 @return 绑定信息
 */
+ (NSString *) bindDeviceInfo_url{
    NSString *url = @"/api/CarDeviceBinds/GetBindInfo?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 实时位置
 
 @return 实时位置
 */
+ (NSString *) lastCoordinate_url{
    NSString *url = @"/api/Devices/GetLastest?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 所有位置
 
 @return 所有位置
 */
+ (NSString *) allCoordinate_url{
    NSString *url = @"/api/Devices/GetGpsList?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}



/**
 干嘛的？
 
 @return 所有设备
 */
+ (NSString *) getByGPS_url{
    NSString *url = @"/api/Shops/GetByGps?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}
/**
 订阅消息分类列表
 
 @return 订阅消息分类
 */
+ (NSString *) getFavoriteMessageTypeList_url{
    NSString *url = @"/api/Messages/FavoriteAlarmMsgTypeCount";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}
/**
 消息分类列表
 
 @return 消息分类
 */
+ (NSString *) getMessageTypeList_url{
    NSString *url = @"/api/Messages/AlarmMsgTypeCount";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}
/**
 订阅消息
 alarmType
 @return 订阅消息
 */
+ (NSString *) subscribeMessageTypeList_url{
    NSString *url = @"/api/FavoriteMessages/Subscribe?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}
/**
    取消订阅消息
 alarmType
 @return 取消订阅消息
 */
+ (NSString *) unSubscribeMessageTypeList_url{
    NSString *url = @"/api/FavoriteMessages/UnSubscribe?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}


/**
 所有消息
 type 是可以为空的，如果为空则代表 获取所有类型的报警
 isRead 可以为空， 为空则代表获取所有的报警消息
 isRead = true, 代表已读消息
 isRead = false 代表未读消息
 pageIndex = 1
 @return 所有消息
 */
+ (NSString *) getAllMsgWithType_url{
    NSString *url = @"/api/Messages/UnReadAlarmMsgWithPage?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 读消息
 id=
 @return 读消息
 */
+ (NSString *) readMsg_url{
    NSString *url = @"/api/Messages/ReadAlarmMsg?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 读所有消息
 type=
 @return 读所有消息
 */
+ (NSString *) redAllMsg_url{
    NSString *url = @"/api/Messages/ReadAllAlarmMsg?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}


/**
 所有车辆
 shopId=*&pageIndex=*&isBind=*
 @return 所有车辆
 */
+ (NSString *) allCar_url{
    NSString *url = @"/api/cars/AllByShopIdsWithPageWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 车辆搜索
 string searchStr: 白,
 int? shopIds[] : 127,
 int? shopIds[] : 110,
 string isBind: false,
 int pageIndex: 0

 @return 车辆搜索
 */
+ (NSString *) searchCar_url{
    NSString *url = @"/api/cars/FuzzySearchWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 车辆统计
 shopIds
 @return 车辆统计
 */
+ (NSString *) groupCarsCount_url{
    NSString *url = @"/api/cars/GroupCarsCountWithList";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

/**
 用户信息
 
 @return 用户信息
 */
+ (NSString *) userInfo_url{
    NSString *url = @"/api/Users/GetUserDetail?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}


/**
 快速搜索vin
 string searchStr: 898,
 int? shopId: 127
 string searchType: vin/imei/""
 @return 快速搜索vin
 */
+ (NSString *) QSAll_url{
    NSString *url = @"/api/globals/QSVINOrIMEI?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}



/**
 dashboard
 enterStock
 @return 快速搜索vin
 */
+ (NSString *) getFirstDashboard_url{
    NSString *url = @"/api/Report_DailySupervisions/GetReportByType?";
    return  [NSString stringWithFormat:@"%@%@",[self baseUrlWithPort],url];
}

@end

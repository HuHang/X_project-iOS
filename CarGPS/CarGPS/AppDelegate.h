//
//  AppDelegate.h
//  CarGPS
//
//  Created by Charlot on 2017/3/8.
//  Copyright © 2017年 Charlot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

//@property  BOOL isForceLandscape;
//@property  BOOL isForcePortrait;
@end


//
//  PCMBProgressHUD.h
//  PixCarApp
//
//  Created by Jing on 2017/3/9.
//  Copyright © 2017年 fei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MBProgressHUD;

@interface PCMBProgressHUD : NSObject

/**
 菊花转加载
 
 @param view     需要显示在的View层
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingImageInView:(UIView *)view isResponse:(BOOL)isResponse ;

/**
 菊花转带文字加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingImageInView:(UIView *)view text:(NSString *)text isResponse:(BOOL)isResponse ;

/**
 菊花转带文字和详细描述加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param detail     需要显示的描述文字
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingImageInView:(UIView *)view text:(NSString *)text detail:(NSString *)detail isResponse:(BOOL)isResponse ;

/**
 圆圈带文字加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingCircleInView:(UIView *)view text:(NSString *)text isResponse:(BOOL)isResponse ;

/**
 进度条文字加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param isResponse 加载期间是否可以响应
 */
+ (MBProgressHUD *)showLoadingBarInView:(UIView *)view text:(NSString *)text isResponse:(BOOL)isResponse ;

/**
 信息提示（在1.5S后自动隐藏）
 
 @param view 需要显示的view视图
 @param title 需要显示的文字
 @param detail 需要显示的描述文字
 @param isAutoHide 是否自动隐藏
 */
+ (void)showLoadingTipsInView:(UIView *)view title:(NSString *)title detail:(NSString *)detail withIsAutoHide:(BOOL)isAutoHide ;

/**
 隐藏动画
 
 @param animated 隐藏动画
 */
+ (void)hideWithView:(UIView *)view ;

@end

//
//  PCMBProgressHUD.m
//  PixCarApp
//
//  Created by Jing on 2017/3/9.
//  Copyright © 2017年 fei. All rights reserved.
//

#import "PCMBProgressHUD.h"
#import "MBProgressHUD.h"

@implementation PCMBProgressHUD
/**
 菊花转加载
 
 @param view       需要显示在的View层
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingImageInView:(UIView *)view isResponse:(BOOL)isResponse {
    
    if (view == nil) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    // 响应
    hud.userInteractionEnabled = !isResponse;
    // 设置展示颜色
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
}

/**
 菊花转带文字加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingImageInView:(UIView *)view text:(NSString *)text isResponse:(BOOL)isResponse {
    
    if (view == nil) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.label.text = text;
    // 响应
    hud.userInteractionEnabled = !isResponse;
    
}

/**
 菊花转带文字和详细描述加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param detail     需要显示的描述文字
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingImageInView:(UIView *)view text:(NSString *)text detail:(NSString *)detail isResponse:(BOOL)isResponse {
    
    if (view == nil) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.label.text = text;
    hud.detailsLabel.text = detail;
    // 响应
    hud.userInteractionEnabled = !isResponse;
}

/**
 圆圈带文字加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param isResponse 加载期间是否可以响应
 */
+ (void)showLoadingCircleInView:(UIView *)view text:(NSString *)text isResponse:(BOOL)isResponse {
    
    if (view == nil) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        
    }
    // 响应
    hud.userInteractionEnabled = !isResponse;
    // 设置模式和文字
    hud.mode = MBProgressHUDModeDeterminate;
    hud.label.text = text;
}

/**
 进度条文字加载
 
 @param view       需要显示的view视图
 @param text       需要显示的文字
 @param isResponse 加载期间是否可以响应
 */
+ (MBProgressHUD *)showLoadingBarInView:(UIView *)view text:(NSString *)text isResponse:(BOOL)isResponse {
    
    if (view == nil) {
        return nil;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        
    }
    // 响应
    hud.userInteractionEnabled = !isResponse;
    // 设置模式和文字
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    hud.label.text = text;
    return hud;
}

/**
 信息提示（在1.5S后自动隐藏）
 
 @param view 需要显示的view视图
 @param title 需要显示的文字
 @param detail 需要显示的描述文字
 @param isAutoHide 是否自动隐藏
 */
+ (void)showLoadingTipsInView:(UIView *)view title:(NSString *)title detail:(NSString *)detail withIsAutoHide:(BOOL)isAutoHide {
    
    if (view == nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    // 设置模式和文字
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [UIColor blackColor];
    if (title) {
        
        hud.label.text = title;
        hud.label.textColor = [UIColor whiteColor];
    }
    if (detail) {
        
        hud.detailsLabel.text = detail;
        hud.detailsLabel.textColor = [UIColor whiteColor];
    }
    if (isAutoHide) {
        
        [hud hideAnimated:YES afterDelay:1.5f];
    }
}

/**
 信息提示（在1.5S后自动隐藏）
 
 @param view 需要显示的view视图
 @param title 需要显示的文字
 @param detail 需要显示的描述文字
 @param time 时间
 */
+ (void)showLoadingTipsInView:(UIView *)view title:(NSString *)title detail:(NSString *)detail withIsAutoHideTime:(CGFloat)time {
    
    if (view == nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    // 设置模式和文字
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.color = [UIColor blackColor];
    if (title) {
        
        hud.label.text = title;
        hud.label.textColor = [UIColor whiteColor];
    }
    if (detail) {
        
        hud.detailsLabel.text = detail;
        hud.detailsLabel.textColor = [UIColor whiteColor];
    }
    if (time) {
        
        [hud hideAnimated:YES afterDelay:time];
    }
}


/**
 隐藏动画
 
 @param view 是否隐藏动画
 */
+ (void)hideWithView:(UIView *)view {
    if (view == nil ) {
        return ;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end

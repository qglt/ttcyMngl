//
//  HUD.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HUDDelgate;

@interface HUD : UIView

@property (nonatomic,weak) __weak id <HUDDelgate>delegate;

/**
 *@method : 缓冲提示
 *
 */
+(void)messageForBuffering;

/**
 *@method : 完成／成功 提示
 *
 */
+(void)messageForComplect;

/**
 *@method :   错误／失败 提示
 *
 */
+(void)messageForFailler;

/**
 *@method :  清除HUD
 *
 */
+(void)clearHudFromApplication;

/**
 *@param  message：提示信息
 *
 */
+(void)message:(NSString *)message;
/**
 *@param  message：提示信息
 *
 *@param  promt： promtView 提示信息上面的活动视图
 */
+(void)message:(NSString *)message promtView:(UIView *)promt;

+(void)message:(NSString *)message delegate:(id <HUDDelgate>)delegate Tag:(NSInteger)tag;

@end

@protocol HUDDelgate <NSObject>

-(void)hud:(HUD *)hud clickedButtonAtIndex:(NSInteger)buttonIndex;

@end



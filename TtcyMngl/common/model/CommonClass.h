//
//  CommonClass.h
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonClass : NSObject

#pragma mark 控件90度旋转及改变控件的字体并返回改变后的UIFont  veie 需要旋转的控件 uiFont 控件的UIFont
+(id) setTransformUIView:(UIView *)veie uiFont:(UIFont *)uiFont;
+(id)setTransformuiFont:(UIFont *)uiFont;

#pragma mark 返回url 地址的sid json集合
+(id)getJosnNSArrayUrl:(NSString*)url sid:( NSString *)sid;


#pragma mark设置背景色
+(void)backgroundColorWhitUIView:(UIView *)uiview;

#pragma mark 数据加载提示
+(id)loadingWithViewController:(UIViewController *)con;

#pragma mark 数据加载为空时提示
+(id)nilRemindViewForm:(CGRect)from content:(NSString *)content;



@end

//
//  SHLUILabel.h
//  MyLabel
//
//  Created by showhillLee on 14-3-16.
//  Copyright (c) 2014年 showhilllee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SHLUILabel : UILabel

@property(nonatomic,assign) CGFloat characterSpacing;
@property(nonatomic,assign) CGFloat paragraphSpacing;
@property(nonatomic,assign) long    linesSpacing;

/**
 *@method  传入ttf，otf 等字体文件 和 字体大小
 *
 *@param  fontPath : 字体库地址（ttf等） size : 显示字体大小
 */
- (void)font:(NSString *)fontPath size:(CGFloat)size;

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width;

@end

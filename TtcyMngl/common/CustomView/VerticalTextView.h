//
//  VerticalTextView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-3.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerticalTextView : UITextView

@property (nonatomic,strong)NSString * showText;

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

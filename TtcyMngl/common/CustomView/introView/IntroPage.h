//
//  IntroPage.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroPage : NSObject

@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) UIImage *titleImage;
@property (nonatomic, assign) CGFloat imgPositionY;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIFont *titleFont;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titlePositionY;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) UIFont *descFont;
@property (nonatomic, retain) UIColor *descColor;
@property (nonatomic, assign) CGFloat descPositionY;
@property (nonatomic, retain) UIView *customView;

+ (IntroPage *)page;
+ (IntroPage *)pageWithCustomView:(UIView *)customV;

@end

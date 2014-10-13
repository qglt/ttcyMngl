//
//  UIButton+menuItem.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-21.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (menuItem)

-(UIButton *)initWithFrame:(CGRect)frame Tag:(NSInteger)tag Title:(NSString *)title
                     Image:(NSString *)imageName;

@end

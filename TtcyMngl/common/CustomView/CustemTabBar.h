//
//  CustemTabBar.h
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MenuItem.h"

@interface CustemTabBar : UIView

@property (nonatomic, copy) void (^itemClick)(MenuItem *item);

@property (nonatomic,strong)NSMutableArray * menuItems;

-(CustemTabBar *)initWithFrame:(CGRect)frame andItems:(NSArray *)itemsArray;

-(void)setSelectedWithItemTag:(NSUInteger)itemTag;

@end

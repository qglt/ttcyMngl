//
//  CustemTabBar.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "CustemTabBar.h"
#import "Utils.h"

@interface CustemTabBar ()

@end

@implementation CustemTabBar

-(CustemTabBar *)initWithFrame:(CGRect)frame andItems:(NSArray *)itemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuItems = [NSMutableArray arrayWithArray:itemsArray];
        [self createItems];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)createItems
{
    CGRect rect = CGRectMake(0, 0, 43.75, 35);
    CGFloat x = kMainScreenWidth/(self.menuItems.count * 2);
    
    for (int i = 0; i<_menuItems.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        button.center = CGPointMake(x, self.bounds.size.height/2.0f);
        button.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
        
        [button setTitleColor:[Utils colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        
        [button setTitle:((MenuItem *)_menuItems[i]).title forState:UIControlStateNormal];
        button.tag = ((MenuItem *)_menuItems[i]).tag;
        
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.numberOfLines = 0;
        [button setShowsTouchWhenHighlighted:YES];
        
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).icon] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).h_icon] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        x+=kMainScreenWidth/self.menuItems.count;
    }
}

-(void)menuItemClicked:(UIButton *)sender
{
    _itemClick(_menuItems[sender.tag-10000]);
}

-(void)setSelectedWithItemTag:(NSUInteger)itemTag
{
    for (id elment in self.subviews) {
        if ([elment isKindOfClass:[UIButton class]]) {
//            [elment setBackgroundImage:[Utils createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [elment setSelected:NO];
        }
    }
    UIButton * button = (UIButton *)[self viewWithTag:itemTag];
    [button setSelected:YES];
//    [button setBackgroundImage:[Utils createImageWithColor:[Utils colorWithHexString:@"#0067b7"]] forState:UIControlStateNormal];
}
@end

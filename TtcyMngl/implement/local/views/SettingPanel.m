//
//  SettingPanel.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SettingPanel.h"

@implementation SettingPanel

-(SettingPanel *)initWithFrame:(CGRect)frame andItems:(NSArray *)itemsArray
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
    CGRect rect = CGRectMake(0, 0, 40, self.bounds.size.height);
    CGFloat x = self.bounds.size.width/(self.menuItems.count * 2);
    
    for (int i = 0; i<_menuItems.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        button.center = CGPointMake(x, self.bounds.size.height/2.0f);
        button.tag = ((MenuItem *)_menuItems[i]).tag;
        
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).icon] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).h_icon] forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        [button setShowsTouchWhenHighlighted:YES];
        [button addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.imageEdgeInsets = UIEdgeInsetsMake(-60, 0, 0, 0);
        
        [self addSubview:button];
        
        UILabel * title = [[UILabel alloc]init];
        title.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
        title.textAlignment = NSTextAlignmentLeft;
        title.numberOfLines = 0;
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.text = ((MenuItem *)_menuItems[i]).title;
        title.transform = CGAffineTransformMakeRotation(M_PI_2);
        title.frame = CGRectMake(0, rect.size.height/2.f, rect.size.width, rect.size.height/2.f);
        
        [button addSubview:title];
        
        x+=self.bounds.size.width/self.menuItems.count;
    }
}

-(void)menuItemClicked:(UIButton *)sender
{
    _itemClick(_menuItems[sender.tag]);
}

@end

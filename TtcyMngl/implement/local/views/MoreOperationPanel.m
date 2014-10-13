//
//  MoreOperationPanel.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-30.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MoreOperationPanel.h"

@implementation MoreOperationPanel

-(MoreOperationPanel *)initWithFrame:(CGRect)frame andItems:(NSArray *)itemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.menuItems = [NSMutableArray arrayWithArray:itemsArray];
        [self setBaseCondition];
        [self createItems];
    }
    return self;
}
- (void)setBaseCondition
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 2.f;
    self.layer.borderColor = [Utils colorWithHexString:@"1B98DA"].CGColor;
}
-(void)createItems
{
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width/_menuItems.count, self.bounds.size.height);
    CGFloat x = self.bounds.size.width/(self.menuItems.count * 2);
    
    for (int i = 0; i<_menuItems.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.transform = CGAffineTransformMakeRotation(M_PI_2);
        button.frame = rect;
        button.center = CGPointMake(x, self.bounds.size.height/2.0f);
        button.tag = ((MenuItem *)_menuItems[i]).tag;
        
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).icon] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).h_icon] forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
        [button setTitleColor:[Utils colorWithHexString:@"1B98DA"] forState:UIControlStateNormal];
        [button setTitle:((MenuItem *)_menuItems[i]).title forState:UIControlStateNormal];
        [button setShowsTouchWhenHighlighted:YES];
        [button addTarget:self action:@selector(menuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = [Utils colorWithHexString:@"1B98DA"].CGColor;
        
        [self addSubview:button];
        
        x+=self.bounds.size.width/self.menuItems.count;
    }
}

-(void)menuItemClicked:(UIButton *)sender
{
    _itemClick(_menuItems[sender.tag]);
}

@end

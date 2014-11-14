//
//  MoreOperationPanel.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-30.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MoreOperationPanel.h"

@interface MoreOperationPanel ()
{
    CGRect _frame;
}
@property (nonatomic,strong)UIView * bgView;
@property (nonatomic,strong)UIView * itemView;

@end

@implementation MoreOperationPanel

-(MoreOperationPanel *)initWithFrame:(CGRect)frame andItems:(NSArray *)itemsArray
{
    _frame = frame;
    self = [super initWithFrame:kMainScreenFrame];
    if (self) {
        self.menuItems = [NSMutableArray arrayWithArray:itemsArray];
        [self setBaseCondition];
        [self createItemView];
        [self createItems];
        [self addGestrue];
    }
    return self;
}
- (void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
}
- (void)createItemView
{
    self.itemView = [[UIView alloc]initWithFrame:_frame];
    _itemView.backgroundColor = [UIColor whiteColor];
    _itemView.layer.cornerRadius = 8.f;
    _itemView.layer.masksToBounds = YES;
    _itemView.layer.borderWidth = 2.f;
    _itemView.layer.borderColor = [Utils colorWithHexString:@"1B98DA"].CGColor;
    _itemView.center = CGPointMake(self.center.x, self.center.y - 50);
    [self addSubview:_itemView];
}
-(void)createItems
{
    CGRect rect = CGRectMake(0, 0, _itemView.bounds.size.width/_menuItems.count, _itemView.bounds.size.height);
    CGFloat x = _itemView.bounds.size.width/(self.menuItems.count * 2);
    
    for (int i = 0; i<_menuItems.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.transform = CGAffineTransformMakeRotation(M_PI_2);
        button.frame = rect;
        button.center = CGPointMake(x, _itemView.bounds.size.height/2.0f);
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
        
        [_itemView addSubview:button];
        
        x+=_itemView.bounds.size.width/self.menuItems.count;
    }
}
- (void)addGestrue
{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:) ]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(paned:)]];
}
-(void)menuItemClicked:(UIButton *)sender
{
    _itemClick(_menuItems[sender.tag]);
}
- (void)taped:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:.2f animations:^{
            self.alpha = 0;
        }];
    }
}
- (void)paned:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:.2f animations:^{
            self.alpha = 0;
        }];
    }
}
@end

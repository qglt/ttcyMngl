//
//  OnlineAvd.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-23.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineAvd.h"
#import <UIImageView+WebCache.h>

@interface OnlineAvd()

@property (nonatomic,strong)NSArray * items;

@property (nonatomic,strong)NSArray * holderItems;

@end

@implementation OnlineAvd

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items placeHolders:(NSArray *)holderItems
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items = [NSArray arrayWithArray:items];
        self.holderItems = [NSArray arrayWithArray:holderItems];
        [self setBaseCondition];
        [self createADVImages];
    }
    return self;
}

- (void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentSize = CGSizeMake(self.frame.size.width * _items.count, 0);
    self.contentOffset = CGPointMake(0, 0);
    self.pagingEnabled = YES;
}
- (void)createADVImages
{
    CGRect frame = self.bounds;
    frame.origin.y -= 20;
    for (int i =0 ;i<_items.count;i++) {
        frame.origin.x += frame.size.width *i;
        UIImageView * image = [[UIImageView alloc]initWithFrame:frame];
        [image sd_setImageWithURL:[NSURL URLWithString:_items[i]] placeholderImage:[UIImage imageNamed:_holderItems[i]]];
        [self addSubview:image];
    }
}

@end

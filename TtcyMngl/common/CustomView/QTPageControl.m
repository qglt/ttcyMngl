//
//  QTPageControl.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "QTPageControl.h"

@interface QTPageControl()
{
    NSInteger _itenCount;
    CGRect _itemFrame;
    CGFloat _itemDistence;
}
@property (nonatomic,strong)UIImageView * itemBG;

@end

@implementation QTPageControl

-(id)initWithFrame:(CGRect)frame itemCount:(NSInteger)count;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itenCount = count;
        [self setBaseCondition];
        [self createItems:_itenCount];
        [self createItemBG];
    }
    return self;
}

- (void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
    if (_itenCount == 0) {
        _itenCount =3;
    }
}
- (void)createBackgroundImageWithBeganY:(CGFloat)y length:(CGFloat)length
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0f, y, .5f, length)];
    view.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
    [self addSubview:view];
}
- (void)createItemBG
{
    self.itemBG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pageControl_thumb"]];
    _itemBG.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    [self addSubview:_itemBG];
}
- (void)createItems:(int)itemNumber
{
    _itemFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    _itemDistence = (self.frame.size.height - _itemFrame.size.height*itemNumber)/(itemNumber-1.f);
    for (int i=0;i<itemNumber ; i++) {
        CGFloat centY = _itemFrame.size.height/2.0 + (_itemDistence+_itemFrame.size.width)*i;
        UIButton * item = [UIButton buttonWithType:UIButtonTypeCustom];
        item.backgroundColor = [UIColor clearColor];
        item.frame =_itemFrame;
        item.tag = i;
        
        item.layer.cornerRadius = _itemFrame.size.width/2.0f;
        item.layer.borderColor = [Utils colorWithHexString:@"#1B98DA"].CGColor;
        item.layer.borderWidth = .5f;
        
        item.center = CGPointMake(self.frame.size.width/2.0f, centY);
        [item addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        
        if (i!=_itenCount-1) {
            [self createBackgroundImageWithBeganY:(item.frame.origin.y+item.frame.size.height)
                                           length:_itemDistence];
        }
    }
}
- (void)itemSelected:(UIButton *)sender
{
    _pageItemClick(sender.tag);
}

-(void)setSelectedIndex:(NSInteger)index
{
    _itemBG.center = CGPointMake(self.frame.size.width/2.0f, _itemFrame.size.height/2.0 + (_itemDistence+_itemFrame.size.width)*index);
}

@end

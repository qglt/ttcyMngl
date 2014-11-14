//
//  ScrollLabel.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-22.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "ScrollLabel.h"

@interface ScrollLabel()
{
    CGSize textSize;
}
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)UILabel * textLabel;

@end

@implementation ScrollLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseCondition];
        [self createScrollView];
        [self createLabel];
    }
    return self;
}
- (void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
}
- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(5, 0);
    [self addSubview:_scrollView];
}
- (void)createLabel
{
    self.textLabel = [[UILabel alloc]initWithFrame:self.bounds];
    _textLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_textLabel];
}
-(void)setText:(NSString *)text
{
    _textLabel.text = text;
    [self updateFrames];
    [self startAnimationIfNeeded];
}
-(void)setTextColor:(UIColor *)textColor
{
    _textLabel.textColor = textColor;
}
-(void)setFont:(UIFont *)font
{
    _textLabel.font = font;
}
-(void)setTextAlignment:(Alignment)textAlignment
{
    switch (textAlignment) {
        case Center:
            _textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case Left:
            _textLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case Right:
            _textLabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
}
- (void)updateFrames
{
    CGSize size = [_textLabel.text sizeWithFont:_textLabel.font];
    
    CGRect frame = _textLabel.frame;
    frame.size.width = size.width;
    _textLabel.frame = frame;
    
    _scrollView.contentSize = size;
}
-(void)startAnimationIfNeeded{
    
    [_textLabel.layer removeAllAnimations];
    const float oriWidth = self.bounds.size.width;
    
    if (_textLabel.frame.size.width > oriWidth) {
        
        float offset = _textLabel.frame.size.width-oriWidth;
        
        [UIView animateWithDuration:2.5f
                              delay:0
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveLinear
                         animations:^{
                             _scrollView.contentOffset = CGPointMake(offset, 0);
                         }
                         completion:^(BOOL finished) {
                             
                         }
         ];
    }
}
@end

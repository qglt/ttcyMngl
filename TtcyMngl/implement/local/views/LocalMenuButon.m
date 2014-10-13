//
//  LocalMenuButon.m
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LocalMenuButon.h"

@interface LocalMenuButon()

@property (nonatomic,strong)UIImageView * icon;
@property (nonatomic,strong)UILabel * textLabel;
@property (nonatomic,strong)UILabel * infoLabel;

@end

@implementation LocalMenuButon

-(LocalMenuButon *)initWithTitle:(NSString *)title Icon:(NSString *)iconName Class:(NSString *)className item:(NSString *)itemName
{
    self = [super init];
    if (self) {
        
        getPlayBarHeight();
        
        self.frame = CGRectMake(0, 0, 200, kMainScreenWidth/4.0 - 1);
        self.backgroundColor = [UIColor clearColor];
        
        self.vcClass = className;

        [self setBackgroundColor:[UIColor clearColor]];
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        [self setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 140);
        self.imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 40)];
        titleLabel.center = CGPointMake(self.center.x+45, self.center.y);
        titleLabel.text = title;
        
        titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self setShowsTouchWhenHighlighted:YES];
    }
    return self;
}
-(void)createIconWithIconName:(NSString *)iconName
{
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    _icon.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _icon.frame = CGRectMake(0, 0, 50, 50);
    _icon.center = CGPointMake(25, self.bounds.size.height/2.0f);
    [self addSubview:_icon];
}
-(void)createTextLabel:(NSString *)textString
{
    self.textLabel = [[UILabel alloc]init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.text = textString;
    _textLabel.numberOfLines = 0;
    UIFont *textfont = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    _textLabel.font = textfont;
    //限制 label 的宽度
    CGSize widthSize = CGSizeMake(self.frame.size.width/2.0f, 60);
    //label 的真实size
    CGSize actualSize = [textString sizeWithFont:textfont constrainedToSize:widthSize lineBreakMode:NSLineBreakByWordWrapping];//此方法要求font和lineBreakMode与之前设置的完全一致
    //label 自适应高度
    _textLabel.frame = CGRectMake(0, 0, actualSize.width, actualSize.height);
    _textLabel.center = CGPointMake(_icon.frame.origin.x + _icon.frame.size.width + 15 + _textLabel.frame.size.width/2.0f, _icon.center.y);
    [self addSubview:_textLabel];
}
-(void)createInfoLabel:(NSString *)infoString
{
    self.infoLabel = [[UILabel alloc]init];
    _infoLabel.backgroundColor = [UIColor clearColor];
    _infoLabel.text = infoString;
    _infoLabel.textColor = [UIColor clearColor];//象牙黑，透明度0.6
    _infoLabel.numberOfLines = 0;
    UIFont *infoFont = [UIFont fontWithName:@"Menksoft Qagan" size:16.0f];
    _infoLabel.font = infoFont;
    //限制 label 的宽度
    CGSize width = CGSizeMake(self.frame.size.width - 20, 40);
    //label 的真实size
    CGSize actualSize = [infoString sizeWithFont:infoFont constrainedToSize:width lineBreakMode:NSLineBreakByWordWrapping];//此方法要求font和lineBreakMode与之前设置的完全一致
    //label 自适应高度
    _infoLabel.frame = CGRectMake(0, 0,actualSize.width , actualSize.height);
    _infoLabel.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f - 20);
    [self addSubview:_infoLabel];
}
/**
 * 通过点击的button的tag出发对应方法
 *
 * @TAG 从上往下：全部，收藏，下载，历史播放
 */
-(void)buttonAction:(LocalMenuButon *)sender
{
    [self.delegate menuItemPressed:sender];
}


@end

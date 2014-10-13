//
//  CustomPage.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "CustomPage.h"

@interface CustomPage ()

@property (nonatomic,strong,setter = setImage:)NSString * image;
@property (nonatomic,strong,setter = setTitle:)NSString * title;
@property (nonatomic,strong,setter = setDetail:)NSString * detail;

@end

@implementation CustomPage

-(id)initWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.image = image;
        self.title = title;
        self.detail = detail;
    
    }
    return self;
}
-(void)setImage:(NSString *)image
{
    _image = image;
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_image]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.tag = 1;
    [self addSubview:imageView];
    
    CGFloat top = 40;
    CGFloat wh = 480.f/320.f;
    
    if (is4Inch) {
        top+=10;
        wh = 568.f/320.f;
    }
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:top]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:200]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeWidth multiplier:wh constant:0]];
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    
    titleLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    titleLabel.tag = 2;
    titleLabel.text = _title;
    
    CGFloat top = 40;
    CGFloat wh = 480.f/320.f;
    
    if (is4Inch) {
        top+=10;
        wh = 568.f/320.f;
    }
    titleLabel.frame = CGRectMake(205.f, top, 35, 200*wh);
    [self addSubview:titleLabel];
}
-(void)setDetail:(NSString *)detail
{
    _detail = detail;
    UILabel * detailLabel = [[UILabel alloc]init];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0];
    detailLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    detailLabel.numberOfLines = 0;
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailLabel.text = detail;
    CGFloat top = 40;
    CGFloat wh = 520.f/320.f;
    
    if (is4Inch) {
        top+=10;
        wh = 568.f/320.f;
    }
    detailLabel.frame = CGRectMake(245.f, top, 73, 400);
    [self addSubview:detailLabel];
}
@end

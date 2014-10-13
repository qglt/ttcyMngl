//
//  UIButton+menuItem.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-21.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "UIButton+menuItem.h"

@implementation UIButton (menuItem)

-(UIButton *)initWithFrame:(CGRect)frame Tag:(NSInteger)tag Title:(NSString *)title
                     Image:(NSString *)imageName
{
    self.frame = frame;
    for (id subview in self.subviews) {
        [subview removeFromSuperview];
    }
    [self createImage:imageName];
    [self createTitleLabel:title];

    return self;
}
-(void)createImage:(NSString *)imageName
{
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""] highlightedImage:[UIImage imageNamed:@""]];
    image.frame = CGRectMake(self.bounds.size.width/5.0f, self.bounds.size.height/9.0f, self.bounds.size.width*3/5.0f, self.bounds.size.height*4/9.0f);
    [self addSubview:image];
}
-(void)createTitleLabel:(NSString *)title
{
    
}

@end

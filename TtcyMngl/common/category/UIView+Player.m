//
//  UIView+Player.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-8-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "UIView+Player.h"
#import "PlayBar.h"

@implementation UIView (Player)

+(id)player
{
    return [PlayBar defultPlayer];
}

@end

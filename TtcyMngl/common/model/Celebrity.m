//
//  Celebrity.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-14.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "Celebrity.h"

#pragma mark 歌手模型
@implementation Celebrity
-(id)initWith{
    self=[super init];
    return self;
    
}
+(id)initWithDict:(NSDictionary*)dict{
    Celebrity *celebrity=[[Celebrity alloc]initWith];
    celebrity.number=[dict[@"number"]integerValue];
    celebrity.name=dict[@"name"];
    celebrity.sex=dict[@"sex"];
    celebrity.sinforMation=dict[@"sinforMation"];
    celebrity.photoURL=dict[@"photoURL"];
    return celebrity;
}
@end

//
//  Album.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-6-6.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "Album.h"

@implementation Album
-(id)initWith{
    self=[super init];
    return self;
    
}
+(id)initWithDict:(NSDictionary*)dict{
    Album *album=[[Album alloc]initWith];
    album.number=[dict[@"number"] integerValue];
    album.moID=[dict[@"moID"]integerValue];
    album.photoURL=dict[@"photoURL"];
    album.name=dict[@"name"];
    album.albumCategoryId=[dict[@"albumCategoryId"]integerValue];
    return album;
    
    
}
@end
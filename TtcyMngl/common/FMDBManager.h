//
//  FMDBManager.h
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "SongObject.h"

@interface FMDBManager : NSObject

{
    FMDatabase *_db;
}

+ (FMDBManager *)defaultManager;

- (NSMutableArray *)getAllSongFromDB;//从数据库中获取所有歌曲

- (void)updateSongFromDB;//更新数据库中的歌曲

-(BOOL)addSongFromDB:(SongObject *)songObj;//往数据库里添加歌曲

- (BOOL)deleteSongFromDBBySongName:(NSString *)songName;//从数据库中删除歌曲

- (NSArray *)queryInfosFromTable:(NSString *)tableName;//返回所有纪录

- (NSMutableArray *)queryInfosFromSongList;//从歌曲列表里查询信息

@end

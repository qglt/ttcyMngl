//
//  FMDBManager.h
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "DBManger_Define.h"
#import "SongObject.h"
#import "AccountInfo.h"
#import <AVFoundation/AVFoundation.h>


@interface FMDBManager : NSObject

{
    FMDatabase *_db;
}

+ (FMDBManager *)defaultManager;

- (NSMutableArray *)getAllSongFromDB;//从数据库中获取所有歌曲

//- (void)updateSongFromDB;//更新数据库中的歌曲

-(void)addSongFromDB:(SongObject *)songObj;//往数据库里添加歌曲

- (void)deleteSongFromDBBySongUrl:(NSString *)songUrl;//从数据库中删除歌曲

- (void)deleteLocalAllSongs;//删除所有歌曲

- (int)getLocalSongsCount;//获得本地歌曲数目

- (BOOL)isExistSongByUrl:(NSString *)songUrl;//判断songUrl字符串是否存在

- (NSMutableArray *)queryByConfition:(NSString *)condition;

- (SongObject *)fliterDictionaryToSongObject:(NSDictionary *)songDit;

@end

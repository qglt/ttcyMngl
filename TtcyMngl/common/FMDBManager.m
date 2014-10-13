//
//  FMDBManager.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"

#define CREATE_TABLE_Song @"CREATE TABLE IF NOT EXISTS song(songId TEXT(100) , songName TEXT(100) , artist TEXT(100) , artistId TEXT(100) , songUrl TEXT(100) , imageUrl TEXT(100) , avatarImageUrl TEXT(100) , albumTitle TEXT(100) , songType TEXT(100) , duration INTEGER , rateSize INTEGER , songSize TEXT(100) , playTime INTEGER ,  playDate INTEGER , lrc_url TEXT(100))"
//15个参数
#define INSERT_TABLE_Song @"INSERT INTO song(songId, songName, artist, artistId, songUrl, imageUrl, avatarImageUrl, albumTitle, songType, duration, rateSize, songSize, playTime, playDate, lrc_url) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"


@implementation FMDBManager


+ (FMDBManager *)defaultManager
{
    static FMDBManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager = [[FMDBManager alloc] initWithDB];
//    });
    if (manager == nil) {
        manager = [[FMDBManager alloc] initWithDB];
    }
    return manager;
}

#pragma mark - init 初始化

- (id)initWithDB
{
    if (self = [super init])
    {
        [self createDB];
    }
    return self;
}

#pragma mark - self busyness 自己的方法

//创建数据库
- (void)createDB
{
    //    根据path获取db。一定要retain。否则会自动释放
    _db = [FMDatabase databaseWithPath:[self dbPath]];
    
}

//获取db的路径
- (NSString*)dbPath
{
    NSArray* documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [documentPath objectAtIndex:0];
//    NSString* dbPath = [path stringByAppendingString:@"localSong.sqlite"];
    NSString* dbPath = [path stringByAppendingPathComponent:@"localSong.sqlite"];
    return dbPath;
}

//打开数据库,并建表
- (void)openDB
{
    //    打开db
    if ([_db open])
    {
    //        新建Table
        if ([_db executeUpdate:CREATE_TABLE_Song])
        {
            NSLog(@"create table successed");
            
        }
        {
            NSLog(@"create table faild");
        }
    }else
    {
        NSLog(@"db open faild");
    }
}

//关闭数据库
- (void)closeDB
{
    [_db close];
    NSLog(@"db close successed");
}

#pragma mark - use DB 使用dataBase

//从数据库中获取所有歌曲
- (NSMutableArray *)getAllSongFromDB
{
    [self openDB];
    NSMutableArray* arySong = [NSMutableArray array];
    NSString* sql = @"SELECT * FROM song";
    FMResultSet* result = [_db executeQuery:sql];
    while ([result next]) {
        SongObject* songObject = [SongObject songWithResult:result];
        [arySong addObject:songObject];
    }
    [self closeDB];
    return arySong;
}

//添加歌曲
- (BOOL)addSongFromDB:(SongObject *)songObj
{
    [self openDB];
    NSString* sql = INSERT_TABLE_Song;
    if ([_db executeUpdate:sql,
         songObj.songId,
         songObj.songName,
         songObj.artist,
         songObj.artistId,
         songObj.songUrl,
         songObj.imageUrl,
         songObj.avatarImageUrl,
         songObj.albumTitle,
         songObj.songType,
         songObj.duration,
         songObj.rateSize,
         songObj.songSize,
         songObj.playTime,
         songObj.playDate,
         songObj.lrc_url])
    {
        NSLog(@"Add song successed");
        [self closeDB];
        return YES;
    }else
    {
        NSLog(@"Add song faild");
        [self closeDB];
        return NO;
    }
}

//从数据库中删除歌曲
- (BOOL)deleteSongFromDBBySongName:(NSString *)songName
{
    [self openDB];
    NSString* sql = @"DELETE FROM song WHERE songName = ?";
    if ([_db executeUpdate:sql,songName])
    {
        NSLog(@"delete successed");
        [self closeDB];
        return YES;
    }else
    {
        NSLog(@"delete faild");
        [self closeDB];
        return NO;
    }

}

@end






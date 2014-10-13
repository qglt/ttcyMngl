//
//  FMDBManager.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"


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
        [self createTable];
    }
    return self;
}

#pragma mark - self busyness 自己的方法

//创建数据库
- (void)createDB
{
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

//建表
- (void)createTable
{
    [_db open];
    [_db executeUpdate:[NSString stringWithFormat:CREATE_USERINFO_TABLE,TABLE_USERINFO]];
    [_db executeUpdate:[NSString stringWithFormat:CREATE_COLLECTSONG_TABLE,TABLE_CollectSong]];
    NSArray* tableArray = [NSArray array];
    tableArray = @[TABLE_LocalSong,TABLE_DownloadSong,TABLE_HistoryPlay];
    for (int i = 0; i < 3; i++) {
        [_db executeUpdate:[NSString stringWithFormat:CREATE_TABLE,tableArray[i]]];
    }
    [_db close];
}

#pragma mark - use DB 使用dataBase

//获取歌曲数目
- (int)getLocalSongsCount
{
    [_db open];
    int count = 0;
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",TABLE_LocalSong]];//SELECT COUNT(*) AS NumberOfTABLE_LocalSong FROM TABLE_LocalSong
    if(countResult && [countResult count] > 0){
        NSDictionary *dic = [countResult objectAtIndex:0];
        count = [[dic objectForKey:@"count(*)"] intValue];
    }
    [_db close];
    return count;
}

//从数据库中获取所有歌曲
- (NSMutableArray *)getAllSongFromDB
{
    [_db open];
    NSMutableArray* arySong = [NSMutableArray array];
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_LocalSong];
    FMResultSet* result = [_db executeQuery:sql];
    while ([result next]) {
        SongObject* songObject = [SongObject songWithResult:result];
        [arySong addObject:songObject];
    }
    [_db close];
    return arySong;
}

//添加歌曲
- (void)addSongFromDB:(SongObject *)songObj
{
    if (![self isExistSongByUrl:songObj.songUrl]) {
        [_db open];
        NSString* sql = [NSString stringWithFormat:INSERT_TABLE,TABLE_LocalSong];
        if ([_db executeUpdate:sql,SONG_PARAMETER]){
            NSLog(@"insert local song successed");
        }
        else{
            NSLog(@"insert local song failed");
        }
        [_db close];
    }
}

-(void)deleteSongFromDBBySongUrl:(NSString *)songUrl
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE songUrl = ?",TABLE_LocalSong];
    if ([_db executeUpdate:sql,songUrl]) {
        NSLog(@"delete local song successed");
    }
    else{
        NSLog(@"delete local song failed");
    }
    [_db close];
}

- (void)deleteLocalAllSongs
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",TABLE_LocalSong];
    if ([_db executeUpdate:sql]) {
        NSLog(@"delete local all song successed");
    }
    else{
        NSLog(@"delete local all song failed");
    }
    [_db close];
}

- (NSMutableArray *)queryByConfition:(NSString *)condition
{
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [_db executeQuery:condition];
	while([rs next]) {
		[result addObject: [rs resultDictionary]];
	}
    return result;
}

- (SongObject *)fliterDictionaryToSongObject:(NSDictionary *)songDit
{
    SongObject *songObject = [[SongObject alloc] init];
    NSString *songId = [songDit objectForKey:@"songId"];
    NSString *songName = [songDit objectForKey:@"songName"];
    NSString *albumTitle = [songDit objectForKey:@"albumTitle"];
    NSString *artist = [songDit objectForKey:@"artist"];
    NSString *songUrlStr = [songDit objectForKey:@"songUrl"];
    NSString *type = [songDit objectForKey:@"songType"];
    NSNumber *duration = [songDit objectForKey:@"duration"];
    NSString *imageUrl = [songDit objectForKey:@"imageUrl"];
    NSString *avatarImageUrl = [songDit objectForKey:@"avatarImageUrl"];
    NSNumber *playTime = [songDit objectForKey:@"playTime"];
    NSString *songSize = [songDit objectForKey:@"songSize"];
    NSNumber *rateSize = [songDit objectForKey:@"rateSize"];
    NSString *artistId = [songDit objectForKey:@"artistId"];
    NSNumber *playDate = [songDit objectForKey:@"playDate"];
    NSString *lrc_url = [songDit objectForKey:@"lrc_url"];
    
    songObject.songId = songId;
    songObject.songName = songName;
    songObject.albumTitle = albumTitle;
    songObject.artist = artist;
    songObject.songUrl = songUrlStr;
    songObject.imageUrl = imageUrl;
    songObject.avatarImageUrl = avatarImageUrl;
    songObject.songSize = songSize;
    songObject.duration = duration;
    songObject.rateSize = rateSize;
    songObject.songType = type;
    songObject.playTime = playTime;
    songObject.artistId = artistId;
    songObject.playDate = playDate;
    songObject.lrc_url = lrc_url;
    return songObject;

}

- (BOOL)isExistSongByUrl:(NSString *)songUrl
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE songUrl = '%@'",TABLE_LocalSong,songUrl];
    
    NSMutableArray *results = [self queryByConfition:sql];
    if (results&&[results count]>0) {
        [_db close];
        return YES;
    }
    [_db close];
    return NO;
}


@end






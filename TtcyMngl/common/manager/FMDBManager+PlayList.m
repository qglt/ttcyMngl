//
//  FMDBManager+PlayList.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager+PlayList.h"


@implementation FMDBManager (PlayList)

#pragma mark - init 初始化

//创建自定义歌单表,并加到 CustomSongList 表中
- (void)initWithTableCustomSongList:(NSString *)playListName
{
        [_db open];
        [_db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(ID integer primary key,SONGCOUNT int,SONGDATA text,PLAYLISTNAME text)",TABLE_CustomSongList]];
    
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[NSNumber numberWithInt:0] forKey:@"SONGCOUNT"];
        [params setValue:playListName forKey:@"PLAYLISTNAME"];
        [params setValue:@"" forKey:@"SONGDATA"];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO %@(SONGCOUNT, PLAYLISTNAME, SONGDATA) VALUES(?,?,?)",TABLE_CustomSongList ];
        [_db executeUpdate:sql];
        [_db close];
}

//创建具体歌单名称表
- (void)createPlayListByName:(NSString *)playListName
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:CREATE_TABLE,playListName];
    [_db executeUpdate:sql];
    [_db close];
}

- (int)getPlayListCount
{
    [_db open];
    int count = 0;
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT count(*) FROM %@",TABLE_CustomSongList]];
    if(countResult && [countResult count] > 0){
        NSDictionary *dic = [countResult objectAtIndex:0];
        count = [[dic objectForKey:@"count(*)"] intValue];
    }
    [_db close];
    return count;
}

//获取playListName歌单下的所有歌曲
- (NSMutableArray *)getSongListByPlayListName:(NSString *)playListName
{
    [_db open];
    NSMutableArray *songList = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", playListName];
    FMResultSet *result = [_db executeQuery:sql];
    while ([result next]) {
        SongObject *songObj = [SongObject songWithResult:result];
        [songList addObject:songObj];
    }
    [_db close];
    return songList;
}

//- (NSMutableArray *)getSongListByPlayListName:(NSString *)playListName
//{
//    [_db open];
//    NSMutableArray *songList = [[NSMutableArray alloc] init];
//    NSMutableArray *dataList = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@",playListName]];
//    if (dataList && [dataList count]>0) {
//        for (int i = 0; i < [dataList count]; i++) {
//            NSDictionary *songDit = [dataList objectAtIndex:i];
//            [songList addObject:[self fliterDictionaryToSongObject:songDit]];
//        }
//        [_db close];
//        return songList;
//    }
//    else{
//        [_db close];
//        return nil;
//    }
//}

- (void)addSongToPlayList:(SongObject *)songObj PlayListName:(NSString *)playListName
{
    BOOL isExist = NO;
    NSMutableArray* songList = [self getSongListByPlayListName:playListName];
    for (int i = 0; i < [songList count]; i++) {
        SongObject *obj = [songList objectAtIndex:i];
        //判断是否有该歌曲
        if ([obj.songUrl isEqualToString:songObj.songUrl]) {
            NSLog(@"歌单中已有该歌曲");
            isExist = YES;
            break;
        }
    }
    if (isExist == NO) {
        [_db open];
        NSString* sql = [NSString stringWithFormat:INSERT_TABLE,playListName];
        if ([_db executeUpdate:sql,PARAMETER]){
            NSLog(@"添加成功");
        }
        else{
            NSLog(@"添加失败");
        }
        [_db close];
    }
}

- (NSMutableArray *)getPlayListInfo
{
    NSMutableArray *playList = [[NSMutableArray alloc] init];
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@",TABLE_CustomSongList]];
    if (!arrayIsEmpty(countResult)){
        for (NSString *list in countResult) {
            [playList addObject:list];
        }
        return playList;
    }
    else{
        return nil;
    }
    
}

- (void)clearAllPlist
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",TABLE_CustomSongList];
    if ([_db executeUpdate:sql]) {
        NSLog(@"delete play list song successed");
    }
    else{
        NSLog(@"delete play list song failed");
    }
    [_db close];
}

- (void)deleteSongFromPlayList:(NSString *)songUrl PlayListName:(NSString *)playListName
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE songUrl = ?",playListName];
    if ([_db executeUpdate:sql,songUrl]) {
        NSLog(@"delete play list song successed");
    }
    else{
        NSLog(@"delete play list song failed");
    }
    [_db close];
}

#pragma mark - CG_INLINE

//CG_INLINE BOOL stringIsEmpty(NSString *string) {
//    if([string isKindOfClass:[NSNull class]]){
//        return YES;
//    }
//    if (string == nil) {
//        return YES;
//    }
//    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if ([text length] == 0) {
//        return YES;
//    }
//    return NO;
//}

CG_INLINE BOOL arrayIsEmpty(NSArray *array) {
    if([array isKindOfClass:[NSNull class]]){
        return YES;
    }
    if(array && [array count] > 0){
        return NO;
    }
    return YES;
}

@end






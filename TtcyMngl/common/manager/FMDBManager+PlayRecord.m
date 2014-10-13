//
//  FMDBManager+PlayRecord.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-17.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager+PlayRecord.h"

@implementation FMDBManager (PlayRecord)

- (int)getPlayRecordCount
{
    [_db open];
    int count = 0;
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT count(*) FROM %@",TABLE_HistoryPlay]];
    if(countResult && [countResult count] > 0){
        NSDictionary *dic = [countResult objectAtIndex:0];
        count = [[dic objectForKey:@"count(*)"] intValue];
    }
    [_db close];
    return count;
}

- (void)addPlayRecordSong:(SongObject *)songObj
{
    if (![self isExistSongUrl:songObj.songUrl]) {
        [_db open];
        NSString* sql = [NSString stringWithFormat:INSERT_TABLE,TABLE_HistoryPlay];
        if ([_db executeUpdate:sql,SONG_PARAMETER]){
            NSLog(@"insert history play song successed");
            [self addSongFromDB:songObj];
        }
        else{
            NSLog(@"insert history play song failed");
        }
        [_db close];
    }
}

- (NSMutableArray *)getPlayRecordList
{
    [_db open];
    NSMutableArray *songList = [[NSMutableArray alloc] init];
    NSMutableArray *dataList = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@",TABLE_HistoryPlay]];
    if (dataList && [dataList count]>0) {
        for (int i = 0; i < [dataList count]; i++) {
            NSDictionary *songDit = [dataList objectAtIndex:i];
            [songList addObject:[self fliterDictionaryToSongObject:songDit]];
        }
        [_db close];
        return songList;
    }
    [_db close];
    return nil;
}

- (SongObject *)getSongInfoByUrl:(NSString *)songUrlStr
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE SONGURL = '%@'",TABLE_HistoryPlay,songUrlStr];
    
    NSMutableArray *results = [self queryByConfition:sql];
    if (results&&[results count]>0) {
        NSMutableDictionary *songDit = (NSMutableDictionary *)[results objectAtIndex:0];
        [_db close];
        return [self fliterDictionaryToSongObject:songDit];
    }
    [_db close];
    return nil;
}

- (void)deletePlayRecordSongBySongUrl:(NSString *)songUrl
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE songUrl = ?",TABLE_HistoryPlay];
    if ([_db executeUpdate:sql,songUrl]) {
        NSLog(@"delete history play song successed");
        [self deleteSongFromDBBySongUrl:songUrl];
    }
    else{
        NSLog(@"delete history play song failed");
    }
    [_db close];
}

- (void)deleteAllPlayRecord
{
    [self clearAll];
}

- (void)clearAll{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",TABLE_HistoryPlay];
    if ([_db executeUpdate:sql]) {
        NSLog(@"delete all history play song successed");
    }
    else{
        NSLog(@"delete all history play song failed");
    }
    [_db close];
}

- (BOOL)isExistSongUrl:(NSString *)songUrl
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE songUrl = '%@'",TABLE_HistoryPlay,songUrl];
    
    NSMutableArray *results = [self queryByConfition:sql];
    if (results&&[results count]>0) {
        [_db close];
        return YES;
    }
    [_db close];
    return NO;
}

@end

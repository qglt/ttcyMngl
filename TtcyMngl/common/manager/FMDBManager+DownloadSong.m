//
//  FMDBManager+DownloadSong.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-17.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager+DownloadSong.h"



@implementation FMDBManager (DownloadSong)

- (int)getDownLoadSongCount
{
    [_db open];
    int count = 0;
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT count(*) FROM %@",TABLE_DownloadSong]];
    if(countResult && [countResult count] > 0){
        NSDictionary *dic = [countResult objectAtIndex:0];
        count = [[dic objectForKey:@"count(*)"] intValue];
    }
    [_db close];
    return count;
}

- (void)addDownLoadSong:(SongObject *)songObj
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:INSERT_TABLE,TABLE_DownloadSong];
    if ([_db executeUpdate:sql,SONG_PARAMETER]){
        NSLog(@"insert download song successed");
    }
    else{
        NSLog(@"insert download song failed");
    }
    [_db close];
}

-(NSMutableArray *)getDownLoadList
{
    [_db open];
    NSMutableArray *downList = [[NSMutableArray alloc] init];
    NSMutableArray *dataList = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@",TABLE_DownloadSong]];
    if (dataList && [dataList count]>0) {
        
        for (int i = 0; i < [dataList count]; i++) {
            NSDictionary *songDit = [dataList objectAtIndex:i];
            
            [downList addObject:[self fliterDictionaryToSongObject:songDit]];
        }
    }
    [_db close];
    return downList;
}

- (void)deleteDownloadSongBySongUrl:(NSString*)songUrl
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE songUrl = ?",TABLE_DownloadSong];
    if ([_db executeUpdate:sql,songUrl]) {
        NSLog(@"delete download song successed");
    }
    else{
        NSLog(@"delete download song failed");
    }
    [_db close];
}

- (NSDictionary *)getDownloadObjectByUrl:(NSString *)songUrl
{
    [_db open];
    NSMutableArray *dataList = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE SONGURL = '%@'",TABLE_DownloadSong,songUrl]];
    
    if (dataList && [dataList count] > 0) {
        NSDictionary *resultDit = [[NSDictionary alloc] initWithDictionary:[dataList objectAtIndex:0]];
        return resultDit;
    }
    [_db close];
    return nil;
}



@end







//
//  FMDBManager+CollectSong.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-26.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager+CollectSong.h"
#import "HUD.h"

@implementation FMDBManager (CollectSong)

-(int)getCollectSongCountWithuserID:(NSString *)phone
{
    [_db open];
    int count = 0;
    NSMutableArray *countResult = [self queryByConfition:[NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE phone = %@", TABLE_CollectSong, phone]];
    if(countResult && [countResult count] > 0){
        NSDictionary *dic = [countResult objectAtIndex:0];
        count = [[dic objectForKey:@"count(*)"] intValue];
    }
    [_db close];
    return count;
}

- (void)addCollectSong:(SongObject *)songObj userID:(NSString *)phone callBack:(void (^)(BOOL))callBack
{
    if ([self checkCollectSong:songObj withUser:phone]) {
        [HUD message:@"      "];
    }else{
        [_db open];
        NSString* sql = [NSString stringWithFormat:INSERT_COLLECTSONG_TABLE,TABLE_CollectSong];
        if ([_db executeUpdate:sql,COLLECTSONG_PARAMETER]){
            NSLog(@"insert collect song successed");
            callBack(YES);
            [self addSongFromDB:songObj];
        }
        else{
            NSLog(@"insert collect song failed");
            callBack(NO);
        }
        [_db close];
    }
}
- (BOOL)checkCollectSong:(SongObject *)song withUser:(NSString *)userid
{
    NSMutableArray *collectSongAry = [self getCollectSongListWithuserID:userid];
    for (SongObject *obj in collectSongAry) {
        if ([obj.songUrl isEqualToString:song.songUrl]) {
            return YES;
        }
    }
    return NO;
}
- (NSMutableArray *)getCollectSongListWithuserID:(NSString *)phone
{
    [_db open];
    NSMutableArray *songList = [[NSMutableArray alloc] init];
    NSMutableArray *dataList = [self queryByConfition:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE phone = %@", TABLE_CollectSong, phone]];
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

- (void)deleteCollectSongBySongName:(NSString *)songName userID:(NSString *)phone callBack:(void (^)(BOOL))callBack
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE phone = '%@' and songUrl = '%@';",TABLE_CollectSong,phone,songName];
    if ([_db executeUpdate:sql]) {
        callBack(YES);
    }
    else{
        callBack(NO);
    }
    [_db close];
}

- (void)deleteAllCollectSongWithuserID:(NSString *)phone
{
    [_db open];
    [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",TABLE_LocalSong]];
    [_db close];
}

@end



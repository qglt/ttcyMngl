//
//  FMDBManager+PlayRecord.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-17.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (PlayRecord)

- (int)getPlayRecordCount;

- (void)addPlayRecordSong:(SongObject *)songObj;

- (void)deletePlayRecordSongBySongUrl:(NSString *)songUrl;

- (void)deleteAllPlayRecord;

- (NSMutableArray *)getPlayRecordList;

- (SongObject *)getSongInfoByUrl:(NSString *)songUrlStr;

@end

//
//  FMDBManager+CollectSong.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-26.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (CollectSong)

- (int)getCollectSongCountWithuserID:(NSString *)phone;

- (void)addCollectSong:(SongObject *)songObj userID:(NSString *)phone callBack:(void(^)(BOOL isOK))callBack;

- (NSMutableArray *)getCollectSongListWithuserID:(NSString *)phone;

- (void)deleteCollectSongBySongName:(NSString *)songName userID:(NSString *)phone callBack:(void(^)(BOOL isOK))callBack;

- (void)deleteAllCollectSongWithuserID:(NSString *)phone;
- (BOOL)checkCollectSong:(SongObject *)song withUser:(NSString *)userid;
@end

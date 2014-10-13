//
//  FMDBManager+PlayList.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (PlayList)

- (int)getPlayListCount;

- (void)addSongToPlayList:(SongObject *)songObj PlayListName:(NSString *)playListName;

- (void)clearAllPlist;//删除所有歌单列

- (NSMutableArray *)getPlayListInfo;//获取歌单列表

- (NSMutableArray *)getSongListByPlayListName:(NSString *)playListName;//获取playListName歌单下的歌曲列表

- (void)createPlayListByName:(NSString *)playListName;//自建歌单

- (void)deleteSongFromPlayList:(NSString *)songUrl PlayListName:(NSString *)playListName;

@end

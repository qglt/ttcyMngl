//
//  FMDBManager+DownloadSong.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-17.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (DownloadSong)

- (int)getDownLoadSongCount;

- (void)addDownLoadSong:(SongObject *)songObj;

- (NSMutableArray *)getDownLoadList;

- (void)deleteDownloadSongBySongUrl:(NSString*)songUrl;

- (NSDictionary *)getDownloadObjectByUrl:(NSString *)songUrl;


@end

//
//  SongOprationManager.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-22.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongObject.h"

typedef enum {
    safe,
    unSafe
}operationType;

typedef enum{
    playModeTypeOrder,
    playModeTypeRandom,
}playModeType;

typedef enum {
    QueueTypeTempPlay,
    QueueTypeHistory,
    QueueTypeCollect,
}QueueType;

@interface SongOprationManager : NSObject

+ (void)collect:(operationType)type Song:(SongObject *)song callBack:(void(^)(BOOL isOK))callBack;
+ (void)download:(operationType)type Song:(SongObject *)song callBack:(void(^)(BOOL isOK))callBack;
+ (void)shareSong:(SongObject *)song;
+ (BOOL)checkCollectedSong:(SongObject *)song withUser:(NSString *)userId;
+ (void)operation:(operationType)type song:(SongObject *)song withQueue:(QueueType)queueType callBack:(void(^)(BOOL isOK))callBack;
+ (void)clearQueue:(QueueType)queueType callBack:(void(^)(BOOL isOK))callBack;
+ (void)setQueue:(QueueType)queueType withData:(NSMutableArray *)dataArray;

+ (void)changePlayMode;
+ (playModeType)playMode;

+ (NSMutableArray *)tmpPlayArray;
+ (NSMutableArray *)hisPlayArray;
+ (NSMutableArray *)collectArrayWithUserId:(NSString *)userId;

@end

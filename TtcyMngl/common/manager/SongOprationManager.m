//
//  SongOprationManager.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-22.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongOprationManager.h"
#import "AccountManager.h"
#import "FMDBManager+CollectSong.h"
#import "HUD.h"
#import "DownloadListViewController.h"
#import "UserShareSDK.h"

playModeType playMode = playModeTypeOrder;

NSMutableArray * tmpPlayArray;
NSMutableArray * hisPlayArray;
NSMutableArray * collectArray;

@implementation SongOprationManager
+(void)collect:(operationType)type Song:(SongObject *)song callBack:(void (^)(BOOL))callBack
{
    AccountManager * aManager = [AccountManager shareInstance];
    if (aManager.status == onLine) {
        if (type == safe) {
            [[FMDBManager defaultManager] addCollectSong:song userID:aManager.currentAccount.phone callBack:^(BOOL isOK) {
                if (isOK) {
                    [HUD message:@"    "];
                }else{
                    [HUD message:@"    "];
                }
                callBack(isOK);
            }];
        }else{
            [[FMDBManager defaultManager] deleteCollectSongBySongName:song.songUrl userID:aManager.currentAccount.phone callBack:^(BOOL isOK) {
                if (isOK) {
                    [HUD message:@"    "];
                }else{
                    [HUD message:@" "];
                }
                callBack(isOK);
            }];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_SONG_COLLECTED object:nil];
    }else{
        [HUD message:@"  "];
    }
    
}
+ (void)download:(operationType)type Song:(SongObject *)song callBack:(void (^)(BOOL))callBack
{
    AccountManager * aManager = [AccountManager shareInstance];
    if (aManager.status == onLine) {
        if (type == safe) {
            [[DownloadListViewController shareInstance] setDownLoadObject:song];
            [HUD message:@"  "];
        }else{
            
        }
    }else{
        [HUD message:@"  "];
    }
}
+(void)clearQueue:(QueueType)queueType callBack:(void (^)(BOOL))callBack
{
    if (queueType == QueueTypeTempPlay) {
        tmpPlayArray = [NSMutableArray array];
    }else if (queueType == QueueTypeHistory){
        [[FMDBManager defaultManager] deleteAllPlayRecord];
    }else{
        AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
        [[FMDBManager defaultManager]deleteAllCollectSongWithuserID:acc.phone];
    }
    callBack(YES);
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_QUEUE_UPDATE object:nil];
}
+(void)setQueue:(QueueType)queueType withData:(NSMutableArray *)dataArray
{
    [SongOprationManager clearQueue:queueType callBack:^(BOOL isOK) {
        
    }];
    if (queueType == QueueTypeTempPlay) {
        tmpPlayArray = [NSMutableArray arrayWithArray:dataArray];
    }else if (queueType == QueueTypeHistory){
        for (SongObject * song in dataArray) {
            [[FMDBManager defaultManager] addPlayRecordSong:song];
        }
    }else{
        AccountInfo * acc = [[AccountManager shareInstance]currentAccount];
        for (SongObject * song in dataArray) {
            [[FMDBManager defaultManager] addCollectSong:song userID:acc.phone callBack:^(BOOL isOK) {
                
            }];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_QUEUE_UPDATE object:nil];
}
+(void)operation:(operationType)type song:(SongObject *)song withQueue:(QueueType)queueType callBack:(void (^)(BOOL))callBack
{
    if (queueType == QueueTypeTempPlay) {
        
        if (type == safe) {
            [tmpPlayArray addObject:song];
        }else{
            [tmpPlayArray removeObject:song];
        }
    }else if (queueType == QueueTypeHistory){
        
        if (type == safe) {
            [[FMDBManager defaultManager] addPlayRecordSong:song];
        }else{
            [[FMDBManager defaultManager] deletePlayRecordSongBySongUrl:song.songUrl];
        }
    }else{
        AccountInfo * acc = [[AccountManager shareInstance]currentAccount];
        if (type == safe) {
            [[FMDBManager defaultManager] addCollectSong:song userID:acc.phone callBack:^(BOOL isOK) {
                
            }];
        }else{
            [[FMDBManager defaultManager] deleteCollectSongBySongName:song.songUrl userID:acc.phone callBack:^(BOOL isOK) {
                
            }];
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_QUEUE_UPDATE object:nil];
    callBack(YES);
}
+ (BOOL)checkCollectedSong:(SongObject *)song withUser:(NSString *)userId
{
    return [[FMDBManager defaultManager] checkCollectSong:song withUser:userId];
}
+(NSMutableArray *)tmpPlayArray
{
    return tmpPlayArray;
}
+(NSMutableArray *)hisPlayArray
{
    return [[FMDBManager defaultManager]getPlayRecordList];
}
+(NSMutableArray *)collectArrayWithUserId:(NSString *)userId
{
    return [[FMDBManager defaultManager]getCollectSongListWithuserID:userId];
}
+ (void)shareSong:(SongObject *)song
{
    UserShareSDK *userSDK = [[UserShareSDK alloc] init];
    NSDictionary * songDict = [song dictionary];
    [userSDK shareSongWithDictionary:songDict];
}
+ (void)changePlayMode
{
    playMode ++;
    playMode %=2;
}
+ (playModeType)playMode
{
    return playMode;
}
@end

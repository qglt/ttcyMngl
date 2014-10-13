//
//  DownloadItem.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "SongObject.h"

typedef enum  {
    DownloadNotStart=0,
    DownloadWait=1,
    Downloading,
    DownloadPaused,
    DownloadFailed,
    DownloadFinished,
}DownloadItemState;

#define kDownloadItemStateChanaged @"DownloadItemStateChanged"
#define kDownloadItemProgressChanged @"DownloadItemProgressChanged"

@interface DownloadItem : ASIHTTPRequest<ASIProgressDelegate,ASIHTTPRequestDelegate>

@property(nonatomic,strong,setter = setDownLoadSong:)SongObject * downloadSong;
@property(nonatomic,assign)DownloadItemState downloadState;
@property(nonatomic,retain)NSString *downloadStateDescription;
@property(nonatomic,retain)NSDate *createDate;
@property(nonatomic,assign)double receivedLength;
@property(nonatomic,assign)double totalLength;
@property(nonatomic,assign)double downloadPercent;
@property(nonatomic,copy)void(^DownloadItemStateChangedCallback)(DownloadItem *callbackItem);
@property(nonatomic,copy)void(^DownloadItemProgressChangedCallback)(DownloadItem *callbackItem);


-(void)startDownloadTask;
-(void)pauseDownloadTask;
-(void)cancelDownloadTask;

+(NSString *)getDownloadStateDescriptionFromState:(DownloadItemState)state;

@end

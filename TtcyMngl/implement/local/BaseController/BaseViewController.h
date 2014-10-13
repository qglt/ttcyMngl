//
//  BaseViewController.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDBManager.h"
#import "FMDBManager+CollectSong.h"
#import "FMDBManager+DownloadSong.h"
#import "FMDBManager+PlayRecord.h"

#import "PlayBar.h"

typedef enum {
    ObjectTypeHistory,
    ObjectTypeCollect
}ObjectType;

@interface BaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *baseTableView;

@property (strong, nonatomic) NSString *songId;                        //歌曲ID,ipod歌曲没有
@property (strong, nonatomic) NSString *songName;                      //歌曲名称
@property (strong, nonatomic) NSString *artist;                        //歌手
@property (strong, nonatomic) NSMutableArray *arrayWithSongObject;            //歌曲对象数组

@property (strong, nonatomic) NSString *navigationBarTitle;            //导航栏标题

- (void)reloadSourceData;
- (ObjectType)getObjectType;

@end

//
//  DownloadListViewController.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "BaseViewController.h"

@interface DownloadListViewController : UIViewController

SINGLETON_DEFINE(DownloadListViewController)

-(void)setDownLoadObject:(SongObject *)obj;

@end

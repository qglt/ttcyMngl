//
//  MusicPlayerViewController.h
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayControlDelegate.h"
#import <ASIHTTPRequest.h>

@class SongObject;

@interface MusicPlayerViewController : UIViewController<PlayControlDelegate>

@property (nonatomic, copy) void (^hiddeButtonClicked)();

/**
 *@method : 初始化时传入 歌曲信息对象
 *
 *@param : obj -> 歌曲信息对象, controller -> 调用此方法的控制器
 *         调用方式： [[MusicPlayerViewController alloc] initWithSongObject:songObj andViewController:self];
 */
- (id)initWithSongObject:(SongObject *)obj andViewController:(UIViewController *)controller;




@end

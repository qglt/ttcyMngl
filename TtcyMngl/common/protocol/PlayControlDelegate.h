//
//  PlayControlDelegate.h
//  TtcyMngl
//
//  Created by admin on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SongObject;

@protocol PlayControlDelegate <NSObject>

@optional

- (void)plaBarHeadButtonPressed;

-(void)playQueueChanged:(NSArray *)songArray;

-(void)showBufferingHud:(BOOL)isShow;

-(void)refreshPlayTime:(NSInteger)time andDuration:(NSInteger)duration;

-(void)changeCurrentPlayingSong:(SongObject *)song;
/*
 *@method: 正在播放 status == 1
 *
 */
- (void)playerStatusChanged:(int)status;

@end

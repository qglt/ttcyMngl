//
//  PlayBar.h
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STKAudioPlayer.h>
#import "PlayControlDelegate.h"
#import "SongObject.h"
#import "DownloadItem.h"
#import "MenuItem.h"

@interface PlayBar : UIView<STKAudioPlayerDelegate>

@property (nonatomic, copy) void (^menuItemClick)(MenuItem *item);

@property (nonatomic,strong)NSMutableArray * menuItems;
@property (nonatomic,weak) __weak id<PlayControlDelegate> delegate;

/**
 *
 *@method  此方法只能再MainViewController里使用
 *
 */
+(PlayBar *)shareInstanceWithFrame:(CGRect)frame andAudioPlayer:(STKAudioPlayer *)audioPlayerIn menuItems:(NSArray *)items;

/**
 *@method : 一切从外部 对播放条进行实例化的都应该调用此方法
 *          它会返回当前的播放条（播放器）[[PlayBar defultPlayer] play:songObj];
 */
+(PlayBar *)defultPlayer;

/**
 *@method: 获取当前播放的音乐
 *
 */
-(SongObject *)getCurrentPlayingSong;
/**
 *@method: 获取当前播放队列数据
 *
 */
-(NSArray *)getPlayerQueueData;

/**
 *@method : 代理组，用于让所有响应者接受playBar广播的消息
 *
 *@param : listener 监听者，接受playBar发送的消息的对象
 *         想要接受消息就必须电泳此方法将自身家进监听者列表
 */
-(void)addListener:(id <PlayControlDelegate>)listener;
/**
 *@method: 从播放队列中删除一个项
 *
 */
-(void)delelteQueueWithItem:(SongObject *)obj;

/**
 *@method  全部从外部调用播放器 直接进行播放 音乐的 都使用此方法给播放器数据
 *
 *@param obj 封装好的歌曲信息对象
 *
 */
-(void)Play:(id)obj;

/**
 *  @method: 添加到播放队列，不不进行实时播放
 *  
 *  @param : 歌曲对象
 */
-(void)queue:(SongObject *)obj;

/**
 * @method: 清除播放队列的数据
 *
 */
-(void)clearQueue;

/**
 * @method:修改选中状态
 *
 */
- (void)setMenuItemSelected:( NSInteger)itemTag;
-(void) seekToTime:(double)value;
/**
 *
 * @ 以下方法除了MainViewController，其他地方不可调用
 */
-(void)resumeOrPause;
-(void)playPrevMusic;
-(void)playNextMusic;

@end

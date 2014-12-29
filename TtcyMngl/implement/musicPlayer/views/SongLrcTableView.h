//
//  SongLrcTableView.h
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongLrcTableView : UIView

- (id)initWithFrame:(CGRect)frame andRowHeight:(CGFloat)height;

-(void)reset;

/**
 *  更新歌词文件lrc
 *
 *  @param lrcFilePath 歌词文件路径,callback 回lrc文件里的时间列表
 */
-(void)refreshLrcDataWithFileName:(NSString *)lrcFileName;
- (void)refreshLrcDataWithLrcString:(NSString *)lrcString;
/**
 *  根据时间更新歌词显示情况
 *
 *  @param time  当前播放时间
 */
- (void)displaySondWord:(NSUInteger)time ;

-(void)showEmptyLabel:(BOOL)show;

@end

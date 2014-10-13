//
//  DownLoadInfoCell.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-11.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DownloadItem;

@interface DownLoadInfoCell : UITableViewCell

@property (strong, nonatomic)  UIButton *pauseButton;

@property (strong, nonatomic)  UIButton *cancelButton;

@property (strong, nonatomic)  UIProgressView *progress;

@property (strong, nonatomic)  UILabel *nameLabel;

@property (strong, nonatomic)  UILabel *progressLabel;

@property(nonatomic,strong)void(^DownSongCellBodyClick)(DownloadItem * downItem);
@property(nonatomic,strong)void(^DownSongCellOperateClick)(DownLoadInfoCell *cell);
@property(nonatomic,strong)void(^DownSongCellCancelClick)(DownLoadInfoCell *cell);

@end

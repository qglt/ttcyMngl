//
//  SongInfoView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongObject;

@protocol  SongInfoViewDelegate <NSObject>

@optional
- (void)infoViewDownloadButtonPressed:(SongObject *)song;
- (void)infoViewGoArtlistButtonPressed:(SongObject *)song;
- (void)infoViewGoAlbumButtonPressed:(SongObject *)song;

@end

@interface SongInfoView : UIView

@property (nonatomic,weak)__weak id<SongInfoViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame Song:(SongObject *)song;

-(void)refreshData:(SongObject *)song;

- (void)setAnimate:(BOOL)animate;

@end

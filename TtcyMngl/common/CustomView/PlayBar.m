//
//  PlayBar.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "PlayBar.h"
#import "QueueItemId.h"
#import <UIImageView+WebCache.h>
#import "FMDBManager+PlayRecord.h"
#import "FMDBManager+CollectSong.h"
#import "AccountManager.h"
#import "SongOprationManager.h"
#import <STKLocalFileDataSource.h>

#define headBtnTag   2000

#define playBtnTag   2002
#define nextBtnTag   2003
#define proivBtnTag  2005

@interface PlayBar ()
{
    double _duration;
    NSTimer * timer;
    int currentIndex;

    BOOL autoPlay;
    BOOL sendToBack;
    BOOL playState;
}
@property (nonatomic,strong)NSMutableArray *listenerArray;

@property (nonatomic,strong)UIButton * headImage;

@property (nonatomic,strong) NSMutableArray * queueSongArray;

@property (nonatomic, strong) STKAudioPlayer* audioPlayer;

@end


@implementation PlayBar
@synthesize audioPlayer;

PlayBar * instence = nil;
+(PlayBar *)shareInstanceWithFrame:(CGRect)frame andAudioPlayer:(STKAudioPlayer *)audioPlayerIn menuItems:(NSArray *)items
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instence = [[PlayBar alloc]initWithFrame:frame andAudioPlayer:audioPlayerIn menuItems:items];
    });
    return instence;
}
- (id)initWithFrame:(CGRect)frame andAudioPlayer:(STKAudioPlayer *)audioPlayerIn menuItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LOG_GENERAL_INFO(@"audio player pending queue is:%@",audioPlayerIn.pendingQueue);
        
        self.audioPlayer = audioPlayerIn;
        self.menuItems = [NSMutableArray arrayWithArray:items];
        
        [self getCurrentPlayIndex];
        
        [self setBaseCondition];
        
        [self createMenuButton];
        
        [self createHeadImage];
        
        [self createPlayButton];
        
//        [self createProgressView];
        
        [self getPlayQueueData];
        
        [self setupTimer];
    }
    return self;
}
+(PlayBar *)defultPlayer
{
    return instence;
}

#pragma mark - initalize Methods
-(void) setAudioPlayer:(STKAudioPlayer*)value
{
	if (audioPlayer)
	{
		audioPlayer.delegate = nil;
	}
    
	audioPlayer = value;
	audioPlayer.delegate = self;
}
-(void)getPlayQueueData
{
    if (_queueSongArray.count != 0) {
        [_queueSongArray removeAllObjects];
    }
    self.queueSongArray = [SongOprationManager hisPlayArray];
    if (_queueSongArray.count != 0) {
        [self setPlayerData:currentIndex];
    }
}
-(void)getCurrentPlayIndex
{
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"history_play_index" ofType:@"plist"]];
    currentIndex = [[dict objectForKey:@"index"] intValue];
}
-(void)setBaseCondition
{
    self.backgroundColor = [UIColor colorWithWhite:.2f alpha:.5f];
    self.listenerArray = [NSMutableArray array];
    self.queueSongArray = [NSMutableArray array];
    sendToBack = NO;
}
-(void)createMenuButton
{
    CGRect rect = CGRectMake(0, 0, self.frame.size.width/2.0, self.frame.size.height);
    
    CGFloat x = kMainScreenWidth/(self.menuItems.count * 2);
    int operation = 1;
    for (int i = 0; i<_menuItems.count; i++) {
        operation *= -1;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        button.center = CGPointMake(x, rect.size.height/2.0f);
        button.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18.0f];
        
        [button setTitleColor:[Utils colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        
        [button setTitle:((MenuItem *)_menuItems[i]).title forState:UIControlStateNormal];
        button.tag = ((MenuItem *)_menuItems[i]).tag;
        
        button.backgroundColor = [UIColor clearColor];
        button.titleLabel.numberOfLines = 0;
        [button setShowsTouchWhenHighlighted:YES];
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, operation*30, 0, 0)];
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).icon] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:((MenuItem *)_menuItems[i]).h_icon] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        x+=kMainScreenWidth/self.menuItems.count;
    }

}
-(void)createHeadImage
{
    self.headImage = [UIButton buttonWithType:UIButtonTypeCustom];
    _headImage.frame = CGRectMake(0, 0, self.bounds.size.height*3/2.f, self.bounds.size.height*3/2.f);
    [_headImage addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headImage setBackgroundImage:[UIImage imageNamed:@"players_img_default"] forState:UIControlStateNormal];
    
    _headImage.layer.cornerRadius = _headImage.frame.size.width/2.0f;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImage.layer.borderWidth = 1.f;
    
    _headImage.center = CGPointMake(self.center.x, self.frame.size.height/4.0f);
    _headImage.tag = headBtnTag;
    [_headImage setShowsTouchWhenHighlighted:YES];
    [self addSubview:_headImage];
    _headImage.backgroundColor = [UIColor clearColor];
}
- (void)createPlayButton
{
    UIButton * play = [UIButton buttonWithType:UIButtonTypeCustom];
    play.frame = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);
    
    play.layer.cornerRadius = play.frame.size.width/2.0f;
    play.layer.masksToBounds = YES;
    play.layer.borderColor = [UIColor whiteColor].CGColor;
    
    play.center = CGPointMake(self.center.x, self.frame.size.height/4.0f);
    [play addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    play.tag = playBtnTag;
    
    [play setImage:[UIImage imageNamed:@"all_play_h"] forState:UIControlStateNormal];
    [play setImage:[UIImage imageNamed:@"all_play_h"] forState:UIControlStateSelected];
    
    [self addSubview:play];
    [play setShowsTouchWhenHighlighted:YES];
    [self changePlaybtnImage];
}
#pragma mark - listener methods
-(void)addListener:(id<PlayControlDelegate>)listener
{
    if (_listenerArray.count>0) {
        BOOL flag = NO;
        for (id <PlayControlDelegate> d in _listenerArray) {
            if ([d isEqual:listener]) {
                flag = YES;
                break;
            }
        }
        if (flag == NO) {
            [_listenerArray addObject:listener];
        }
    }else{
        [_listenerArray addObject:listener];
    }
    LOG_GENERAL_INFO(@"成功添加监听者 %@",listener);
}

#pragma mark - opration methods
-(void) seekToTime:(double)value
{
    if (!audioPlayer)
	{
		return;
	}
	
	[audioPlayer seekToTime:value];
}
-(void) setupTimer
{
	timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(tick) userInfo:nil repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void) tick
{
	if (!audioPlayer)
    {
		return;
	}
	
    if (audioPlayer.duration != 0)
    {
        [self broadPlayerProgressTime];
    }

    if (playState) {
        _headImage.transform = CGAffineTransformRotate(_headImage.transform, M_PI*0.01/3.f);
    }
}
-(void)broadPlayerProgressTime
{
    for (id<PlayControlDelegate> listener in _listenerArray) {
        
        if ([listener respondsToSelector:@selector(refreshPlayTime:andDuration:)]) {
            [listener refreshPlayTime:audioPlayer.progress andDuration:audioPlayer.duration];
        }
    }
}
-(void)ButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case headBtnTag:
        {
            [self.delegate plaBarHeadButtonPressed];
        }break;
            
        case playBtnTag:
        {
            [self changePlaybtnImage];
            [self resumeOrPause];
        }break;
            
        default:
            break;
    }
}
- (void)menuButtonPressed:(UIButton *)sender
{
    _menuItemClick(_menuItems[sender.tag-10000]);
}
- (void)setMenuItemSelected:( NSInteger)itemTag
{
    for (UIButton * button in self.subviews) {
        if (button.tag != playBtnTag) {
            button.backgroundColor = NVC_UNSELECTED_BACKGROUND;
        }
    }
    UIButton * button = (UIButton *)[self viewWithTag:itemTag];
    button.backgroundColor = NVC_SELECTED_BACKGROUND;
}
-(void)changePlaybtnImage
{
    UIButton * sender = (UIButton *)[self viewWithTag:playBtnTag];
    
    if (audioPlayer.state == STKAudioPlayerStatePaused) {
        sender.hidden = NO;
    }else{
        sender.hidden = YES;
    }
}
-(void)changeHeadImage
{
    UIImageView * image = [[UIImageView alloc]initWithFrame:_headImage.bounds];
    if (_queueSongArray.count >0) {
        SongObject * obj = _queueSongArray[currentIndex];
        [image sd_setImageWithURL:[NSURL URLWithString:obj.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    }else{
        image.image = [UIImage imageNamed:@"players_img_default"];
    }
    [_headImage addSubview:image];
}
#pragma mark - player control methods－－－－－－－－－－－－－－

-(void)playPrevMusic
{
    if (_queueSongArray.count>0) {
        autoPlay = NO;
        if ([SongOprationManager playMode] == playModeTypeOrder) {
            currentIndex = currentIndex + (int)_queueSongArray.count - 1;
            currentIndex %= (int)_queueSongArray.count;
            [audioPlayer clearQueue];
            [self setPlayerData:currentIndex];
        }else{
            currentIndex = arc4random()%_queueSongArray.count;
            [audioPlayer clearQueue];
            [self setPlayerData:currentIndex];
        }
        
    }
}
-(void)resumeOrPause
{
	if (!audioPlayer)
	{
		return;
	}
	if (audioPlayer.state == STKAudioPlayerStatePaused)
	{
		[audioPlayer resume];
        playState = YES;
	}
	else
	{
		[audioPlayer pause];
        playState = NO;
	}
}
-(void)playNextMusic
{
    if (_queueSongArray.count>0) {
        autoPlay = NO;
        if ([SongOprationManager playMode] == playModeTypeOrder) {
            currentIndex ++;
            currentIndex %= (int)_queueSongArray.count;
            [audioPlayer clearQueue];
            [self setPlayerData:currentIndex];
        }else{
            currentIndex = arc4random()%_queueSongArray.count;
            [audioPlayer clearQueue];
            [self setPlayerData:currentIndex];
        }
    }
}
#pragma mark - setUpMethods
-(int)checkQueueEncomPassingAsong:(SongObject *)song
{
    for (int i=0; i<_queueSongArray.count;i++) {
        
        if ([[_queueSongArray[i] description] isEqualToString:[song description]]) {
            return i;
        }
    }
    return -1;
}
-(void)Play:(id )obj
{
    if (obj) {
        autoPlay = NO;
        int flag = [self checkQueueEncomPassingAsong:obj];
        
        if ( flag == -1) {
            [audioPlayer clearQueue];
            currentIndex = (int)_queueSongArray.count;
            [self queue:obj];
            
            for (id<PlayControlDelegate> listener in _listenerArray) {
                if ([listener respondsToSelector:@selector(changeCurrentPlayingSong:)]) {
                    [listener changeCurrentPlayingSong:_queueSongArray[currentIndex]];
                }
            }
        }else{
            currentIndex = flag;
        }
        [self changeHeadImage];
        [self setPlayerData:currentIndex];
    }
}
-(void)queue:(SongObject *)obj
{
    autoPlay = NO;
    [SongOprationManager operation:safe song:obj withQueue:QueueTypeHistory callBack:^(BOOL isOK) {
        _queueSongArray = [SongOprationManager hisPlayArray];
        for (id <PlayControlDelegate> listener in _listenerArray) {
            if ([listener respondsToSelector:@selector(playQueueChanged:)]) {
                [listener playQueueChanged:_queueSongArray];
            }
        }
    }];
}
-(void)clearQueue
{
    [audioPlayer clearQueue];
   
    [SongOprationManager clearQueue:QueueTypeHistory callBack:^(BOOL isOK) {
       [self getPlayQueueData];
    }];
}
-(SongObject *)getCurrentPlayingSong
{
    if (_queueSongArray.count >0) {
        return _queueSongArray[currentIndex];
    }
    return nil;
}
-(NSArray *)getPlayerQueueData
{
    return _queueSongArray;
}
-(void)delelteQueueWithItem:(SongObject *)obj
{
    int i = [self checkQueueEncomPassingAsong:obj];
    if ( i!= -1) {
        [SongOprationManager operation:unSafe song:obj withQueue:QueueTypeHistory callBack:^(BOOL isOK) {
            [self getPlayQueueData];
        }];
        autoPlay = NO;
        if (_queueSongArray.count == 0) {
            [audioPlayer stop];
        }else {
            if (i == currentIndex) {
                currentIndex --;
                [self playNextMusic];
            }
        }
    }
    [self getPlayQueueData];
}
-(void)setPlayerData:(int)index
{
    SongObject * obj = (SongObject *)_queueSongArray[index];
    NSLog(@"------%@",[obj.songUrl substringToIndex:1]);
    if (!([obj.songUrl isKindOfClass:[NSNull class]]||obj.songUrl == nil || [@"" isEqualToString:obj.songUrl])) {
        
        NSURL* url = [NSURL URLWithString:obj.songUrl];
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        if (![@"h" isEqualToString:[obj.songUrl substringToIndex:1]]) {
            url = [NSURL fileURLWithPath:obj.songUrl];
            dataSource = [[STKLocalFileDataSource alloc] initWithFilePath:url.path];
        }
        [audioPlayer setDataSource:dataSource withQueueItemId:[[QueueItemId alloc] initWithUrl:url andCount:index]];
    }
}
#pragma mark - STKAudioPlayerDelegate methods
-(void) audioPlayer:(STKAudioPlayer *)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    [self.delegate showBufferingHud:(state == STKAudioPlayerStateBuffering)];
    [self changePlaybtnImage];
    if (state == STKAudioPlayerStatePlaying) {
        playState = YES;
    }else{
        playState = NO;
    }
    for (id<PlayControlDelegate> listener in _listenerArray) {
        if ([listener respondsToSelector:@selector(playerStatusChanged:)]) {
            [listener playerStatusChanged:playState];
        }
    }
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
	
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    [self changeHeadImage];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didStartPlaying" object:_queueSongArray[currentIndex]];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    autoPlay = YES;
    [self changePlaybtnImage];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    [self changePlaybtnImage];
    QueueItemId* queueId = (QueueItemId*)queueItemId;
    if (autoPlay) {
        if ([SongOprationManager playMode] == playModeTypeOrder) {
            
            currentIndex = queueId.count + 1;
            if (currentIndex == _queueSongArray.count) { //循环播放
                currentIndex = 0;
            }
            [self setPlayerData:currentIndex];
        }else{
            int v = arc4random()%_queueSongArray.count;
            currentIndex = v;
            [self setPlayerData:currentIndex];
        }
        
    }
    if (_queueSongArray.count>0) {
        for (id<PlayControlDelegate> listener in _listenerArray) {
            if ([listener respondsToSelector:@selector(changeCurrentPlayingSong:)]) {
                [listener changeCurrentPlayingSong:_queueSongArray[currentIndex]];
            }
        }
    }
}

-(void) audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
    LOG_GENERAL_ERROR(@"%@", line);
}
@end

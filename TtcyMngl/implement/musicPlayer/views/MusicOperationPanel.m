//
//  MusicOperationPanel.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-17.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MusicOperationPanel.h"
#import "PlayBar.h"
#import "PlayControlDelegate.h"

#define COLLECT_SONG 100
#define SHARE_SONG   101
#define PLAY_MODE    102
#define TAG_HIDDE    103
#define TAG_DOWNLOAD 104

@interface MusicOperationPanel()

@property (nonatomic,strong)UIButton * playButton;
@property (nonatomic,strong)UISlider * slider;
@property (nonatomic,strong)UILabel * frameTimeLabel;
@property (nonatomic,strong)UILabel * playTimeLabel;

@end

@implementation MusicOperationPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBaseCondition];
        
        [self createProgressView];
        [self createPlayTimeLabel];
        [self createFrameTimeLabel];
        
        [self createPlayButton];
        [self createPlayProivButton];
        [self createPlayNextButton];
        
        [self createCollectButton];
        [self createShareButton];
        [self createPlayModeButton];
        [self createDownloadButton];
    }
    return self;
}
- (void)setBaseCondition
{
    getPlayBarHeight()
    self.backgroundColor = [UIColor colorWithWhite:0.f alpha:.3f];
}
#pragma mark - 初始化——————基本控件 －－－－－－－－－－－－－－－－－－
-(void)createProgressView
{
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(35,-10.f, kMainScreenWidth-70, 30)];
    _slider.continuous = YES;
    [_slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    _slider.minimumValue = 0;
    _slider.maximumValue = 1;
    _slider.value = .5f;
    [_slider setMinimumTrackImage:[UIImage imageNamed:@"slider_play"] forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:[UIImage imageNamed:@"slider_bar"] forState:UIControlStateNormal];
    
    [_slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"slider_thumb"] forState:UIControlStateHighlighted];
    
    [self addSubview:_slider];
}
-(void)createPlayTimeLabel
{
    self.playTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 10)];
    _playTimeLabel.backgroundColor = [UIColor clearColor];
    _playTimeLabel.textColor = [UIColor whiteColor];
    _playTimeLabel.textAlignment = NSTextAlignmentCenter;
    _playTimeLabel.font = [UIFont systemFontOfSize:12];
    _playTimeLabel.text = @"00:00";
    [self addSubview:_playTimeLabel];
    
}
- (void)createFrameTimeLabel
{
    self.frameTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width - 35, 0, 35, 12)];
    _frameTimeLabel.backgroundColor = [UIColor clearColor];
    _frameTimeLabel.textColor = [UIColor whiteColor];
    _playTimeLabel.textAlignment = NSTextAlignmentCenter;
    _frameTimeLabel.font = [UIFont systemFontOfSize:12];
    _frameTimeLabel.text = @"00:00";
    [self addSubview:_frameTimeLabel];
}
#pragma mark - 初始化——————操作 buttons －－－－－－－－－－－－－－－－－－－－
- (void)createPlayButton
{
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(0, 0, PlayBarHeight, PlayBarHeight);
    
    _playButton.layer.cornerRadius = _playButton.frame.size.width/2.0f;
    _playButton.layer.masksToBounds = YES;
    _playButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _playButton.layer.borderWidth = 2;
    
    _playButton.backgroundColor = [UIColor colorWithWhite:.7 alpha:.4];
    _playButton.center = CGPointMake(self.center.x, self.frame.size.height/2.0+5.f);
    [_playButton addTarget:[PlayBar defultPlayer] action:@selector(resumeOrPause) forControlEvents:UIControlEventTouchUpInside];
    [_playButton setShowsTouchWhenHighlighted:YES];
    
    [_playButton setImage:[UIImage imageNamed:@"play_play"] forState:UIControlStateNormal];
    [_playButton setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -3)];
    
    [self addSubview:_playButton];
}
- (void)createPlayNextButton
{
    UIButton * next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(0, 0, PlayBarHeight*2/3.f, PlayBarHeight*2/3.f);
    
    next.layer.cornerRadius = next.frame.size.width/2.0f;
    next.layer.masksToBounds = YES;
    next.layer.borderColor = [UIColor whiteColor].CGColor;
    next.layer.borderWidth = 2;
    
    next.backgroundColor = [UIColor colorWithWhite:.7 alpha:.4];
    next.center = CGPointMake(self.center.x + (PlayBarHeight*5/3)/2.f+25, self.frame.size.height/2.0f+10);
    [next addTarget:[PlayBar defultPlayer] action:@selector(playNextMusic) forControlEvents:UIControlEventTouchUpInside];
    [next setShowsTouchWhenHighlighted:YES];
    
    [next setImage:[UIImage imageNamed:@"play_next"] forState:UIControlStateNormal];
    
    [self addSubview:next];
}
- (void)createPlayProivButton
{
    UIButton * Proiv = [UIButton buttonWithType:UIButtonTypeCustom];
    Proiv.frame = CGRectMake(0, 0, PlayBarHeight*2/3.f, PlayBarHeight*2/3.f);
    
    Proiv.layer.cornerRadius = Proiv.frame.size.width/2.0f;
    Proiv.layer.masksToBounds = YES;
    Proiv.layer.borderColor = [UIColor whiteColor].CGColor;
    Proiv.layer.borderWidth = 2;
    
    Proiv.backgroundColor = [UIColor colorWithWhite:.7 alpha:.4];
    Proiv.center = CGPointMake(self.center.x - ((PlayBarHeight*5/3)/2.f+25), self.frame.size.height/2.0f+10);
    [Proiv addTarget:[PlayBar defultPlayer] action:@selector(playPrevMusic) forControlEvents:UIControlEventTouchUpInside];
    [Proiv setShowsTouchWhenHighlighted:YES];
    
    [Proiv setImage:[UIImage imageNamed:@"play_prev"] forState:UIControlStateNormal];
    
    [self addSubview:Proiv];
}
#pragma mark - 初始化——————扩展操作 buttons －－－－－－－－－－－－－－－－
- (void)createDownloadButton
{
    UIButton * down = [UIButton buttonWithType:UIButtonTypeCustom];
    
    down.frame = CGRectMake( 0,0,25.f,25.f);
    
    down.backgroundColor = [UIColor clearColor];
    down.center = CGPointMake(self.bounds.size.width*7.2/8.f, self.frame.size.height*3/4.0f);
    down.tag = TAG_DOWNLOAD;
    [down addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [down setShowsTouchWhenHighlighted:YES];
    
    [down setBackgroundImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    
    [self addSubview:down];
}
- (void)createCollectButton
{
    UIButton * collect = [UIButton buttonWithType:UIButtonTypeCustom];
    collect.frame = CGRectMake(0, 0, 25, 25);
    
    collect.backgroundColor = [UIColor clearColor];
    collect.center = CGPointMake(self.bounds.size.width*7.2/8.f, self.frame.size.height*1.5f/4.0f);
    
    collect.tag = COLLECT_SONG;
    [collect addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [collect setShowsTouchWhenHighlighted:YES];
    
    [collect setImage:[UIImage imageNamed:@"collect_bar_unselected"] forState:UIControlStateNormal];
    
    [self addSubview:collect];
}
- (void)createShareButton
{
    UIButton * share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 25,20);
    
    share.backgroundColor = [UIColor clearColor];
    share.center = CGPointMake(self.bounds.size.width*.8f/8.f, self.frame.size.height*1.5/4.0f);
    share.tag = SHARE_SONG;
    [share addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [share setShowsTouchWhenHighlighted:YES];
    
    [share setBackgroundImage:[UIImage imageNamed:@"share_bar"] forState:UIControlStateNormal];
    [self addSubview:share];
}

- (void)createPlayModeButton
{
    UIButton * mode = [UIButton buttonWithType:UIButtonTypeCustom];
    mode.frame = CGRectMake(0, 0, 80, 80);
    
    mode.backgroundColor = [UIColor clearColor];
    mode.center = CGPointMake(self.bounds.size.width*0.8/8.f, self.frame.size.height*3/4.0f+4);
    mode.tag = PLAY_MODE;
    [mode addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [mode setShowsTouchWhenHighlighted:YES];
    
    [mode setBackgroundImage:[UIImage imageNamed:@"play_mode_xunhuan"] forState:UIControlStateNormal];
    //    [down setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
    [self addSubview:mode];
}
#pragma mark - 辅助方法 －－－－－－－－－－－－－－－－－－－

-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
#pragma mark - Setter and refreash methods -------------------------
-(void)refreshSliderWithProgress:(NSInteger)progress duration:(NSInteger)duration
{
    _playTimeLabel.text = [self formatTimeFromSeconds:progress];
    _frameTimeLabel.text = [self formatTimeFromSeconds:duration];
    _slider.maximumValue = duration;
    _slider.value = progress;
}
-(void)setPlayModeState:(int)modeState
{
    UIButton * mode = (UIButton *)[self viewWithTag:PLAY_MODE];
    if (modeState == 2) {
        [mode setBackgroundImage:[UIImage imageNamed:@"play_mode_xunhuan"] forState:UIControlStateNormal];
    }else if (modeState == 1) {
        [mode setBackgroundImage:[UIImage imageNamed:@"play_mode_suiji"] forState:UIControlStateNormal];
    }else{
        [mode setBackgroundImage:[UIImage imageNamed:@"play_mode_shunxu"] forState:UIControlStateNormal];
    }
}
-(void)setPlayState:(int)playState
{
    if (playState) {
        [_playButton setImage:[UIImage imageNamed:@"all_stop_h"] forState:UIControlStateNormal];
        [_playButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }else{
        [_playButton setImage:[UIImage imageNamed:@"play_play"] forState:UIControlStateNormal];
        [_playButton setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -3)];
    }
}
- (void)setCollectButtonImage:(NSString *)imageName
{
    UIButton * collect = (UIButton *)[self viewWithTag:COLLECT_SONG];
    [collect setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
#pragma mark - 控件操作触发方法 －－－－－－－－－－－－－－－－－－－－－
-(void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case COLLECT_SONG:
        {
            [self.delegate operationPanelCollectButtonPressed];
            
        }break;
        case SHARE_SONG:
        {
            [self.delegate operationPanelSahareButtonPressed];
            
        }break;
        case PLAY_MODE:
        {
            [self.delegate operationPanelPlayModeButtonPressed];
        }break;
        case TAG_HIDDE:
        {
            [self.delegate operationPanelHiddeButtonPressed];
        }break;
        case TAG_DOWNLOAD:
        {
            [self.delegate operationPanelDownloadButtonPressed];
        }break;
        default:
            break;
    }
}
-(void)sliderChanged
{
    [self.delegate operationPanelSliderValueChanged:_slider.value];
}

@end



















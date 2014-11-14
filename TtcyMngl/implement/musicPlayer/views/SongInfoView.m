//
//  SongInfoView.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongInfoView.h"
#import "SongObject.h"
#import <UIImageView+WebCache.h>
#import "ScrollLabel.h"

#define TAG_DOWNLOAD    100
#define TAG_GO_ARTLIST  101
#define TAG_GO_ALBUM    102

@interface SongInfoView ()
{
    BOOL _animate;
    NSTimer * timer;
    BOOL _lastNeedState;
}
@property (nonatomic,weak)SongObject * currentSong;
@property (nonatomic,strong)UIImageView * artImage;
@property (nonatomic,strong)ScrollLabel * artLabel;
@property (nonatomic,strong)ScrollLabel * songLabel;
@property (nonatomic,strong)ScrollLabel * albumLabel;
@property (nonatomic,strong)UIImageView * headBG;
@property (nonatomic,strong)UIImageView * armNeddle;

@end

@implementation SongInfoView

- (id)initWithFrame:(CGRect)frame Song:(SongObject *)song
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.currentSong = song;
        
        [self setBaseCondition];
        
        [self createArtistsImage];
        
        [self createArmNeddle];
        
        [self createSongNameLabel];
        
        [self createAlbumLabel];

        [self updateSubViews];
        
        [self setupTimer];
    }
    return self;
}

#pragma mark - 初始化子视图方法

-(void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
    _lastNeedState = YES;
    getPlayBarHeight()
    getTopDistance();
}
-(void)createArtistsImage
{
    self.headBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    _headBG.image = [UIImage imageNamed:@"playinfo_headBG"];
    _headBG.layer.cornerRadius = 100.f;
    _headBG.layer.masksToBounds = YES;

    if (is4Inch) {
        _headBG.center = CGPointMake(self.bounds.size.width - 20 - _headBG.bounds.size.width/2.f, self.bounds.size.height/2.f+10);
    }else{
        _headBG.center = CGPointMake(self.bounds.size.width - 20 - _headBG.bounds.size.width/2.f, self.bounds.size.height/2.f+35);
    }
    [self addSubview:_headBG];
    
    self.artImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    [_artImage sd_setImageWithURL:[NSURL URLWithString:_currentSong.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"main_logo"]];
    _artImage.center = CGPointMake( _headBG.bounds.size.width/2.f,_headBG.bounds.size.height/2.f);
    _artImage.layer.cornerRadius = _artImage.frame.size.width/2.0f;
    _artImage.layer.masksToBounds = YES;
    _artImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _artImage.layer.shadowOffset = CGSizeMake(3, 3);
    _artImage.layer.shadowOpacity = .5f;
    _artImage.layer.shadowRadius = _artImage.frame.size.width/2.0f;
    
    [_headBG addSubview:_artImage];
}
- (void)createArmNeddle
{
    self.armNeddle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"player_arm"]];
    if (is4Inch) {
         _armNeddle.frame = CGRectMake(_headBG.center.x-56-15, 25, 45, 112);
    }else{
         _armNeddle.frame = CGRectMake(_headBG.center.x-56-15, 25, 45, 102);
    }
   
    _armNeddle.center = CGPointMake(_headBG.center.x, _armNeddle.bounds.size.height/2.f+35.f);
    [self addSubview:_armNeddle];
}
-(void)createAlbumLabel
{
    CGFloat width = _artLabel.frame.size.height;
    CGFloat height = _artLabel.frame.size.width;
    
    self.albumLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(0, 0, width,height)];
    _albumLabel.backgroundColor = [UIColor clearColor];
    _albumLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    
    _albumLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _albumLabel.center = CGPointMake(_artImage.frame.origin.x + _artImage.frame.size.width - _albumLabel.frame.size.width/2.0f, _artLabel.center.y);
    [self addSubview:_albumLabel];
}
-(void)createSongNameLabel
{
    self.songLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height-60,30)];
    _songLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    _songLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _songLabel.frame = CGRectMake(5, 30, 30, self.bounds.size.height-60);
    _songLabel.textColor = [Utils colorWithHexString:@"#22C5DF"];
    [self addSubview:_songLabel];
}

- (void)createDownloadButton
{
    UIButton * down = [UIButton buttonWithType:UIButtonTypeCustom];
    
    down.frame = CGRectMake( 0,0,30.f,30.f);
    
    down.backgroundColor = [UIColor clearColor];
    down.center = CGPointMake(self.bounds.size.width/4.0f, kMainScreenHeight-PlayBarHeight*2-80.f);
    down.tag = TAG_DOWNLOAD;
    [down addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [down setShowsTouchWhenHighlighted:YES];
    
    [down setBackgroundImage:[UIImage imageNamed:@"down_info_unselected"] forState:UIControlStateNormal];
    [down setBackgroundImage:[UIImage imageNamed:@"down_info_selected"] forState:UIControlStateHighlighted];

    [self addSubview:down];
}

#pragma mark - 设置内容方法
-(void)refreshData:(SongObject *)song
{
    self.currentSong = song;
    [self updateSubViews];
}
-(void)updateSubViews
{
    if (![Utils isEmptyString:_currentSong.imageUrl]) {
        [_artImage sd_setImageWithURL:[NSURL URLWithString:_currentSong.imageUrl] placeholderImage:[UIImage imageNamed:@"main_logo"]];
        
    }else if (![Utils isEmptyString:_currentSong.avatarImageUrl]) {
        
        [_artImage sd_setImageWithURL:[NSURL URLWithString:_currentSong.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"main_logo"]];
    }
    
    _artLabel.text = [@": " stringByAppendingString:_currentSong.artist];
    _songLabel.text = [NSString stringWithFormat:@"%@ —— %@",_currentSong.songName,_currentSong.artist];
    if (![Utils isEmptyString:_currentSong.albumTitle]) {
        _albumLabel.text = [@": " stringByAppendingString:_currentSong.albumTitle];
        _artLabel.center = CGPointMake(_artImage.frame.origin.x + _artLabel.frame.size.width/2.0f, _artImage.frame.origin.y + _artImage.frame.size.height + 20 + _artLabel.frame.size.height/2.0f);
    }else{
        _albumLabel.text = @"";
        CGPoint center = _artLabel.center;
        center.x = _artImage.center.x;
        _artLabel.center = center;
    }
}
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_DOWNLOAD:
        {
            if ([self.delegate respondsToSelector:@selector(infoViewDownloadButtonPressed:)]) {
                [self.delegate infoViewDownloadButtonPressed:_currentSong];
            }
        }break;
        case TAG_GO_ARTLIST:
        {
            if ([self.delegate respondsToSelector:@selector(infoViewGoArtlistButtonPressed:)]) {
                [self.delegate infoViewGoArtlistButtonPressed:_currentSong];
            }
        }break;
        case TAG_GO_ALBUM:
        {
            if ([self.delegate respondsToSelector:@selector(infoViewGoAlbumButtonPressed:)]) {
                [self.delegate infoViewGoAlbumButtonPressed:_currentSong];
            }
        }break;
            
        default:
            break;
    }
}
- (void)setAnimate:(BOOL)animate
{
    _animate = animate;
    if (animate != _lastNeedState) {
        _lastNeedState = animate;
        [self setArmNeed:_lastNeedState];
    }
}
-(void) setupTimer
{
    timer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void) tick
{
    if (_animate) {
        _headBG.transform = CGAffineTransformRotate(_headBG.transform, M_PI*0.006/3.f);
    }
}
- (void)setArmNeed:(BOOL)need
{
    _armNeddle.layer.position = CGPointMake(_headBG.center.x-15, 25.f);
    _armNeddle.layer.anchorPoint = CGPointMake(.5f, .1f);
    if (need) {
        [UIView animateWithDuration:.5f animations:^{
            _armNeddle.layer.transform = CATransform3DRotate(_armNeddle.layer.transform,M_PI_4, .0f, 0.0f, 1.0f);
        }];
    }else{
        [UIView animateWithDuration:.5f animations:^{
            _armNeddle.layer.transform = CATransform3DRotate(_armNeddle.layer.transform,-M_PI_4, .0f, 0.0f, 1.0f);
        }];
    }
}
@end








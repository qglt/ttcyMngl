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

@property (nonatomic,weak)SongObject * currentSong;

@property (nonatomic,strong)UIImageView * artImage;
@property (nonatomic,strong)ScrollLabel * artLabel;
@property (nonatomic,strong)ScrollLabel * songLabel;
@property (nonatomic,strong)ScrollLabel * albumLabel;

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
        
        [self createArtNameLabel];
        
        [self createSongNameLabel];

        [self createDownloadButton];
        
        [self createAlbumLabel];

        [self updateSubViews];
        
    }
    return self;
}

#pragma mark - 初始化子视图方法

-(void)setBaseCondition
{
    self.backgroundColor = [UIColor clearColor];
    getPlayBarHeight()
    getTopDistance();
}
-(void)createArtistsImage
{
    self.artImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_artImage sd_setImageWithURL:[NSURL URLWithString:_currentSong.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    _artImage.center = CGPointMake( self.frame.size.width - _artImage.frame.size.width/2.f-40.f,_artImage.frame.size.height/2.f+20);
    
    _artImage.layer.cornerRadius = _artImage.frame.size.width/2.0f;
    _artImage.layer.masksToBounds = YES;
    _artImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _artImage.layer.shadowOffset = CGSizeMake(3, 3);
    _artImage.layer.shadowOpacity = .5f;
    _artImage.layer.shadowRadius = _artImage.frame.size.width/2.0f;
    
    [self addSubview:_artImage];
}
-(void)createArtNameLabel
{
    self.artLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.height*2/5.0f,40.f)];
    _artLabel.backgroundColor = [UIColor clearColor];
    _artLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    
    _artLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    _artLabel.center = CGPointMake(_artImage.frame.origin.x + _artLabel.frame.size.width/2.0f, _artImage.frame.origin.y + _artImage.frame.size.height + 20 + _artLabel.frame.size.height/2.0f);
    [self addSubview:_artLabel];
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
    CGFloat width = _artLabel.frame.size.height + 60;
    CGFloat height = 60.f;
    
    self.songLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(60, 0, width,height)];
    _songLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:25.0f];
    _songLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _songLabel.center = CGPointMake(self.bounds.size.width/4.0f, _artImage.frame.origin.y+_artImage.frame.size.height/2.f + _songLabel.frame.size.height/2.0f);
    [self addSubview:_songLabel];
}

- (void)createDownloadButton
{
    UIButton * down = [UIButton buttonWithType:UIButtonTypeCustom];
    
    down.frame = CGRectMake( 0,0,30.f,30.f);
    
    down.backgroundColor = [UIColor clearColor];
    down.center = CGPointMake(self.bounds.size.width/4.0f, kMainScreenHeight-PlayBarHeight*2-50.f);
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
        [_artImage sd_setImageWithURL:[NSURL URLWithString:_currentSong.imageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
        
    }else if (![Utils isEmptyString:_currentSong.avatarImageUrl]) {
        
        [_artImage sd_setImageWithURL:[NSURL URLWithString:_currentSong.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"players_img_default"]];
    }
    
    _artLabel.text = [@": " stringByAppendingString:_currentSong.artist];
    _songLabel.text = _currentSong.songName;
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

@end








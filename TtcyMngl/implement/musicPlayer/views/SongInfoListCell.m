//
//  SongInfoListCell.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongInfoListCell.h"
#import "SongObject.h"
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import "SongOprationManager.h"

#define TAG_COLLECT 100
#define TAG_MORE    101

@interface SongInfoListCell ()
{
    NSInteger _height;
    BOOL _collected;
}

@property (nonatomic,strong)UIImageView * headImage;

@property (nonatomic,strong)UILabel * artistsLabel;

@property (nonatomic,strong)UILabel * songLabel;

@property (nonatomic,strong)SDWebImageManager * webManager;

@end

@implementation SongInfoListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andRowheight:(NSInteger)rowHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _height = rowHeight;
        
        [self setBaseCondition];
        
        [self createHeadImage];
        
        [self createSongNameLabel];
        
//        [self createArtistsLabel];
        
        [self createSeparatorLine];
    }
    return self;
}
-(void)setBaseCondition
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UILabel class]]|[obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    UIImageView * v = [[UIImageView alloc]init];
    v.image = [Utils createImageWithColor:NVC_SELECTED_BACKGROUND];
    self.selectedBackgroundView = v;
    
    self.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMakeRotation(M_PI);
}
#pragma mark - initlizetion methods
-(void)createHeadImage
{
    self.headImage = [[UIImageView alloc]init];  //WithFrame:CGRectMake(0, 10, _height-20, _height-20)
    _headImage.backgroundColor = [UIColor clearColor];
    _headImage.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [_headImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    _headImage.layer.cornerRadius = (_height-10)/2.f;
    _headImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImage];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_headImage]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImage)]];
}
-(void)createSongNameLabel
{
    self.songLabel = [[UILabel alloc]init];
    _songLabel.backgroundColor = [UIColor clearColor];
    _songLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    _songLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_songLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[_headImage(%f)]-15-[_songLabel]-(%f)-|",_height+0.f,_height-10.f,PlayBarHeight] options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImage,_songLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_songLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_songLabel)]];
}
-(void)createArtistsLabel
{
    self.artistsLabel = [[UILabel alloc]init];
    _artistsLabel.backgroundColor = [UIColor clearColor];
    _artistsLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    _artistsLabel.text = @": ";
    [_artistsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:_artistsLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_headImage]-15-[_artistsLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_headImage,_artistsLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_songLabel]-5-[_artistsLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_songLabel,_artistsLabel)]];
}

-(void)createSeparatorLine
{
    getPlayBarHeight()
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, .5f)];
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    [self.contentView addSubview:line];
}
#pragma mark - setUp methods

-(void)setUpCellWithSOngObject:(SongObject *)song collected:(BOOL)collected
{
    _collected = collected;
    if (!([song.avatarImageUrl isKindOfClass:[NSNull class]]||song.avatarImageUrl == nil)) {
        [_headImage sd_setImageWithURL:[NSURL URLWithString:song.avatarImageUrl]  placeholderImage:[UIImage imageNamed:@"players_img_default"]];
        
        _headImage.center = CGPointMake(_headImage.bounds.size.width/2.0f, _height/2.0f);
        
        _artistsLabel.text = [_artistsLabel.text stringByAppendingString:song.artist];
        _artistsLabel.textColor = _fontColor;
        
        _songLabel.text = song.songName;
        _songLabel.textColor = _fontColor;
    }
    [self createCollectSongButton];
    [self createMoreButton];
}
- (void)createCollectSongButton
{
    UIButton * collect = [self createButtonWithTag:TAG_COLLECT];
    if (_collected) {
        [collect setImage:[UIImage imageNamed:@"collect_selected"] forState:UIControlStateNormal];
    }else{
        [collect setImage:[UIImage imageNamed:@"collect_unselected"] forState:UIControlStateNormal];
    }
    collect.center = CGPointMake(25, self.bounds.size.height/2.0f+2);
    [self addSubview:collect];
}
- (void)createMoreButton
{
    UIButton * more = [self createButtonWithTag:TAG_MORE];
    [more setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    more.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:more];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:more attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:more attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:more attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}
- (UIButton *)createButtonWithTag:(NSInteger)tag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, _height, _height);
    button.backgroundColor = [UIColor clearColor];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    button.transform = CGAffineTransformMakeRotation(-M_PI_2);
    return button;
}
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_COLLECT:
        {
            [self.delegate collectButtonPressedWithCell:self];
        }break;
        case TAG_MORE:
        {
            [self.delegate morebuttonClickedWithCell:self];
        }break;
        default:
            break;
    }
}
@end





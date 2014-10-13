//
//  OnlineCelebrityMusicViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineCelebrityMusicViewController.h"
#import "OnlineAlbumMusicViewController.h"
#import "OnlineCelebritView.h"
#import "CommonClass.h"
#import "AsynImageView.h"
#import "MusicCell.h"
#import "SongObject.h"
#import "PlayBar.h"
#import "Album.h"
#import <UIImageView+WebCache.h>
#import "ScrollLabel.h"

#define navigationWhile 51
#define sideLabelColor whiteColor

#define celebrityCellHeight kMainScreenHeight-120-44

#define TAG_SONG 1
#define TAG_ALBUM 2
#define TAG_PLAYALL 3

@interface OnlineCelebrityMusicViewController ()
@end

@implementation OnlineCelebrityMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [self setBaseCondotion];
    
    [self createMessageBar];
    [self loadUpdate];
    [self createSPLine];
}
#pragma mark - initlize ---------------------------
- (void)setBaseCondotion
{
    [self initView];
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    getPlayBarHeight();
    getTopDistance()
}
- (void)createMessageBar
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, kMainScreenHeight-PlayBarHeight*2/3.f)];
    view.backgroundColor = [UIColor clearColor];
    [self.mostlyView addSubview:view];
    
    [self createHeadWithView:view];
    [self createNameLabelWithView:view];
    [self createSongLaelWithView:view];
    [self createAlbumLabelWithView:view];
    [self createPlayAllButtonWithView:view];
}
- (void)createSPLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(90.0-.4f, 20, .4f,kMainScreenHeight-PlayBarHeight*2/3.f )];
    line.backgroundColor = [Utils colorWithHexString:@"#04DDFF"];
    [self.view addSubview:line];
}
- (void)loadUpdate
{
    self.navigationUrl=@"celebrityMusic.plist";
    self.navigationTitle=@"";
    
    UIButton *uIButton=[[UIButton alloc]init];
    uIButton.tag=1;
    [self TypebtnClick:uIButton];
    
    CGRect frame = celebrityTableView.frame;
    frame.origin.x = 92;
    celebrityTableView.frame = frame;
}
#pragma mark - infoBar Condition -----------------------------
- (void)createHeadWithView:(UIView *)view
{
    UIImageView * headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 70, 80, 80)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_celebrity.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
    
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2.f;
    headImageView.layer.masksToBounds = YES;
    
    [view addSubview: headImageView];
}
- (void)createNameLabelWithView:(UIView *)view
{
    ScrollLabel * nameLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    nameLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:25.0f];
    nameLabel.text = _celebrity.name;
    nameLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    nameLabel.frame = CGRectMake(5, 180, 30,180);
    [view addSubview:nameLabel];
}
#pragma mark - 扩展功能 －－－－－－－－－－－－－－－－－－－－－
- (void)createSongLaelWithView:(UIView *)view
{
    UIButton * button = [self createTextButtonWithFrame:CGRectMake(50, 180, 30,90) title:@"" tag:TAG_SONG];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [view addSubview:button];
}
- (void)createAlbumLabelWithView:(UIView *)view
{
    UIButton * button = [self createTextButtonWithFrame:CGRectMake(50, 240, 30,90) title:@"" tag:TAG_ALBUM];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 22, 0, -22)];
    [view addSubview:button];
}
- (void)createPlayAllButtonWithView:(UIView *)view
{
    UIButton * button = [self  createButtonWithImage:@"play_all" tag:TAG_PLAYALL];
    button.center = CGPointMake(view.center.x, view.bounds.size.height - 60);
    [view addSubview:button];
}
#pragma mark - 辅助方法 －－－－－－－－－－－－－－－－－
- (UIButton *)createTextButtonWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag
{
    UIButton * button = [[UIButton alloc]init];
    button.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:25.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[Utils colorWithHexString:@"#1B98DA"] forState:UIControlStateNormal];
    [button setTitleColor:[Utils colorWithHexString:@"176893"] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor clearColor];
    button.transform = CGAffineTransformMakeRotation(M_PI_2);
    button.frame = frame;
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (UIButton *)createButtonWithImage:(NSString *)imageName tag:(NSInteger)tag
{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - Actions ---------------------------
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_SONG:
        {
            [self.view viewWithTag:TAG_PLAYALL].hidden = NO;
            [self TypebtnClick:sender];
        }break;
        case TAG_ALBUM:
        {
            [self.view viewWithTag:TAG_PLAYALL].hidden = YES;
            [self TypebtnClick:sender];
        }break;
        case TAG_PLAYALL:
        {
            [self playAll];
        }break;
        default:
            break;
    }
}
- (void)playAll
{
    [[PlayBar defultPlayer]clearQueue];
    for (int i =0; i<_models.count; i++) {
        SongObject * song = _models[i];
        if (i == 0) {
            [[PlayBar defultPlayer]Play:song];
        }else{
            [[PlayBar defultPlayer]queue:song];
        }
    }
}
- (void)reSetButtonStatus:(NSInteger)index
{
    UIButton * songBtn = (UIButton *)[self.view viewWithTag:TAG_SONG];
    UIButton * albumBtn = (UIButton *)[self.view viewWithTag:TAG_ALBUM];
    if (index == TAG_SONG) {
        [songBtn setTitleColor:[Utils colorWithHexString:@"#F58623"] forState:UIControlStateNormal];
        [albumBtn setTitleColor:[Utils colorWithHexString:@"#1B98DA"] forState:UIControlStateNormal];
    }else{
        [songBtn setTitleColor:[Utils colorWithHexString:@"#1B98DA"] forState:UIControlStateNormal];
        [albumBtn setTitleColor:[Utils colorWithHexString:@"#F58623"] forState:UIControlStateNormal];
    }
}
#pragma mark - UITableViewDelegate ----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell *cell= [tableView dequeueReusableCellWithIdentifier:[MusicCell ID]];
    if (cell==nil) {
        cell=[MusicCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
        if (_nonceType==1) {
            SongObject *cel=_models[indexPath.row];
          [cell celebrityWithModel:cel];
        }else{
        Album *alb=_models[indexPath.row];
        [cell albumWithModel:alb];
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      if (_nonceType==1) {
    SongObject *songObject=_models[indexPath.row];
    [[PlayBar defultPlayer]Play:songObject];
      }else{
      
          OnlineAlbumMusicViewController *onlineAlbumMusicViewController = [[OnlineAlbumMusicViewController alloc] init];
          onlineAlbumMusicViewController.album=_models[indexPath.row];
          [self.navigationController pushViewController:
           onlineAlbumMusicViewController animated:true];
      }
}

#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    [self initialize];
    _nonceType=selButton.tag;
    
    int typeid=selButton.tag==1?3:10;
    self.navigationTitle=@"";
    self.Url= [NSString stringWithFormat:@"/iosSeve.ashx?type=%d&&id=%d",typeid,_celebrity.number];
    self.modeName=selButton.tag==1?@"SongObject":@"Album";
    CGRect frame = celebrityTableView.frame;
    frame.origin.x = 92;
    celebrityTableView.frame = frame;
    [self loadMore];
    [self reSetButtonStatus:selButton.tag];
}

@end

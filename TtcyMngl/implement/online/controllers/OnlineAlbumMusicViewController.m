//
//  OnlineCelebrityMusicViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineAlbumMusicViewController.h"
#import "CommonClass.h"
#import "AsynImageView.h"
#import "MusicCell.h"
#import "SongObject.h"
#import "PlayBar.h"
#import "OnlineCelebritView.h"
#import <UIImageView+WebCache.h>
#import "SHLUILabel.h"
#import "ScrollLabel.h"

#define navigationWhile 51
#define sideLabelColor whiteColor

#define TAG_SHARE 100
#define TAG_PLAY  101

#define celebrityCellHeight kMainScreenHeight-120-44
@interface OnlineAlbumMusicViewController (){

}

@end

@implementation OnlineAlbumMusicViewController

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
    [super viewDidLoad];
    [self setBaseCondotion];
    [self createMessageBar];
    [self createSPLine];
    [self loadUpdate];
}
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
    [self createShareButtonWithView:view];
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
    self.navigationTitle=@"";
    self.Url=[NSString stringWithFormat:@"/iosSeve.ashx?type=%d&&id=%d",12,_album.number];
    self.modeName=@"SongObject";
    
    UIButton *uIButton=[[UIButton alloc]init];
    uIButton.tag=1;
    [self TypebtnClick:uIButton];
    
    CGRect frame = celebrityTableView.frame;
    frame.origin.x = 92;
    frame.size.width = kMainScreenWidth - 92;
    celebrityTableView.frame = frame;
}
- (void)createHeadWithView:(UIView *)view
{
    UIImageView * headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 70, 80, 80)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:_album.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
    
    headImageView.layer.cornerRadius = headImageView.frame.size.width/2.f;
    headImageView.layer.masksToBounds = YES;
    
    [view addSubview: headImageView];
}
#pragma mark - 扩展功能 －－－－－－－－－－－－－－－－－－－
- (void)createNameLabelWithView:(UIView *)view
{
    ScrollLabel * nameLabel = [[ScrollLabel alloc]initWithFrame:CGRectMake(0, 0, 180,30)];
    nameLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:25.0f];
    nameLabel.text = _album.name;
    nameLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    nameLabel.frame = CGRectMake(view.center.x-15, 180, 30,180);
    [view addSubview:nameLabel];
}
- (void)createSongLaelWithView:(UIView *)view
{
    UIButton * button = [self createTextButtonWithFrame:CGRectMake(50, 180, 30,90) andTitle:@""];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 22)];
    [view addSubview:button];
}
- (void)createAlbumLabelWithView:(UIView *)view
{
    UIButton * button = [self createTextButtonWithFrame:CGRectMake(50, 270, 30,90) andTitle:@""];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 22, 0, -22)];
    [view addSubview:button];
}

- (void)createShareButtonWithView:(UIView *)view
{
    
}
- (void)createDownButtonWithView:(UIView *)view
{
    
}
- (void)createPlayAllButtonWithView:(UIView *)view
{
    UIButton * button = [self createButtonWithImage:@"play_all" tag:TAG_PLAY];
    button.center = CGPointMake(view.center.x, view.bounds.size.height - 60);
    [view addSubview:button];
}
- (void)createAddButtonWithView:(UIView *)view
{
    
}
- (void)createCollectButtonWithView:(UIView *)view
{
    
}
#pragma mark - 辅助方法 －－－－－－－－－－－－－－－－－－
- (UIButton *)createTextButtonWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    UIButton * button = [[UIButton alloc]init];
    button.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:25.0f];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[Utils colorWithHexString:@"#1B98DA"] forState:UIControlStateNormal];
    [button setTitleColor:[Utils colorWithHexString:@"176893"] forState:UIControlStateHighlighted];
    button.transform = CGAffineTransformMakeRotation(M_PI_2);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
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
#pragma mark - actions -------------
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_PLAY:
        {
            [self playAll];
        }break;
        case TAG_SHARE:
        {
            
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
#pragma mark  数据源方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicCell *cell= [tableView dequeueReusableCellWithIdentifier:[MusicCell ID]];
    if (cell==nil) {
        cell=[MusicCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if (indexPath.row<_models.count) {
            SongObject *cel=_models[indexPath.row];
            [cell celebrityWithModel:cel];
    }
 
    return cell;
}


#pragma mark --代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongObject *songObject=_models[indexPath.row];
    [[PlayBar defultPlayer]Play:songObject];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

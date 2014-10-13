//
//  OnlineAlbumViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineAlbumViewController.h"
#import "CommonClass.h"
#import "Album.h"
#import "OnlineAlbumMusicViewController.h"
#import "HUD.h"

#define navigationWhile 51
#define sideLabelColor whiteColor

#define celebrityCellHeight kMainScreenHeight-120-44
@interface OnlineAlbumViewController ()

@end

@implementation OnlineAlbumViewController

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
    
     [self initView];
     [CommonClass backgroundColorWhitUIView:self.view];
  
  
    self.pageSize=15;
    self.navigationUrl=@"albumTypes.plist";
    self.navigationTitle=@"";
    self.modeName=@"Album";
    self.Url=[NSString stringWithFormat:@"/iosSeve.ashx?type=10&&pagesize=%d&&pageCount=%d&&ctype=%d",self.pageSize,1,1];
    
    [self OnlineviewDidLoad];
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [self TypebtnClick:butt];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCell *cell= [tableView dequeueReusableCellWithIdentifier:[AlbumCell ID]];
    if (cell==nil) {
        cell=[AlbumCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if([indexPath row] ==_models.count) {
        //创建loadMoreCell
        cell=[AlbumCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setLoadTitle:@"  "];
    }else
        if (indexPath.row<_models.count) {
            [cell AlbumWithModel:_models[indexPath.row]];
        }
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}
#pragma mark --代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //单击加载更多
    if([indexPath row] ==_models.count)
    {
        [HUD messageForBuffering];
        AlbumCell *loadMoreCell=(AlbumCell *)[tableView cellForRowAtIndexPath:indexPath];
        [loadMoreCell setLoadTitle:@" "];
        loadMoreCell.userInteractionEnabled = NO;
              self.Url=[NSString stringWithFormat:@"/iosSeve.ashx?type=10&&pagesize=%d&&pageCount=%d&&ctype=%d",self.pageSize,self.pageCount+1,_nonceType];
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    OnlineAlbumMusicViewController *onlineAlbumMusicViewController = [[OnlineAlbumMusicViewController alloc] init];
    onlineAlbumMusicViewController.album=_models[indexPath.row];
    [self.navigationController pushViewController:
     onlineAlbumMusicViewController animated:true];
    
}

#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    [self initialize];
    _nonceType=selButton.tag-1;
    id cel=_typeModel[_nonceType];
      self.Url=[NSString stringWithFormat:@"/iosSeve.ashx?type=10&&pagesize=%d&&pageCount=%d&&ctype=%@",self.pageSize,1,cel];
    [self loadMore];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

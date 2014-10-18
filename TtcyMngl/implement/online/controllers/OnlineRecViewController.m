//
//  OnlineRecViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineRecViewController.h"
#import "OnlineCelebritView.h"
#import "CommonClass.h"
#import "OnlineAlbumMusicViewController.h"
#import "OnlineCelebrityMusicViewController.h"
#import "AlbumCell.h"
#import "Celebrity.h"
#import "CelebrityCell.h"
#import "HUD.h"

#define navigationWhile 51
#define sideLabelColor whiteColor
#define PageSize 15

#define celebrityCellHeight kMainScreenHeight-120-44
@interface OnlineRecViewController ()

@end

@implementation OnlineRecViewController

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
    // Do any additional setup after loading the view.

    [self initView];
    [CommonClass backgroundColorWhitUIView:self.view];
    
    self.navigationUrl=@"RecView.plist";
    self.navigationTitle=@"";
    [self initialize];
    self.pageSize=15;
    _nonceType=1;
    
    [self OnlineviewDidLoad];
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [self TypebtnClick:butt];
}


#pragma mark  数据源方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_nonceType==1) {
        MusicCell *cell= [tableView dequeueReusableCellWithIdentifier:[MusicCell ID]];
        if (cell==nil) {
            cell=[MusicCell  newCell];
      
        }
        if([indexPath row] ==_models.count) {
            cell=[MusicCell  newCell];
            [cell setLoadTitle:@"  "];
            return cell;
        }
        SongObject *cel=_models[indexPath.row];
        [cell setMusicWithModel:cel];
        return cell;
    }
    if (_nonceType==2) {
      
        CelebrityCell *cell= [tableView dequeueReusableCellWithIdentifier:[CelebrityCell ID]];
        if (cell==nil) {
            cell=[CelebrityCell  newCell];
          
        
        }
        if([indexPath row] ==_models.count) {
               cell=[CelebrityCell  newCell];
            [cell setLoadTitle:@"  "];
            return cell;
        }
        Celebrity *cel=_models[indexPath.row];
        [cell celebrityWithModel:cel];
        return cell;
    }
    if (_nonceType==3) {
        
        AlbumCell *cell= [tableView dequeueReusableCellWithIdentifier:[AlbumCell ID]];
        if (cell==nil) {
            cell=[AlbumCell  newCell];
        }
        if([indexPath row] ==_models.count) {
            cell=[AlbumCell  newCell];
            [cell setLoadTitle:@"  "];
            return cell;
        }
        Album *cel=_models[indexPath.row];
        [cell AlbumWithModel:cel];
        return cell;
    }
    return nil;
    
}
#pragma mark --代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //单击加载更多
    if([indexPath row] ==_models.count)
    {
        [HUD messageForBuffering];
        MusicCell *loadMoreCell=(MusicCell *)[tableView cellForRowAtIndexPath:indexPath];
        [loadMoreCell setLoadTitle:@" "];
        loadMoreCell.userInteractionEnabled = NO;
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (_nonceType==1) {
        SongObject *songObject=_models[indexPath.row];
        [[PlayBar defultPlayer]Play:songObject];
    }
    if (_nonceType==2) {
        OnlineCelebrityMusicViewController *onlineCelebrityMusicViewController = [[OnlineCelebrityMusicViewController alloc] init];
        onlineCelebrityMusicViewController.celebrity=_models[indexPath.row];
        [self.navigationController pushViewController:
         onlineCelebrityMusicViewController animated:true];
    }
    
    if (_nonceType==3) {
        OnlineAlbumMusicViewController *onlineAlbumMusicViewController = [[OnlineAlbumMusicViewController alloc] init];
        onlineAlbumMusicViewController.album=_models[indexPath.row];
        [self.navigationController pushViewController:
         onlineAlbumMusicViewController animated:true];
    }
}
-(void)loadMore
{
    self.pageCount++;
    NSMutableArray *mutabs=[[NSMutableArray alloc]init];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        int typeid=20+_nonceType-1;
        NSArray *array = [CommonClass getJosnNSArrayUrl:[NSString stringWithFormat:@"/iosSeve.ashx?type=%d&&pagesize=%d&&pageCount=%d&&ctype=%d",typeid,PageSize,self.pageCount,1]  sid:@"Model"];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
          [HUD clearHudFromApplication];
            if (array) {
          
            if (_nonceType==1) {
                for (NSDictionary *dict in array) {
                    SongObject *model=[[SongObject alloc] initWithDictionary:dict];
                    NSLog(@"-----------------%@,\n----------%@",dict,model);
                    [_models addObject:model];
                    [mutabs addObject:model];
                 }
            }
            //获取推荐音乐人信息
            if (_nonceType==2) {
                for (NSDictionary *dict in array) {
                    Celebrity *model=[Celebrity  initWithDict:dict];
                    [_models addObject:model];
                    [mutabs addObject:model];
                }
            }
            //获取推荐专辑
            if (_nonceType==3) {
                for (NSDictionary *dict in array) {
                    Album *model=[Album initWithDict:dict];
                    [_models addObject:model];
                    [mutabs addObject:model];
                }
            }
            [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:mutabs waitUntilDone:NO];
                
            }
        });
    });
}
#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    self.pageCount=0;
    
    [self initialize];
   
    _nonceType=selButton.tag;
   
    [self loadMore];
}

@end

//
//  OnlineMusicsViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-12.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineCelebritysViewController.h"

#import "CelebrityCell.h"
#import "Celebrity.h"
#import "OnlineCelebrityMusicViewController.h"
#import "HUD.h"

#define navigationWhile 51
#define sideLabelColor whiteColor
#define celebrityCellHeight kMainScreenHeight-120-44
@interface OnlineCelebritysViewController ()
@end
@implementation OnlineCelebritysViewController

- (void)viewDidLoad
{
   
    [self initView];
    
    self.pageSize=15;
    self.navigationUrl=@"celebrityTypes.plist";
    self.navigationTitle=@"";
    self.modeName=@"Celebrity";
    [self OnlineviewDidLoad];
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [self TypebtnClick:butt];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    CelebrityCell *cell= [tableView dequeueReusableCellWithIdentifier:[CelebrityCell ID]];
    
    
    if (cell==nil) {
        cell=[CelebrityCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if([indexPath row] ==_models.count) {
        cell=[CelebrityCell  newCell];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setLoadTitle:@"  "];
    }else
        if (indexPath.row<_models.count) {
            Celebrity *cel=_models[indexPath.row];
            
            [cell celebrityWithModel:cel];
        }
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] ==_models.count)
    {
         self.Url= [NSString stringWithFormat:@"/iosSeve.ashx?type=1&&pagesize=%d&&pageCount=%d&&ctype=%d",self.pageSize,self.pageCount+1,_nonceType];
        [HUD messageForBuffering];
        CelebrityCell *loadMoreCell=(CelebrityCell *)[tableView cellForRowAtIndexPath:indexPath];
        [loadMoreCell setLoadTitle:@" "];
        loadMoreCell.userInteractionEnabled = NO;
        [self performSelectorInBackground:@selector(loadMore) withObject:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    OnlineCelebrityMusicViewController *onlineCelebrityMusicViewController = [[OnlineCelebrityMusicViewController alloc] init];
    onlineCelebrityMusicViewController.celebrity=_models[indexPath.row];
    [self.navigationController pushViewController:
     onlineCelebrityMusicViewController animated:true];
}

#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    [self initialize];
  _nonceType=selButton.tag-1;
      id cel=_typeModel[_nonceType];
    self.Url= [NSString stringWithFormat:@"/iosSeve.ashx?type=1&&pagesize=%d&&pageCount=%d&&ctype=%@",self.pageSize,1,cel];
   
    [self loadMore];
}

@end

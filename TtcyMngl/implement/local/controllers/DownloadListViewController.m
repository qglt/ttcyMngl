//
//  DownloadListViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "DownloadListViewController.h"

#import "DownLoadInfoCell.h"
#import "DownloadConstants.h"
#import "DownloadManager.h"
#import <objc/runtime.h>

@interface DownloadListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableDictionary * urlList;

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)UITableView * dataTable;

@end

@implementation DownloadListViewController

SINGLETON_IMPLEMENT(DownloadListViewController)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        self.urlList=[NSMutableDictionary dictionary];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    getTopDistance()
    getPlayBarHeight();
    
    
    [self getQueueData];
    [self loadData];
    [self setBaseCondition];
    [self createDataTable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadNotification:) name:kDownloadManagerNotification object:nil];
}
-(void)setBaseCondition
{
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
- (void)setDownLoadObject:(SongObject *)obj
{
    [[FMDBManager defaultManager] deleteDownloadSongBySongUrl:obj.songUrl];
    [[FMDBManager defaultManager] addDownLoadSong:obj];
    [self getQueueData];
    [self loadData];
}
-(void)createDataTable
{
    self.dataTable = [[UITableView alloc]init];
    _dataTable.backgroundColor = [UIColor clearColor];
    _dataTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTable.rowHeight = 65;
    _dataTable.delegate = self;
    _dataTable.dataSource = self;
    _dataTable.showsVerticalScrollIndicator = NO;
    _dataTable.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _dataTable.frame = CGRectMake(40, 20, kMainScreenWidth-40, kMainScreenHeight- PlayBarHeight);
    [self.view addSubview:_dataTable];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateCell:(DownLoadInfoCell *)cell withDownItem:(DownloadItem *)downItem
{
    cell.progressLabel.text =[[NSString stringWithFormat:@"%0.2f",downItem.downloadPercent*100] stringByAppendingString:@"%"];
    if (downItem.downloadPercent==1) {
        cell.progressLabel.text =[@"100" stringByAppendingString:@"%"];
    }
    if (downItem.downloadPercent==1||downItem.downloadPercent==0) {
        [cell.cancelButton setTitle:@"" forState:UIControlStateNormal];
    }else{
        [cell.cancelButton setTitle:@"" forState:UIControlStateNormal];
    }
    [cell.pauseButton setTitle:downItem.downloadStateDescription forState:UIControlStateNormal];
    [cell.progress setProgress:downItem.downloadPercent];
}
-(void)updateUIByDownloadItem:(DownloadItem *)downItem
{
    DownloadItem *findItem=[_urlList objectForKey:[downItem.url description]];
    if(findItem==nil)
    {
        return;
    }
    findItem.downloadStateDescription=downItem.downloadStateDescription;
    findItem.downloadPercent=downItem.downloadPercent;
    findItem.downloadState=downItem.downloadState;
    
    switch (downItem.downloadState) {
        case DownloadFinished:
        {
            
        }
            break;
        case DownloadFailed:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    
    int index=[_urlList.allKeys indexOfObject:[downItem.url description]];
    DownLoadInfoCell *cell=(DownLoadInfoCell *)[self.dataTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    
    [self updateCell:cell withDownItem:downItem];
}

-(void)downloadNotification:(NSNotification *)notif
{
    DownloadItem *notifItem=notif.object;
    [self updateUIByDownloadItem:notifItem];
}
- (void)getQueueData
{
    _dataArray = [[FMDBManager defaultManager] getDownLoadList];
}
- (void)loadData
{
    [_urlList removeAllObjects];
    if (_dataArray.count > 0) {
        
        for (SongObject * obj in _dataArray) {
            
            DownloadItem *downItem=[[DownloadItem alloc]init];
            
            downItem.downloadSong = obj;
            
            DownloadItem *task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem.downloadSong.songUrl description]];
            
            downItem.downloadPercent=task.downloadPercent;
            
            if(task)
            {
                downItem.downloadState=task.downloadState;
            }
            else
            {
                downItem.downloadState=DownloadNotStart;
            }
            
            [_urlList setObject:downItem forKey:[downItem.downloadSong.songUrl description]];
        }
    }
    
    [self.dataTable reloadData];
    
}

#pragma mark - UITableView delegate methods - 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _urlList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadItem *downItem=[_urlList.allValues objectAtIndex:indexPath.row];
    NSString *url=[downItem.url description];
    
    static NSString *cellIdentity=@"downLoadSongCell";
    
    DownLoadInfoCell *cell=(DownLoadInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(cell==nil)
    {
        cell =[[DownLoadInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        objc_setAssociatedObject(cell, @"obj_down_Item", downItem, OBJC_ASSOCIATION_RETAIN);
        
        if([[DownloadManager sharedInstance]isExistInDowningQueue:url])
        {
            [[DownloadManager sharedInstance]pauseDownload:url];
        }
        NSString *desPath=[[Utils applicationDocumentPath] stringByAppendingPathComponent:[self getLocalPathWith:url]];
        
        [[DownloadManager sharedInstance]startDownload:url withLocalPath:desPath];
        
        cell.DownSongCellOperateClick=^(DownLoadInfoCell *cell){
            
            if([[DownloadManager sharedInstance]isExistInDowningQueue:url])
            {
                [[DownloadManager sharedInstance]pauseDownload:url];
                
                return;
            }
            NSString *desPath=[[Utils applicationDocumentPath] stringByAppendingPathComponent:[self getLocalPathWith:url]];
            
            [[DownloadManager sharedInstance]startDownload:url withLocalPath:desPath];
        };
        cell.DownSongCellCancelClick=^(DownLoadInfoCell *cell)
        {
            if (downItem.downloadPercent == 1||downItem.downloadPercent == 0) {
                
                [downItem cancelDownloadTask];
                [self deleteDownSong:downItem.downloadSong];
                
            }else{
                [[DownloadManager sharedInstance]cancelDownload:url];
            }
        };
        cell.DownSongCellBodyClick = ^(DownloadItem * item)
        {
            [self playSong:item];
        };
    }
    
    cell.nameLabel.text = downItem.downloadSong.songName;
    [self updateCell:cell withDownItem:downItem];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownLoadInfoCell * cell = (DownLoadInfoCell *)[self tableView:_dataTable cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    cell.selected = NO;
}
-(NSString *)getLocalPathWith:(NSString *)url
{
    NSLog(@"%i",url.length);
    
     return [[url substringWithRange:NSMakeRange(34, url.length-34)] stringByReplacingOccurrencesOfString:@"/" withString:@""];
}
- (void)playSong:(DownloadItem *)item
{
    SongObject * song = item.downloadSong;
    if (item.downloadState == DownloadFinished) {
        
        [[FMDBManager defaultManager] deleteDownloadSongBySongUrl:song.songUrl];
        [[FMDBManager defaultManager] addDownLoadSong:song];
        song.songUrl = [[Utils applicationDocumentPath] stringByAppendingPathComponent:[self getLocalPathWith:item.downloadSong.songUrl]];
        NSLog(@"=========================%@",song.songUrl);
        [self getQueueData];
        [self loadData];
    }
    
    [[PlayBar defultPlayer] Play:song];
}
- (void)deleteDownSong:(SongObject *)song
{
    [[FMDBManager defaultManager] deleteDownloadSongBySongUrl:song.songUrl];
    [[DownloadManager sharedInstance] cancelDownload:song.songUrl];
    NSError * error = nil;
    song.songLocalPath = [[Utils applicationDocumentPath] stringByAppendingPathComponent:[self getLocalPathWith:song.songUrl]];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:song.songLocalPath] error:&error];
    if (error) {
        LOG_GENERAL_INFO(@"%@",[error localizedDescription]);
    }
    [self getQueueData];
    [self loadData];
}
@end

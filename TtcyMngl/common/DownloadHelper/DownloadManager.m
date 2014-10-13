//
//  DownloadManager.m
//  DownloadDemo
//
//  Created by Peter Yuen on 6/26/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadItem.h"
#import "DownloadStoreManager.h"


#define kMaxDownloadCount 3

static DownloadManager *_instance;
@interface DownloadManager()
{
}

@property(nonatomic,retain) NSMutableDictionary *pauseQueue;//1、正常暂停 2、下载失败暂停
@property(nonatomic,retain) NSMutableDictionary *waittingQueue;
@property(nonatomic,retain) NSMutableDictionary *downlodingQueue;
@property(nonatomic,retain) NSMutableDictionary *finishedQueue;


-(void)checkDownloadingQueue;
-(void)checkWaiitingQueue;
-(void)checkFinishedQueue;

-(void)startValidItem;

@end



@implementation DownloadManager

+(DownloadManager *)sharedInstance
{
   @synchronized(self)
    {
        if(_instance==nil)
        {
            _instance=[[DownloadManager alloc]init];
            _instance.downlodingQueue=[NSMutableDictionary new];
            _instance.waittingQueue=[NSMutableDictionary new];
            _instance.finishedQueue=[NSMutableDictionary new];
            _instance.pauseQueue=[NSMutableDictionary new];
            
            NSMutableArray *allTask=[[DownloadStoreManager sharedInstance] getAllStoreDownloadTask];
            for(DownloadItem *downItem in allTask)
            {
                [_instance registerDownloadItemCallback:downItem];
                if(downItem.downloadState==DownloadFinished)
                {
                    [_instance insertQueue:_instance.finishedQueue checkExistItem:downItem];
                }
                else
                {
                    downItem.downloadState=DownloadPaused;
                    [_instance insertQueue:_instance.pauseQueue checkExistItem:downItem];
                }
            }
        }
    }
    return _instance;
}

-(void)registerDownloadItemCallback:(DownloadItem *)downItem
{
    downItem.DownloadItemStateChangedCallback=^(DownloadItem *callbackItem)
    {
        NSLog(@"--------------------%d",callbackItem.downloadState);
        switch (callbackItem.downloadState) {
            case DownloadFailed:
            {
                [_instance insertQueue:_instance.pauseQueue checkExistItem:callbackItem];
                [_instance checkPauseQueue];
            }
                break;
            case DownloadFinished:
            {
                [_instance insertQueue:_instance.finishedQueue checkExistItem:callbackItem];
                [_instance checkFinishedQueue];
            }
                break;
            case DownloadPaused:
            {
                [_instance insertQueue:_instance.pauseQueue checkExistItem:callbackItem];
                [_instance checkPauseQueue];
            }
                break;
            case DownloadWait:
            {
                
            }
                break;
            default:
                break;
        }
        [_instance startValidItem];
        [[NSNotificationCenter defaultCenter]postNotificationName:kDownloadManagerNotification object:callbackItem userInfo:nil];
    };
    downItem.DownloadItemProgressChangedCallback=^(DownloadItem *callbackItem)
    {
                NSLog(@"%f",callbackItem.downloadPercent);
        NSLog(@"--------------------%d",callbackItem.downloadState);
        [[NSNotificationCenter defaultCenter]postNotificationName:kDownloadManagerNotification object:callbackItem userInfo:nil];
    };

}

-(void)checkPauseQueue
{
    [_pauseQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.url description];

        if([_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue removeObjectForKey:url];
        }

        if([_waittingQueue objectForKey:url])
        {
            [_waittingQueue removeObjectForKey:url];
        }

        if([_finishedQueue objectForKey:url])
        {
            [_finishedQueue removeObjectForKey:url];
        }
    }];
}

-(void)checkDownloadingQueue
{
    [_downlodingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.url description];

        if([_waittingQueue objectForKey:url])
        {
            [_waittingQueue removeObjectForKey:url];
        }
        
        if([_pauseQueue objectForKey:url])
        {
            [_pauseQueue removeObjectForKey:url];
        }
        
        if([_finishedQueue objectForKey:url])
        {
            [_finishedQueue removeObjectForKey:url];
        }
    }];

}

-(void)checkFinishedQueue
{
    [_finishedQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.url description];
        

        if([_waittingQueue objectForKey:url])
        {
            [_waittingQueue removeObjectForKey:url];
        }

        if([_pauseQueue objectForKey:url])
        {
            [_pauseQueue removeObjectForKey:url];
        }
        
        if([_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue removeObjectForKey:url];
        }
    }];
  
}

-(void)checkWaiitingQueue
{
    [_waittingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *item=obj;
        NSString *url=[item.url description];
 
        if([_finishedQueue objectForKey:url])
        {
            [_finishedQueue removeObjectForKey:url];
        }

        if([_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue removeObjectForKey:url];
        }
        if([_pauseQueue objectForKey:url])
        {
            [_pauseQueue removeObjectForKey:url];
        }
    }];
}

-(void)startValidItem
{
    if([_downlodingQueue count]>=kMaxDownloadCount)
    {
        return;
    }
    
    DownloadItem *item=  [_waittingQueue.allValues lastObject];
    NSString *url=[item.url description];
    if(item)
    {
        if(![_downlodingQueue objectForKey:url])
        {
            [_downlodingQueue setObject:item forKey:url];
            [item startDownloadTask];
            [self checkDownloadingQueue];
            
        }
    }
}

//把等待队列和下载队列中的任务暂停，加入暂停队列
-(void)pauseDownload:(NSString *)resourceUrl
{
    DownloadItem *downItemInWait=[_waittingQueue objectForKey:resourceUrl];
    if(downItemInWait)
    {
        [downItemInWait pauseDownloadTask];
        [_waittingQueue removeObjectForKey:resourceUrl];
        [self insertQueue:_pauseQueue checkExistItem:downItemInWait];
    }
    
    DownloadItem *downItemInDowning=[_downlodingQueue objectForKey:resourceUrl];
    if(downItemInDowning)
    {
        [downItemInDowning pauseDownloadTask];
        [_downlodingQueue removeObjectForKey:resourceUrl];
        [self insertQueue:_pauseQueue checkExistItem:downItemInDowning];
    }
}

-(void)pauseAllDownloadTask
{
    [_waittingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem pauseDownloadTask];
        [self insertQueue:_pauseQueue checkExistItem:downItem];
    }];
    [_waittingQueue removeAllObjects];
    
    
    [_downlodingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem pauseDownloadTask];
        [self insertQueue:_pauseQueue checkExistItem:downItem];
    }];
    [_downlodingQueue removeAllObjects];
}

-(void)cancelDownload:(NSString *)resourceUrl
{
    DownloadItem *downItem=[_waittingQueue objectForKey:resourceUrl];
    if(downItem)
    {
        [downItem cancelDownloadTask];
        [_waittingQueue removeObjectForKey:resourceUrl];
    }
    
    downItem=[_downlodingQueue objectForKey:resourceUrl];
    if(downItem)
    {
        [downItem cancelDownloadTask];
        [_downlodingQueue removeObjectForKey:resourceUrl];
    }

    downItem=[_pauseQueue objectForKey:resourceUrl];
    if(downItem)
    {
        [downItem cancelDownloadTask];
        [_pauseQueue removeObjectForKey:resourceUrl];
    }

}


-(void)cancelAllDownloadTask
{
    [_waittingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem cancelDownloadTask];
    }];
    [_waittingQueue removeAllObjects];
    

    [_downlodingQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        [downItem cancelDownloadTask];
    }];
    [_downlodingQueue removeAllObjects];
    
    
    [_pauseQueue.allValues enumerateObjectsUsingBlock:^(id obj,NSUInteger index,BOOL *stop){
        DownloadItem *downItem=obj;
        NSLog(@"downItem.downloadDestinationPath=%@,%@",downItem.downloadDestinationPath,downItem.temporaryFileDownloadPath);
        [downItem cancelDownloadTask];
    }];
    [_pauseQueue removeAllObjects];
}

-(void)insertDownloadingQueueItem:(DownloadItem *)downItem
{
    NSString *urlString=[downItem.url description];
    if([_downlodingQueue objectForKey:urlString])
    {
        [_downlodingQueue setObject:downItem forKey:urlString];
    }
}

//向队列queue新增一个下载任务
-(void)insertQueue:(NSMutableDictionary *)queue checkExistItem:(DownloadItem *)downItem
{
    if(queue==nil||downItem==nil||[downItem.url description]==nil)
    {
        return;
    }
    if(![queue objectForKey:[downItem.url description]])
    {
        [queue setObject:downItem forKey:[downItem.url description]];
    }
}

-(BOOL)isExistInDowningQueue:(NSString *)url
{
    return ([_downlodingQueue objectForKey:url])||([_waittingQueue objectForKey:url]);
}

-(BOOL)isExistInFinshQueue:(NSString *)url
{
    if([_finishedQueue objectForKey:url])
    {
        return YES;
    }
    return NO;
}

-(DownloadItem *)getDownloadItemByUrl:(NSString *)url
{
    if([_downlodingQueue objectForKey:url])
    {
        return [_downlodingQueue objectForKey:url];
    }
    else if([_waittingQueue objectForKey:url])
    {
        return [_waittingQueue objectForKey:url];
    }
    else if([_finishedQueue objectForKey:url])
    {
        return [_finishedQueue objectForKey:url];
    }
    else if([_pauseQueue objectForKey:url])
    {
        return [_pauseQueue objectForKey:url];
    }
    return nil;
}

-(void)startDownload:(NSString *)resourceUrl withLocalPath:(NSString *)localPath reStartFinished:(BOOL)restart
{
    if([self isExistInDowningQueue:resourceUrl])
    {
        return;
    }
    
    if(!restart)
    {
       if([self isExistInFinshQueue:resourceUrl])
       {
           return;
       }
    }
    
//    resourceUrl=[resourceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //downloadItem 为一个ASIHttpRequest对象，取消后不能重新开始
    DownloadItem *originItem;
    if([_finishedQueue objectForKey:resourceUrl])
    {
        originItem=[_finishedQueue objectForKey:resourceUrl];
    }
    else if([_pauseQueue objectForKey:resourceUrl])
    {
        originItem=[_pauseQueue objectForKey:resourceUrl];
    }
    
    DownloadItem *downItem=[[DownloadItem alloc]initWithURL:[NSURL URLWithString:resourceUrl]];
    downItem.downloadDestinationPath=localPath;
    downItem.temporaryFileDownloadPath=[localPath stringByAppendingString:@".tmp"];
    downItem.receivedLength=originItem.receivedLength;
    downItem.totalLength=originItem.totalLength;
    downItem.downloadPercent=originItem.downloadPercent;
    [downItem setAllowResumeForFileDownloads:YES];
    [self registerDownloadItemCallback:downItem];
    
    downItem.downloadState=DownloadWait;
    [self insertQueue:_waittingQueue checkExistItem:downItem];
    [self checkWaiitingQueue];
    [self startValidItem];
}


-(void)startDownload:(NSString *)resourceUrl withLocalPath:(NSString *)localPath
{
    [self startDownload:resourceUrl withLocalPath:localPath reStartFinished:NO];
}

-(NSMutableDictionary *)getDownloadingTask
{
    NSMutableDictionary *downingQueue=[NSMutableDictionary new];
    [downingQueue addEntriesFromDictionary:_downlodingQueue];
    
    [downingQueue addEntriesFromDictionary:_waittingQueue];
    
    [downingQueue addEntriesFromDictionary:_pauseQueue];
    return downingQueue;
}

-(NSMutableDictionary *)getFinishedTask
{
    return _finishedQueue;
}
@end

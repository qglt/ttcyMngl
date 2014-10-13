//
//  DownloadStoreManager.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "DownloadStoreManager.h"
#import "DownloadItem.h"
#import "DownloadConstants.h"
static DownloadStoreManager *_instance;

@interface DownloadStoreManager ()

@end


@implementation DownloadStoreManager

+(DownloadItem *)transferToItem:(DownloadItemEntity *)entity
{
    DownloadItem *item=[[DownloadItem alloc]init];
    if(entity.downloadUrl)
    {
        const char *decrypText=[DesEncrypt sharedDesEncrypt]->decryptText([entity.downloadUrl UTF8String]);
        item.url=[NSURL URLWithString:[[NSString alloc]initWithCString:decrypText encoding:NSUTF8StringEncoding]];
    }
    item.temporaryFileDownloadPath=entity.temporaryFileDownloadPath;
    item.downloadDestinationPath=entity.downloadDestinationPath;
    item.totalLength=[entity.totalSize doubleValue];
    item.receivedLength=[entity.currentSize doubleValue];
    item.downloadState=[entity.downloadState intValue];
    item.downloadPercent=[entity.downloadProgress doubleValue];
    return item;
}

+(void)transfer:(DownloadItem *)item toEntity:(DownloadItemEntity *)entity;
{
    if([item.url description])
    {
        const char *encrypText=[DesEncrypt sharedDesEncrypt]->encryptText([[item.url description] UTF8String]);
        entity.downloadUrl=[[NSString alloc]initWithCString:encrypText encoding:NSUTF8StringEncoding];
    }
    entity.downloadDestinationPath=item.downloadDestinationPath;
    entity.temporaryFileDownloadPath=item.temporaryFileDownloadPath;
    entity.downloadState=[NSNumber numberWithInt:item.downloadState];
    entity.totalSize=[NSNumber numberWithDouble:item.totalLength];
    entity.currentSize=[NSNumber numberWithDouble:item.receivedLength];
    entity.downloadProgress=[NSNumber numberWithDouble:item.downloadPercent];
}

+(DownloadStoreManager *)sharedInstance
{
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance=[[DownloadStoreManager alloc]init];
        });
    }
    return _instance;
}

-(BOOL)isExistDownloadTask:(NSString *)url
{
    if([self queryEntityByUrl:url])
    {
        return YES;
    }
    return NO;
}

-(DownloadItemEntity *)queryEntityByUrl:(NSString *)url
{
    const char *encryptData=[DesEncrypt sharedDesEncrypt]->encryptText([[url description] UTF8String]);
    NSString *encryptUrl=[[NSString alloc]initWithCString:encryptData encoding:NSUTF8StringEncoding];

    
    NSFetchRequest *reqeust=[[NSFetchRequest alloc]init];
    reqeust.entity=[NSEntityDescription entityForName:@"DownloadItemEntity" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"downloadUrl=%@",encryptUrl];
    reqeust.predicate=predicate;
    
    NSError *error=nil;
    NSArray *retlist=[[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:reqeust error:&error];
    if(error)
    {
        NSLog(@"deleteDownloadTask error:%@",error);
    }
    return [retlist firstObject];
}

-(NSMutableArray *)getAllStoreDownloadTask
{
    NSFetchRequest *fetRequest=[[NSFetchRequest alloc]init];
    fetRequest.entity=[NSEntityDescription entityForName:@"DownloadItemEntity" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    
    //sort
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES];
    fetRequest.sortDescriptors=[NSArray arrayWithObject:sort];
    
    //过滤
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@""];
//    fetRequest.predicate=predicate;

    NSError *error=nil;
    NSArray *retlist=[[CoreDataManager sharedInstance].managedObjectContext executeFetchRequest:fetRequest error:&error];
    if(error)
    {
        NSLog(@"getAllStoreDownloadTask error:%@",error);
    }
    
    NSMutableArray *itemlist=[NSMutableArray new];
    for(DownloadItemEntity *entity in retlist)
    {
        [itemlist addObject:[DownloadStoreManager transferToItem:entity]];
    }
    return itemlist;
}

-(void)insertDownloadTask:(DownloadItem *)item
{
    if([self isExistDownloadTask:[item.url description]])
    {
        return;
    }
    DownloadItemEntity *entity=(DownloadItemEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"DownloadItemEntity" inManagedObjectContext:[CoreDataManager sharedInstance].managedObjectContext];
    [DownloadStoreManager transfer:item toEntity:entity];
    entity.createDate=[NSDate date];
    [[CoreDataManager sharedInstance] saveChanged];
}

-(void)deleteDownloadTask:(NSString *)url
{
    DownloadItemEntity *entity=[self queryEntityByUrl:url];
    if(entity)
    {
        [[CoreDataManager sharedInstance].managedObjectContext deleteObject:entity];
        [[CoreDataManager sharedInstance] saveChanged];
    }
}

-(void)updateDownloadTask:(DownloadItem *)item
{
    DownloadItemEntity *entity=[self queryEntityByUrl:[item.url description]];
    if(entity)
    {
        [DownloadStoreManager transfer:item toEntity:entity];
        [[CoreDataManager sharedInstance].managedObjectContext updatedObjects];
        [[CoreDataManager sharedInstance] saveChanged];
    }
}
@end

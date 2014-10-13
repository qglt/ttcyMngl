//
//  CoreDataManager.m
//  DownloadDemo
//
//  Created by Peter Yuen on 7/1/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

static CoreDataManager *_instance;

@interface CoreDataManager ()

@property(nonatomic,retain)NSManagedObjectModel *model;
@property(nonatomic,retain)NSPersistentStoreCoordinator *persisentStoreCoordinator;

-(NSManagedObjectModel *)getManagedObjectModel;
-(NSPersistentStoreCoordinator *)getPersisentStoreCoordinator;


@end


@implementation CoreDataManager

+(CoreDataManager *)sharedInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self)
        {
            _instance=[[CoreDataManager alloc]init];
        }
    });
    return _instance;
}

-(NSManagedObjectModel *)getManagedObjectModel
{
    if(_model==nil)
    {
        _model=[NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _model;
}

-(NSPersistentStoreCoordinator *)getPersisentStoreCoordinator
{
    if(_persisentStoreCoordinator==nil)
    {
        _persisentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self getManagedObjectModel]];
        NSString *dbPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"download.db"];
        
        NSError *error=nil;
        NSPersistentStore *store= [_persisentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dbPath] options:nil error:&error];
        if(store==nil||error!=nil)
        {
            NSLog(@"新建数据库失败");
        }
    }
    return _persisentStoreCoordinator;
}

-(NSManagedObjectContext *)managedObjectContext
{
    if(!_managedObjectContext)
    {
        _managedObjectContext=[[NSManagedObjectContext alloc]init];
        _managedObjectContext.persistentStoreCoordinator=[self getPersisentStoreCoordinator];
    }
    return _managedObjectContext;
}

-(void)saveChanged
{
    NSError *error=nil;
    [self.managedObjectContext save:&error];
    if(error!=nil)
    {
        NSLog(@"saveChanged error:%@",error);
    }
}
@end

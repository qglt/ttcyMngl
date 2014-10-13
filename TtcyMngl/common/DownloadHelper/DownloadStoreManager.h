//
//  DownloadStoreManager.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownloadItem;

@interface DownloadStoreManager : NSObject

+(DownloadStoreManager *)sharedInstance;

-(NSMutableArray *)getAllStoreDownloadTask;
-(BOOL)isExistDownloadTask:(NSString *)url;
-(void)insertDownloadTask:(DownloadItem *)item;
-(void)deleteDownloadTask:(NSString *)url;
-(void)updateDownloadTask:(DownloadItem *)item;

@end

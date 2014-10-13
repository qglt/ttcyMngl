//
//  DownloadItemEntity.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloadItemEntity : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * currentSize;
@property (nonatomic, retain) NSNumber * downloadState;
@property (nonatomic, retain) NSString * downloadUrl;
@property (nonatomic, retain) NSNumber * totalSize;
@property (nonatomic, retain) NSNumber * downloadProgress;
@property (nonatomic, retain) NSString * downloadDestinationPath;
@property (nonatomic, retain) NSString * temporaryFileDownloadPath;

@end

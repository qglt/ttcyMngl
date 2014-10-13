//
//  AppDataManager.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDataManager : NSObject

SINGLETON_DEFINE(AppDataManager)

- (NSString *)getCacheSize;
- (void)clearCache;
- (void)checkUpdate;
- (void)shareApp;

@end

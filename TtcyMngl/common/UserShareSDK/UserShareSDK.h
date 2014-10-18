//
//  UserShareSDK.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-8.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <shareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <AGCommon/UIDevice+Common.h>

@interface UserShareSDK : NSObject
SINGLETON_DEFINE(UserShareSDK);


- (void)setShareConfig;

- (void)shareSongWithDictionary:(NSDictionary *)songDict;

- (void)shareApp;

@end

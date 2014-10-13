//
//  FMDBManager+UserInfo.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-2.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager.h"

@interface FMDBManager (UserInfo)

- (NSArray *)getAllUserInfo;//从数据库中获取所有用户信息

-(void)addUserToDB:(AccountInfo *)userObj callBack:(void(^)(BOOL isOK))callBack;//往数据库里添加用户

- (void)deleteUserInfoFromDBByUserPhone:(NSString *)userPhone callBack:(void(^)(BOOL isOK))callBack;//从数据库中删除用户信息

- (void)deleteAllUserInfo:(void(^)(BOOL isOK))callBack;//删除所有用户信息

//- (int)getUserCount;//获得用户数目

@end

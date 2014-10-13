//
//  FMDBManager+UserInfo.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-2.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "FMDBManager+UserInfo.h"

@implementation FMDBManager (UserInfo)


- (NSArray *)getAllUserInfo
{
    [_db open];
    NSMutableArray *aryUser = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",TABLE_USERINFO];
    FMResultSet *result = [_db executeQuery:sql];
    while ([result next]) {
        AccountInfo *userObject = [AccountInfo userWithResult:result];
        [aryUser addObject:userObject];
    }
    [_db close];
    return aryUser.reverseObjectEnumerator.allObjects;
}

-(void)addUserToDB:(AccountInfo *)userObj callBack:(void (^)(BOOL))callBack
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:INSERT_USERINFO_TABLE,TABLE_USERINFO];
    if ([_db executeUpdate:sql,USER_PARAMETER]) {
        NSLog(@"add user successed");
        callBack(YES);
    }
    else{
        NSLog(@"add user failed");
        callBack(NO);
    }
    [_db close];
}

- (void)deleteUserInfoFromDBByUserPhone:(NSString *)userPhone callBack:(void (^)(BOOL))callBack
{
    [_db open];
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE phone = ?",TABLE_USERINFO];
    if ([_db executeUpdate:sql,userPhone]) {
        NSLog(@"delete user successed");
        callBack(YES);
    }
    else{
        NSLog(@"delete user failed");
        callBack(NO);
    }
    [_db close];
    
}

- (void)deleteAllUserInfo:(void (^)(BOOL))callBack
{
    [_db open];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",TABLE_USERINFO];
    if ([_db executeUpdate:sql]) {
        NSLog(@"delete all user successed");
        callBack(YES);
    }
    else{
        NSLog(@"delete all user failed");
        callBack(NO);
    }
    [_db close];
}


@end

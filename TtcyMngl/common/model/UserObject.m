//
//  UserObject.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-2.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

+ (UserObject *)userWithResult:(FMResultSet *)result
{
    UserObject *user = [[UserObject alloc] init];
    user.userId = [result intForColumn:@"userId"];
    user.userNickname = [result stringForColumn:@"userNickname"];
    user.userIconPath = [result stringForColumn:@"userIconPath"];
    return user;
}
@end

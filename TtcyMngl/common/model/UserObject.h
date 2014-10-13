//
//  UserObject.h
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-2.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface UserObject : NSObject

@property (nonatomic, assign) int userId;
@property (nonatomic, strong) NSString *userNickname;
@property (nonatomic, strong) NSString *userIconPath;

+ (UserObject *)userWithResult:(FMResultSet *)result;

@end

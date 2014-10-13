//
//  AccountInfo.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface AccountInfo : NSObject

@property (nonatomic,strong)NSString * pass;
@property (nonatomic,setter = setSave:)BOOL savePasswd;

@property (nonatomic,strong)NSString * phone;
@property (nonatomic,strong)NSString * userIcon;

- (id)initWithJsonString:(NSString *)json;

+ (AccountInfo *)userWithResult:(FMResultSet *)result;

@end

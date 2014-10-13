//
//  AccountInfo.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "AccountInfo.h"
#import <CJSONDeserializer.h>

@implementation AccountInfo

-(id)initWithJsonString:(NSString *)json
{
    if (self = [super init]) {
        NSDictionary * dict = [[CJSONDeserializer deserializer] deserialize:[json dataUsingEncoding:NSUTF8StringEncoding] error:nil];
        self.pass = [dict objectForKey:@"pass"];
        self.savePasswd = [[dict objectForKey:@"savePwd"] boolValue];
        self.phone = [dict objectForKey:@"phone"];
        self.userIcon = @"moren_bg";
        if ([dict objectForKey:@"icon"]) {
            self.userIcon = [dict objectForKey:@"userIcon"];
        }
    }
    return  self;
}
-(id)init
{
    if (self = [super init]) {
        
        self.userIcon = @"moren_bg";
        
    }
    return  self;
}
-(void)setSave:(BOOL)savePasswd
{
    _savePasswd = savePasswd;
    
}

+ (AccountInfo *)userWithResult:(FMResultSet *)result
{
    AccountInfo *userObject = [[AccountInfo alloc] init];
    userObject.phone = [result stringForColumn:@"phone"];
    userObject.pass = [result stringForColumn:@"pass"];
    userObject.savePasswd = [[result stringForColumn:@"savePasswd"] boolValue];
    return userObject;
}

@end



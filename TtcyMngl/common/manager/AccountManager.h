//
//  AccountManager.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultInfo.h"
#import "AccountInfo.h"

@protocol AccountManagerDelegate <NSObject>

@optional
- (void) disconnected:(NSDictionary*) data;

- (void) loginSucess;
- (void) loginFailure:(NSDictionary*) data;
//- (void) conected:(NSDictionary*) data;


-(void)registSucess;
-(void)registFailure:(NSDictionary *)data;

@end

typedef void(^AccountListCallbackType)(NSArray*);

typedef enum{

    onLine,
    offLine
    
}accountStatus;

@interface AccountManager : NSObject

@property (strong, nonatomic) AccountInfo* currentAccount;

@property (strong, nonatomic) NSMutableArray* historyAccounts;

@property (nonatomic) BOOL isCanChangePwd;

@property (nonatomic,setter = setAccountStatus:)accountStatus  status;

+(id)shareInstance;

-(void)addListener:(id <AccountManagerDelegate>)listener;

-(ResultInfo *)parseCommandResusltInfo:(NSDictionary *)data;

- (id)init;

- (void)fetchAccountHistory:(AccountListCallbackType)callback;

-(void)disConnect:(void(^)(BOOL isOK))callBack;

/**
 *  使用给定账号进行登录,使用delegate进行通知结果
 *
 *  @param   userName   用户名
 *  @param   pwd             密码
 *  @param   isSave         保存密码
 */
- (BOOL) login:(NSString *)userName withPwd:(NSString *)pwd SavePWD:(BOOL) isSave;

- (BOOL)regist:(NSString *)userName  withPwd:(NSString *)pwd;

- (void) changePwd:(void(^)(NSString*)) callback;

- (void) deleteAccount:(NSString*) user callback:(void(^)(BOOL)) callback;

- (void)addAccount:(AccountInfo *)acc callback:(void(^)(BOOL)) callback;

@end





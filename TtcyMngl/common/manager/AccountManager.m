//
//  AccountManager.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "AccountManager.h"
#import "AccountInfo.h"
#import "AppsAPIConstants.h"
#import "MVASIHtttpRequest.h"
#import "FMDBManager+UserInfo.h"

static AccountListCallbackType bufferCallback = nil;

@interface AccountManager()<MVASIHtttpRequestDelegate>
{
    NSArray* accountList_;
    NSString* callback_id;
    NSMutableDictionary * registDict;
}
@property (nonatomic,strong) MVASIHtttpRequest *mvAsiRequest;
@property (nonatomic,strong) NSMutableArray * listenerArray;

@end

AccountManager * _instance = nil;
@implementation AccountManager

+(id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instance) {
            _instance = [[self alloc]init];
        }
    });
    return _instance;
}

-(id)init
{
    
    if(self = [super init]){
        self.currentAccount = [[AccountInfo alloc] init];
        self.mvAsiRequest = [[MVASIHtttpRequest alloc]init];
        self.mvAsiRequest.delegate = self;
        registDict = [NSMutableDictionary dictionary];
        self.listenerArray = [NSMutableArray array];
        _status = offLine;
    }
    return self;
}
-(void)addListener:(id <AccountManagerDelegate>)listener;
{
    if (_listenerArray.count>0) {
        BOOL flag = NO;
        for (id <AccountManagerDelegate> d in _listenerArray) {
            if ([d isEqual:listener]) {
                flag = YES;
                break;
            }
        }
        if (flag == NO) {
            [_listenerArray addObject:listener];
        }
    }else{
       [_listenerArray addObject:listener];
    }
}
-(ResultInfo *)parseCommandResusltInfo:(NSDictionary *)data
{
    ResultInfo * result = [[ResultInfo alloc]init];
    if ([@"y" isEqualToString:[data objectForKey:@"LoginState"]]||[@"ok" isEqualToString:[data objectForKey:@"MSG"]]) {
        result.succeed = YES;
    }else{
        result.errorMsg = [data objectForKey:@"MSG"];
    }
    return result;
}
-(void)reset
{
    if(self.historyAccounts){
        [self.historyAccounts removeAllObjects];
    }
    self.historyAccounts = nil;
    callback_id = nil;
}

-(void)fetchAccountHistory:(AccountListCallbackType)callback
{
    callback([[FMDBManager defaultManager] getAllUserInfo]);
}
-(void)setAccountStatus:(accountStatus)status
{
    _status = status;
}
- (BOOL) login
{
    void(^listener)(NSDictionary*) = ^(NSDictionary *result){
        NSLog(@"--------------------------------------login result:%@",result);
        ResultInfo *resultInfo =[self parseCommandResusltInfo:result];
        if(resultInfo.succeed){
            _status = onLine;
            [self sendLoginSuccessToListener];
        }else{
            _status = offLine;
            [self sendLoginFailureToListener:result];
        }
        result = nil;
    };
    
    NSDictionary *dataDit = [NSDictionary dictionaryWithObjectsAndKeys:_currentAccount.phone,@"phone",_currentAccount.pass,@"pass",nil];
    
    [self.mvAsiRequest requestForGetWithPramas:dataDit method:USER_LOGIN loadString:@"注册中" serverType:2 listener:listener];
    
    return YES;
}

- (BOOL) login:(NSString *)userName withPwd:(NSString *)pwd SavePWD:(BOOL) isSave
{
    
    AccountInfo* acc = nil;
    BOOL isFind = NO;
    for (AccountInfo* ai in accountList_) {
        if ([ai.phone isEqualToString:userName]) {
            acc = ai;
            acc.pass = pwd;
            isFind = YES;
            break;
        }
    }
    if (!isFind) {
        acc = [[AccountInfo alloc] init];
        acc.phone = userName;
        acc.pass = pwd;
    }
    
    acc.savePasswd = isSave;
    
    self.currentAccount = acc;
    
    return [self login];
}

- (void) changePwd:(void (^)(NSString *))callback
{
    
}
-(BOOL)checkAccountInHistory:(AccountInfo *)acc
{
    for (AccountInfo * obj in _historyAccounts) {
        if ([acc.phone isEqualToString:obj.phone]) {
            return YES;
        }
    }
    return NO;
}
-(void)addAccount:(AccountInfo *)acc callback:(void (^)(BOOL))callback
{
    if ([self checkAccountInHistory:acc]) {
        
        [self deleteAccount:acc.phone callback:^(BOOL isOK) {
            
        }];
    }
    
    [[FMDBManager defaultManager] addUserToDB:acc callBack:^(BOOL isOK) {
        if (isOK) {
            LOG_GENERAL_INFO(@"账号本地化成功 ！");
        }else{
            LOG_GENERAL_INFO(@"账号本地化失败 ！");
        }
        callback(isOK);
    }];
}
- (void) deleteAccount:(NSString *)user callback:(void (^)(BOOL))callback
{
    [[FMDBManager defaultManager] deleteUserInfoFromDBByUserPhone:user callBack:callback];
}
-(BOOL)regist:(NSString *)userName withPwd:(NSString *)pwd
{
    registDict = (NSMutableDictionary *)@{@"phone": userName,@"pass":pwd};
    
    return [self regist];
}
- (BOOL) regist
{
    void(^listener)(NSDictionary*) = ^(NSDictionary *result){
        
        ResultInfo *resultInfo =[self parseCommandResusltInfo:result];
        if(resultInfo.succeed){
            
            [self sendRegistSuccessToListener];
            
        }else{
            [self sendRegistFailureToListener:result];
        }
        result = nil;
    };
    
    [self.mvAsiRequest requestForGetWithPramas:registDict method:USER_REGISTER loadString:@"注册中" serverType:2 listener:listener];
    
    return YES;
}
-(void)disConnect:(void (^)(BOOL))callBack
{
    void(^listener)(NSDictionary*) = ^(NSDictionary *result){
        
        ResultInfo *resultInfo =[self parseCommandResusltInfo:result];
        if(resultInfo.succeed){
            callBack(YES);
            _status = onLine;
            
        }else{
            callBack(NO);
            _status = offLine;
        }
        result = nil;
    };
    
    NSDictionary *dataDit = [NSDictionary dictionaryWithObjectsAndKeys:_currentAccount.phone,@"phone",_currentAccount.pass,@"pass",nil];
    
    [self.mvAsiRequest requestForGetWithPramas:dataDit method:USER_LOGIN loadString:@"注册中" serverType:2 listener:listener];
}
#pragma 发送delegate消息


- (void) sendDisconnectedBySameDeviceLogin
{
    //    for () {
    //        if ([d respondsToSelector:@selector(disconnectedBySameDeviceLogin)]) {
    //            [d disconnectedBySameDeviceLogin];
    //        }
    //    }
}

- (void) sendDisconnectedStateToListener:(NSDictionary*) data
{
    for (id<AccountManagerDelegate> d in _listenerArray) {
        if ([d respondsToSelector:@selector(disconnected:)]) {
            [d disconnected:data];
        }
    }
}

- (void) sendLoginSuccessToListener
{
    for (id<AccountManagerDelegate> d in _listenerArray) {
        if ([d respondsToSelector:@selector(loginSucess)]) {
            [d loginSucess];
        }
    }
}
- (void) sendLoginFailureToListener:(NSDictionary*) data
{
    for (id<AccountManagerDelegate> d in _listenerArray) {
        if ([d respondsToSelector:@selector(loginFailure:)]) {
            [d loginFailure:data];
        }
        
    }
}
- (void) sendRegistSuccessToListener
{
    for (id<AccountManagerDelegate> d in _listenerArray) {
        if ([d respondsToSelector:@selector(registSucess)]) {
            [d registSucess];
        }
    }
}
- (void) sendRegistFailureToListener:(NSDictionary*) data
{
    for (id<AccountManagerDelegate> d in _listenerArray) {
        if ([d respondsToSelector:@selector(registFailure:)]) {
            [d registFailure:data];
        }

    }
}
#pragma mark - MVASIHtttpRequestDelegate methods
- (void)mvAsiRequestDidFinish:(id)responseObject{
    
    NSDictionary *responseDit = (NSDictionary *)responseObject;
    int status = [[responseDit objectForKey:@"msg"] intValue];
    NSString *msg = [responseDit objectForKey:@"msgbox"];
    
    if (status==1) {
        
        LOG_NETWORK_INFO(@"注册成功");
        
    }else{
        
        LOG_NETWORK_DEBUG(@"%@",msg);
    }
    
}
- (void)mvAsiRequestDidFail:(NSError *)error{
    
    /*
     *
     *     hehe , kaiwanxiao
     *
     *
     */
}

@end

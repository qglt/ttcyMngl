//
//  AppDelegate.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <Reachability.h>
#import "AccountManager.h"
#import "HUD.h"
#import "UserShareSDK.h"
#import <MediaPlayer/MediaPlayer.h>

#import "Constant.h"

#import "MTA.h"
#import "MTAConfig.h"
/**
 *  微信开放平台申请得到的 appid, 需要同时添加在 URL schema
 */
NSString * const WXAppId = @"wxd930ea5d5a258f4f";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppKey = @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K";

/**
 * 微信开放平台和商户约定的密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXAppSecret = @"db426a9829e4b49a0dcac7b4162da6b6";

/**
 * 微信开放平台和商户约定的支付密钥
 *
 * 注意：不能hardcode在客户端，建议genSign这个过程由服务器端完成
 */
NSString * const WXPartnerKey = @"8934e7d15453e97507ef794cf7b0519d";

/**
 *  微信公众平台商户模块生成的ID
 */
NSString * const WXPartnerId = @"1900000109";


NSString * const HUDDismissNotification = @"HUDDismissNotification";


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [MTA startWithAppkey:@"AV7ZHE63DG6J"];
    
    // Override point for customization after application launch.
    UINavigationBar * bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[Utils createImageWithColor:NVC_COLOR] forBarMetrics:UIBarMetricsDefault];
    [bar setTintColor:[UIColor whiteColor]];
    
    self.window.rootViewController = [[MainViewController alloc]init];
    
//    [WXApi registerApp:WXAppId];
    
    [self setSessionSetting];
    
    [self addNotifiCation];
    
    [UserShareSDK initWithShareConfig];//初始化分享配置
    
    [FMDBManager defaultManager];//创建数据库，并初始化
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    Reachability * hostReach = [Reachability reachabilityWithHostname:@"www.ttcy.com"];
    [hostReach startNotifier];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)setSessionSetting
{
    NSError* error;
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
	[[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    Float32 bufferLength = 0.1;
    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(bufferLength), &bufferLength);
    
}
- (void)addNotifiCation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackDisplayInfo:) name:@"didStartPlaying" object:nil];
}
- (void)setBackDisplayInfo:(NSNotification *)notifi
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    [dict setObject:@"TengrTal" forKey:MPMediaItemPropertyTitle];
    
    [dict setObject:@"天堂草原音乐网" forKey:MPMediaItemPropertyAlbumTitle];
    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}
- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    AccountManager * manager = [AccountManager shareInstance];
    
    if (status == NotReachable && [[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        
        manager.status = offLine;
        
        [HUD message:@"  "];
        
    }else if (status == ReachableViaWiFi){
        [HUD clearHudFromApplication];
        [self disConnect:manager];
        
    }else{
        [HUD clearHudFromApplication];
        [self disConnect:manager];
    }
}
-(void)disConnect:(AccountManager *)manager
{
    if (!(manager.historyAccounts.count > 0)) {
        
        [manager fetchAccountHistory:^(NSArray * list) {
            
            if (list.count>0) {
                manager.currentAccount = list[0];
                manager.historyAccounts = [NSMutableArray arrayWithArray:list];
            }
            
            if (manager.currentAccount.savePasswd) {
                
                [manager disConnect:^(BOOL isOK) {
                    manager.status = isOK? onLine:offLine;
                }];
            }
        }];
    }else{
        
        [manager disConnect:^(BOOL isOK) {
            
        }];
    }
}

#pragma ShareSDK - 检查是否已加入handleOpenURL的处理方法，如果没有则添加如下代码
- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];//||[WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];//||[WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        
        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                        message:strMsg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HUDDismissNotification object:nil userInfo:nil];
    }
}
@end

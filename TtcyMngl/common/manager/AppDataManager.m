//
//  AppDataManager.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "AppDataManager.h"
#import <sys/stat.h>
#import <SDImageCache.h>
#import <ASIFormDataRequest.h>
#import <CJSONDeserializer.h>
#import "HUD.h"
#import "UserShareSDK.h"

@interface AppDataManager ()<HUDDelgate>
{
    NSString * newVersionURlString;
}
@end

@implementation AppDataManager
SINGLETON_IMPLEMENT(AppDataManager)

#pragma mark - Get cache opration methods ------------------------
-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)getCacheSize{
    
    double fileSize = [self getDefaultImageCacheSize] + [self getSDImageCacheSize] + [self getLrcCacheSize];
    
    float mbSize = 1024.0*1024.0f;
    
    if (fileSize>mbSize) {
        float f = fileSize/mbSize;
        return [NSString stringWithFormat:@"%0.01f MB",f];
    }else{
        return [NSString stringWithFormat:@"%0.01f KB",fileSize/1024.0f];
    }
}
-(double)getDefaultImageCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    double fileSize = [self folderSizeAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ttcy.TtcyMngl/fsCachedData"]];
    return fileSize;
}
-(double)getSDImageCacheSize
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    double fileSize = [self folderSizeAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"]];
    return fileSize;
}
-(double)getLrcCacheSize
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    double fileSize = [self folderSizeAtPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ttcy.TtcyMngl/fsCachedData"]];
    return fileSize;
}
- (long long) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    
    while (((fileName = [childFilesEnumerator nextObject]) != nil) && !([[fileName pathExtension] isEqualToString:@"sqlite"])){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeWithPath:fileAbsolutePath];
    }
    return folderSize;
}

- (long long)fileSizeWithPath:(NSString *)filePath{
    
    struct stat st;
    
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

#pragma mark - Clear cache opration methods -------------------------
- (void)clearCache
{
    [HUD message:@"    " delegate:self Tag:100];
}
- (void)clearImageCacheAtCachePathComponent:(NSString *)PathComponent
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:PathComponent];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    
    while ((filename = [e nextObject])) {
        
        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
    }
}
- ( void)clearLrcCache
{
    NSString *extension = @"lrc";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}
#pragma mark - 检查更新 ------------------------------------------
- (void)checkUpdate
{
    NSString *updateUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=TengrTal&entity=software"];
    updateUrlString = [updateUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *updateUrl = [NSURL URLWithString:updateUrlString];
    ASIFormDataRequest * _versionRequest = [ASIFormDataRequest requestWithURL:updateUrl];
    
    [_versionRequest setRequestMethod:@"GET"];
    [_versionRequest setTimeOutSeconds:60];
    [_versionRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    
    [_versionRequest setDelegate:self];
    [_versionRequest setDidFailSelector:@selector(versionRequestFailler:)];
    [_versionRequest setDidFinishSelector:@selector(versionRequestFinish:)];
    
    [HUD messageForBuffering];
    [_versionRequest startAsynchronous];
    
}
- (void)versionRequestFailler:(ASIHTTPRequest *)request
{
    [HUD message:@"     "];
}
- (void)versionRequestFinish:(ASIHTTPRequest *)request
{
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSLog(@"appInfo = %@",appInfo);
    NSString *currentVersion = [appInfo objectForKey:@"CFBundleVersion"];
    
    NSDictionary *dict = [[CJSONDeserializer deserializer] deserialize:[request responseData] error:nil];
    NSLog(@"-----------------%@",dict);
    NSArray *infoArray = [dict objectForKey:@"results"];
    
    if ([infoArray count]) {
        
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if ([lastVersion floatValue] >[currentVersion floatValue]) {
            
            newVersionURlString = [releaseInfo objectForKey:@"trackViewUrl"];
            NSLog(@"lastVersion = %@ currentVersion = %@ lastVersion trackViewUrl = %@",lastVersion,currentVersion,newVersionURlString);
            [HUD message:@"    " delegate:self Tag:101];
            
        }else{
            [HUD message:@"     "];
        }
    }else{
        [HUD message:@"     "];
    }
}
-(void)hud:(HUD *)hud clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (hud.tag == 100) {
        if (buttonIndex == 0) {
            [HUD clearHudFromApplication];
        }else{
            [HUD clearHudFromApplication];
            [[SDImageCache sharedImageCache] clearDisk];
            [self clearImageCacheAtCachePathComponent:@"com.hackemist.SDWebImageCache.default"];
            [self clearImageCacheAtCachePathComponent:@"ttcy.TtcyMngl/fsCachedData"];
            [self clearLrcCache];
        }
    }else if(hud.tag == 101){
        
        if (buttonIndex == 0) {
            
            [HUD clearHudFromApplication];
            
        }else{
            
            [HUD clearHudFromApplication];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionURlString]];
        }
    }
}
#pragma mark - shareApp ---------------------
- (void)shareApp
{
    UserShareSDK * share = [[UserShareSDK alloc]init];
    [share shareApp];
}

@end







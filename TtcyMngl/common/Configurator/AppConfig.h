//
//  AppCommon.h
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-7.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#ifndef TTCYMnglLibrary_AppCommon_h
#define TTCYMnglLibrary_AppCommon_h

//单例对象定义的宏
#define SINGLETON_DEFINE(className) +(className *)shareInstance;

#define SINGLETON_IMPLEMENT(className) \
static className* _instance = nil; \
+ (className *) shareInstance{\
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ _instance = [[self alloc] init];}); return _instance;\
}\
+ (id)allocWithZone:(NSZone *)zone{@synchronized(self) {if (_instance == nil) {_instance = [super allocWithZone:zone];return _instance;}}return nil;} \
- (id)copyWithZone:(NSZone *)zone{return self;}
/**
 *
 *   屏幕适配宏
 */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth kMainScreenFrame.size.width
#define kMainScreenHeight kMainScreenFrame.size.height - 20
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]


#define isIOS7 [[UIDevice currentDevice].systemVersion floatValue]>6.9?YES:NO
#define is4Inch kMainScreenFrame.size.height>480?YES:NO

static CGFloat topDistance = 0;
static CGFloat PlayBarHeight = 0;

#define getTopDistance() { \
    if(isIOS7) topDistance = 20;\
          else topDistance = 0;\
}
#define TopBarHeight 44

#define getPlayBarHeight()  {if(iPhone5) PlayBarHeight = 64; else PlayBarHeight = 54;}

//007bbc
#define NVC_COLOR   /*[Utils colorWithHexString:@"#007bbc"]*/  [UIColor colorWithRed:0 green:123/255.0f blue:188/255.0f alpha:.0f]
#define NVC_SELECTED_BACKGROUND  [Utils colorWithHexString:@"#04DDFF"]
#define NVC_UNSELECTED_BACKGROUND  [Utils colorWithHexString:@"#1B98DA"]

#define CENT_COLOR_4INCH [UIColor colorWithPatternImage:[UIImage imageNamed:@"applicationBG_4Inch"]]
#define CENT_COLOR       [UIColor colorWithPatternImage:[UIImage imageNamed:@"applicationBG"]]

#define NOTIFICATION_SONG_COLLECTED @"collect_update"
#define NOTIFICATION_QUEUE_UPDATE    @"queue_update"

#endif

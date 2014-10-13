//
//  UserShareSDK.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-8.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "UserShareSDK.h"
#import "Constant.h"

@interface UserShareSDK ()
{
    NSArray *shareMenuList;
    id<ISSShareOptions> shareOptions_default;
    id<ISSShareOptions> shareOptions_simple;
    id<ISSShareOptions> shareOptions_appRecommend;
}

@end


@implementation UserShareSDK

+ (void)initWithShareConfig
{
    [ShareSDK registerApp:@"227e7d3c6c08"];     //参数为ShareSDK官网中添加应用后得到的AppKey  @"227e7d3c6c08"

    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];

    [ShareSDK importWeChatClass:[WXApi class]];
}

- (void)initShareMenuList
{
    [ShareSDK setUIStyle:0];

    //构造shareMenuList，项目的顺序也会反映在菜单顺序之中
    shareMenuList = [[NSArray alloc] init];
    shareMenuList = [ShareSDK getShareListWithType:
                     ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeWeixiSession,
                          ShareTypeTencentWeibo,
                          ShareTypeDouBan,
                          ShareTypeQQSpace,
                          nil];

    //分享内容视图样式
    //1.|**< 默认 >**| --> 分享内容可编辑
    shareOptions_default = [ShareSDK defaultShareOptionsWithTitle:@"默认🈷️视图"
                                                               oneKeyShareList:shareMenuList
                                                            cameraButtonHidden:NO
                                                           mentionButtonHidden:NO
                                                             topicButtonHidden:YES
                                                                qqButtonHidden:NO
                                                         wxSessionButtonHidden:NO
                                                        wxTimelineButtonHidden:YES
                                                          showKeyboardOnAppear:NO
                                                             shareViewDelegate:nil
                                                           friendsViewDelegate:nil
                                                         picViewerViewDelegate:nil];
    
    //2.|**< 简约，只带有文字和图片显示UI >**| --> 分享内容可编辑
    shareOptions_simple = [ShareSDK simpleShareOptionsWithTitle:@"简约🈷️视图"
                                                            shareViewDelegate:nil];
    
    //3.|**< 应用推荐，专为应用推荐而设的显示样式 >**| --> 分享内容不可编辑
    shareOptions_appRecommend = [ShareSDK appRecommendShareOptionsWithTile:@"推荐🈷️视图"
                                                                 shareViewDelegate:nil];

}

-(void)shareSongWithDictionary:(NSDictionary *)songDict
{
    //在使用服务器托管配置信息初始化时，由于从服务器获取信息有一定的时间延迟，因此为保证可以在正确初始化平台后调用相关功能，SDK中提供了一个waitAppSettingComplete的方法，用于等待设置App信息完成后执行相关操作。其用法如下：
    __unsafe_unretained NSDictionary * dict = songDict;
    
    [ShareSDK waitAppSettingComplete:^{
        [self callTheShareSDKInterfaceWithSongWithDictionary:dict];
    }];
}


- (void)shareApp
{
    [ShareSDK waitAppSettingComplete:^{
        [self callTheShareSDKInterfaceWithApp];
        
    }];
}

//分享歌曲
- (void)callTheShareSDKInterfaceWithSongWithDictionary:(NSDictionary *)dict
{
    [self initShareMenuList];
    
    id<ISSContent> publishContent = nil;
    
    NSString *imagePath = dict[@"avatarImageUrl"];
    NSString *contentString = @"http://www.ttcy.com 天堂草原音乐网";
    NSString *titleString   = @"TengrTal天堂草原音乐蒙语App（www.ttcy.com）";
    NSString *urlString     = [@"http://mobi.ttcy.com/SharePlay.aspx?id=" stringByAppendingString:[dict objectForKey:@"songId"]]  ;
    NSString *description   = @"把这首好听的歌分享给大家";

    /**
     *	@brief	创建分享内容对象，根据以下每个字段适用平台说明来填充参数值
     *
     *	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、邮件、短信、微信、QQ、拷贝）
     *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、邮件、短信、微信、QQ、拷贝）
     *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、邮件、打印、微信、QQ、拷贝）
     *	@param 	title 	标题（QQ空间、人人、微信、QQ）
     *	@param 	url 	链接（QQ空间、人人、微信、QQ）
     *	@param 	description 	主体内容（QQ空间、人人）
     *	@param 	mediaType 	分享类型（QQ、微信）
     *
     *	@return	分享内容对象
     **/
    
    publishContent = [ShareSDK content:contentString
                        defaultContent:@"默认分享内容，没内容时显示"
                                 image:[ShareSDK imageWithUrl:imagePath]
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeMusic];//分享内容的消息类型，仅对微信、QQApi有效
    
    [self showShareActionSheetWithContent:publishContent ShareOptions:shareOptions_default];
}

//分享 App
- (void)callTheShareSDKInterfaceWithApp
{
    [self initShareMenuList];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"online_music_btn02@2x"  ofType:@"png"];
    //构造分享内容
    NSString *contentString = @"快来用蒙文歌曲播放器听蒙语歌曲吧,点击http://www.ttcy.com下载";
    NSString *titleString   = @"天堂草原音乐网";
    NSString *urlString     = @"http://mobi.ttcy.com/Phone_Down.htm";
    NSString *description   = @"快来用蒙文歌曲播放器听蒙语歌曲吧";
    
    id<ISSContent> publishContent = [ShareSDK content:contentString
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:titleString
                                                  url: urlString
                                          description:description
                                            mediaType:SSPublishContentMediaTypeApp];
    
    [self showShareActionSheetWithContent:publishContent ShareOptions:shareOptions_default];
}

//分享内容视图样式
- (void)showShareActionSheetWithContent:(id<ISSContent>)content ShareOptions:(id<ISSShareOptions>)shareOptions
{
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                                scopes:nil
                                                         powerByHidden:YES
                                                        followAccounts:nil
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:shareMenuList
                           content:content
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}



@end



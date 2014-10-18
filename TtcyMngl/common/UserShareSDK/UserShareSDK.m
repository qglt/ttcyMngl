//
//  UserShareSDK.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-7-8.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "UserShareSDK.h"
#import "Constant.h"
#import "HUD.h"

#define TAG_DOUBAN     100
#define TAG_WEICHAT    101
#define TAG_WEIBO      102
#define TAG_QZONE      103
#define TAG_TXWEIBO    104

@interface UserShareSDK ()
{
    NSArray *shareMenuList;
    id<ISSContent> _publishContent;
}
@property (nonatomic ,strong)UIView * shareView;

@end

@implementation UserShareSDK
SINGLETON_IMPLEMENT(UserShareSDK)
- (id)init
{
    self = [super init];
    if (self) {
        [self createShareView];
    }
    return self;
}
- (void)createShareView
{
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight+20+210)];
    _shareView.backgroundColor = [UIColor colorWithWhite:1 alpha:.1f];
    _shareView.alpha = 0;
    
    [_shareView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareViewTaped:)]];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, kMainScreenHeight+20, kMainScreenWidth, 210)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowOffset = CGSizeMake(0, -1);
    view.layer.shadowColor = [UIColor colorWithWhite:.5 alpha:.9].CGColor;
    view.layer.shadowOpacity = 1;
    [self createTitleLabelWithView:view];
    [self createSPLineWithView:view];
    [self createItemsWithView:view];
    [_shareView addSubview:view];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_shareView];
}
- (void)createTitleLabelWithView:(UIView *)view
{
    UILabel * label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:@"Menksoft Qagan" size:20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    label.textColor = [Utils colorWithHexString:@"#1B98DA"];
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    label.frame = CGRectMake(0, 0,35,view.bounds.size.height);
    [view addSubview:label];
}
- (void)createSPLineWithView:(UIView *)view
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(36, 0, .5f, view.bounds.size.height)];
    line.backgroundColor = NVC_SELECTED_BACKGROUND;
    [view addSubview:line];
}
- (void)createItemsWithView:(UIView *)view
{
    UIButton * douban = [self createButtonWithTitle:@" " tag:TAG_DOUBAN image:[UIImage imageNamed:@"share_douban"]];
    douban.center = CGPointMake(80, 50);
    [view addSubview:douban];
    
    UIButton * wechat = [self createButtonWithTitle:@"" tag:TAG_WEICHAT image:[UIImage imageNamed:@"share_wechat"]];
    wechat.center = CGPointMake((kMainScreenWidth+35)/2.f, 50);
    [view addSubview:wechat];
    
    UIButton * weibo = [self createButtonWithTitle:@" " tag:TAG_WEIBO image:[UIImage imageNamed:@"share_weibo"]];
    weibo.center = CGPointMake(kMainScreenWidth-40-10, 50);
    [view addSubview:weibo];
    
    UIButton * kongjian = [self createButtonWithTitle:@"Qzone" tag:TAG_QZONE image:[UIImage imageNamed:@"share_Qzone"]];
    kongjian.center = CGPointMake(80, 150);
    [view addSubview:kongjian];
    
    UIButton * tencentWeibo = [self createButtonWithTitle:@" " tag:TAG_TXWEIBO image:[UIImage imageNamed:@"share_txweibo"]];
    tencentWeibo.center = CGPointMake((kMainScreenWidth+35)/2.f, 150);
    [view addSubview:tencentWeibo];
}
- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSInteger)tag image:(UIImage *)image
{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:image forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    button.tag = tag;
    [button addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Menksoft Qagan" size:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    label.frame = CGRectMake(65, 0, 15, 80);
    [button addSubview:label];
    return button;
}
- (void)shareViewTaped:(UITapGestureRecognizer *)gestrue
{
    if (gestrue.state == UIGestureRecognizerStateEnded) {
        [self showShareView:NO];
    }
}
- (void)showShareView:(BOOL)show
{
    if (show) {
        [_shareView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_shareView];
        
        [UIView animateWithDuration:.3f animations:^{
            _shareView.transform = CGAffineTransformMakeTranslation(0, -210.f);
            _shareView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:.3f animations:^{
            _shareView.transform = CGAffineTransformMakeTranslation(0, +210.f);
            _shareView.alpha = 0;
        }];
    }
}
-(void)setShareConfig
{
    [ShareSDK registerApp:@"227e7d3c6c08"];     //参数为ShareSDK官网中添加应用后得到的AppKey  @"227e7d3c6c08"

    [ShareSDK importTencentWeiboClass:[WeiboApi class]];
    
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];

    [ShareSDK importWeChatClass:[WXApi class]];
}
-(void)shareSongWithDictionary:(NSDictionary *)songDict
{
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
    NSString *imagePath = dict[@"avatarImageUrl"];
    NSString *contentString = @"http://www.ttcy.com 天堂草原音乐网";
    NSString *titleString   = @"TengrTal天堂草原音乐蒙语App（www.ttcy.com）";
    NSString *urlString     = [@"http://mobi.ttcy.com/SharePlay.aspx?id=" stringByAppendingString:[dict objectForKey:@"songId"]]  ;
    NSString *description   = @"把这首好听的歌分享给大家";
    
    _publishContent = [ShareSDK content:contentString
                        defaultContent:@"默认分享内容，没内容时显示"
                                 image:[ShareSDK imageWithUrl:imagePath]
                                 title:titleString
                                   url:urlString
                           description:description
                             mediaType:SSPublishContentMediaTypeMusic];//分享内容的消息类型，仅对微信、QQApi有效
    [self showShareView:YES];
}
//分享 App
- (void)callTheShareSDKInterfaceWithApp
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"online_music_btn02@2x"  ofType:@"png"];
    //构造分享内容
    NSString *contentString = @"快来用蒙文歌曲播放器听蒙语歌曲吧,点击http://www.ttcy.com下载";
    NSString *titleString   = @"天堂草原音乐网";
    NSString *urlString     = @"http://mobi.ttcy.com/Phone_Down.htm";
    NSString *description   = @"快来用蒙文歌曲播放器听蒙语歌曲吧";
    
    _publishContent = [ShareSDK content:contentString
                         defaultContent:@"默认分享内容，没内容时显示"
                                  image:[ShareSDK imageWithPath:imagePath]
                                  title:titleString
                                    url: urlString
                            description:description
                              mediaType:SSPublishContentMediaTypeApp];
    [self showShareView:YES];
}
- (void)share:(UIButton *)sender
{
    [self showShareView:NO];
    [HUD messageForBuffering];
    switch (sender.tag)
    {
        case TAG_DOUBAN:
        {
            [self share:ShareTypeDouBan withContent:_publishContent];
        }
            break;
        case TAG_WEICHAT:
        {
            [self share:ShareTypeWeixiSession withContent:_publishContent];
        }
            break;
            
        case TAG_WEIBO:
        {
            [self share:ShareTypeSinaWeibo withContent:_publishContent];
        }
            break;
        case TAG_TXWEIBO:
        {
            [self share:ShareTypeTencentWeibo withContent:_publishContent];
        }
            break;
        case TAG_QZONE:
        {
            [self share:ShareTypeQQSpace withContent:_publishContent];
        }
            break;
        default:
            break;
    }
}
- (void)share:(ShareType)shareTpye withContent:(id<ISSContent>)content
{
    [ShareSDK shareContent:content
                      type:shareTpye
               authOptions:nil
             statusBarTips:NO
                    result:^(ShareType type,SSResponseState state,id<ISSPlatformShareInfo> statusInfo,id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSPublishContentStateSuccess)
         {
             [HUD message:@" "];
         }
         else if (state == SSPublishContentStateFail)
         {
             [HUD message:@"  "];
         }
     }];
}

@end



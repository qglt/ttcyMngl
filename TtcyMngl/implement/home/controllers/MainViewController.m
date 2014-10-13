//
//  MainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "CustemTabBar.h"
#import "PlayBar.h"
#import "STKAudioPlayer.h"
#import "QueueItemId.h"
#import "AccountManager.h"

#import "LocalMainViewController.h"
#import "OnlineMainViewController.h"
#import "MusicPlayerViewController.h"

#import "UIBarButtonItem+Addition.h"
#import "DownloadListViewController.h"
#import "HUD.h"
#import "IntroViewManager.h"

#import "UserShareSDK.h"

@interface MainViewController ()<UINavigationControllerDelegate,PlayControlDelegate,IntroViewManagerDelegate>
{
    STKAudioPlayer* _audioPlayer;
    NSInteger _currentPlayIndex;
    NSTimer * timer;
    
    CGFloat _lastBeganY;
    
    BOOL playBarHeadPressed;
    BOOL playBarMenuPressed;
}
@property (nonatomic,strong)UINavigationController * navigation;
@property (nonatomic,strong)CustemTabBar * tab ;
@property (nonatomic,strong)PlayBar * playBar;
@property (nonatomic,strong)MusicPlayerViewController * musicInfoVC;
@property (nonatomic,strong)CustemTabBar * MusicOprationBar;


@end

@implementation MainViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createPlayer];
    
    [self setBaseCondition];
    
    [self createPlayBar];
    
    [self createPlayInfoView];
    
    [self createContentView];
    
    [self checkFirst];
}
- (void)checkFirst
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstStart"];
        [self showIntroView];
    }else{
        
    }
    
}
- (void)showIntroView
{
    IntroViewManager * introManager = [[IntroViewManager alloc]initWithView:self.view delegate:self];
    [introManager showCustomIntro];
}
#pragma mark - 创建播放器
-(void)createPlayer
{
    _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
	_audioPlayer.meteringEnabled = YES;
	_audioPlayer.volume = 1;
}
#pragma mark - 初始化控件－－－－－－－－－－－
-(void)setBaseCondition
{
    getPlayBarHeight()
    getTopDistance()
    
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
-(void)createTabbar
{
    [self.view addSubview:_tab];
}
-(void)createContentView
{
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    
    self.navigation = [[UINavigationController alloc]initWithRootViewController:[[OnlineMainViewController alloc]init]];
    _navigation.delegate = self;
    _navigation.navigationBarHidden = YES;
    
    CGRect frame = self.view.bounds;
    if (!isIOS7) {
        frame.size.height-=20;
    }
    
    _navigation.view.frame = frame;
    
    _playBar.menuItemClick(_playBar.menuItems[1]);
    
    [self addChildViewController:_navigation];

    [self.view addSubview:_navigation.view];
    [self.view sendSubviewToBack:_navigation.view];
    
}

-(void)createPlayBar
{
    MenuItem * item0 = [MenuItem itemWithIcon:@"menu_local" hightLightIcon:@"menu_local_h" title:@"" vcClass:@"LocalMainViewController" andTag:10000];
    MenuItem * item1 = [MenuItem itemWithIcon:@"menu_online" hightLightIcon:@"menu_online_h" title:@"" vcClass:@"OnlineMainViewController" andTag:10001];
    NSArray * array = [NSArray arrayWithObjects:item0,item1, nil];
    
    self.playBar = [PlayBar shareInstanceWithFrame:CGRectMake(0, kMainScreenHeight - PlayBarHeight*2.f/3.f + topDistance, kMainScreenWidth,PlayBarHeight*2.f/3.f)  andAudioPlayer:_audioPlayer menuItems:array];
    _playBar.delegate = self;
    
    __unsafe_unretained MainViewController *main = self;
    _playBar.menuItemClick = ^(MenuItem *item) {
        
        Class c = NSClassFromString(item.vcClass);
        UIViewController *vc = [[c alloc] init];
        [main.navigation setViewControllers:@[vc]];
        
        [main.playBar setMenuItemSelected:item.tag];
    };
    [self.view addSubview:_playBar];
}
-(void)createPlayInfoView
{
    SongObject * aSong = [[PlayBar defultPlayer]getCurrentPlayingSong];
    if (aSong) {
        self.musicInfoVC = [[MusicPlayerViewController alloc]initWithSongObject:aSong andViewController:self];
        [_playBar addListener:_musicInfoVC];
        _musicInfoVC.view.frame = CGRectMake(0, kMainScreenHeight+topDistance, kMainScreenWidth, kMainScreenHeight+topDistance);
        __unsafe_unretained MainViewController * main = self;
        _musicInfoVC.hiddeButtonClicked = ^{
            [main hiddePlayInfoView];
        };
        [self.view addSubview:_musicInfoVC.view];
        [_playBar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPlayBarImage:)]];
    }else{}
    
}
- (void)hiddePlayInfoView
{
    [UIView animateWithDuration:.5f animations:^{
        _musicInfoVC.view.frame = CGRectMake(0, kMainScreenHeight+topDistance, kMainScreenWidth, kMainScreenHeight+topDistance);
        _musicInfoVC.view.alpha = 0;
        _playBar.alpha = 1;
        _navigation.view.alpha = 1;
    }];
}
#pragma mark - 导航控制器代理
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *root = navigationController.viewControllers[0];

    if (viewController != root) {
        
        // 1.添加左边的返回键
        
        if (isIOS7) {
            
            UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, topDistance, 50, 51);
            backButton.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
            backButton.backgroundColor = [UIColor clearColor];
            [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [backButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
            [viewController.view addSubview:backButton];
            
        }else{
            viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) name:@"nav_back"];
        }
        if ([_navigation.topViewController isKindOfClass:NSClassFromString(@"AboutViewController")]){
            _playBar.hidden = YES;
        }else{
            _playBar.hidden = NO;
        }
    }else{
        _playBar.hidden = NO;
    }
}
- (void)back
{
    if ([_navigation.topViewController isKindOfClass:NSClassFromString(@"AboutViewController")]) {
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.navigation.view cache:NO];
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.375];
        [_navigation popViewControllerAnimated:NO];
        [UIView commitAnimations];
    }else{
        [_navigation popViewControllerAnimated:YES];
    }
}
#pragma mark - 注册后台播放远程控制－－－－－－－－－－－－－－－－

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	[self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlPause:
                [_playBar resumeOrPause]; // 暂停按钮
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [_playBar resumeOrPause]; // 播放按钮
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [_playBar resumeOrPause]; // 切换播放、暂停按钮
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [_playBar playPrevMusic]; // 播放上一曲按钮
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [_playBar playNextMusic]; // 播放下一曲按钮
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - PlayBarDelegate @optional methods ----------------------
- (void)plaBarHeadButtonPressed
{
    if ([[PlayBar defultPlayer]getPlayerQueueData].count != 0) {
        if (!_musicInfoVC) {
            [self createPlayInfoView];
        }
        CGRect frame = _musicInfoVC.view.frame;
        frame.origin.y = 0;
        LOG_UI_INFO(@"%@",_musicInfoVC.view);
        [UIView animateWithDuration:.3 animations:^{
            _musicInfoVC.view.frame = frame;
            _musicInfoVC.view.alpha = 1.f;
            _navigation.view.alpha = 0.f;
            _playBar.alpha = 0.f;
        }];
    }
}
-(void)showBufferingHud:(BOOL)isShow
{
    if (isShow) {
        [HUD messageForBuffering];
    }else{
        [HUD clearHudFromApplication];
    }
}

#pragma mark - 操作当前歌曲的方法
//移除
-(void)oprationDelete
{
    if ([[PlayBar defultPlayer] getCurrentPlayingSong]) {
        [[PlayBar defultPlayer] delelteQueueWithItem:[[PlayBar defultPlayer] getCurrentPlayingSong]];
    }
}

#pragma mark - IntroViewManagerDelegate methods
- (void)introDidFinish {
    NSLog(@"Intro callback");
}

- (void)clearHudFromApplication
{
    [HUD clearHudFromApplication];
}

#pragma mark - 拖动播放器图片的方法－－－－

- (void)dragPlayBarImage:(UIPanGestureRecognizer *)pan {
    if ([[PlayBar defultPlayer]getPlayerQueueData].count != 0) {
        switch (pan.state) {
            case UIGestureRecognizerStateBegan:
                [self beganDrag];
                break;
            case UIGestureRecognizerStateEnded:
                [self endDrag];
                break;
            default:
                [self dragging:pan];
                break;
        }
    }
}
- (void)dragging:(UIPanGestureRecognizer *)pan
{
    // y方向上挪动的距离
    
    CGFloat ty = [pan translationInView:_musicInfoVC.view].y;
    CGRect frame = _musicInfoVC.view.frame;
    CGFloat y = frame.origin.y;
    y = _lastBeganY + ty;
    
    // 过滤
    if (y < 0) {
        y = 0;
    } else if (y > kMainScreenHeight) {
        y = kMainScreenHeight;
    }
    
    // 设置阴影
    if (y < kMainScreenHeight) {
        _musicInfoVC.view.layer.shadowOffset = CGSizeMake(0, -5);
    } else {
        _musicInfoVC.view.layer.shadowOffset = CGSizeMake(0, 5);
    }
    
    frame.origin.y = y;
    _musicInfoVC.view.frame = frame;
    
    _navigation.view.alpha = y/568.0;
    _musicInfoVC.view.alpha = 1-y/568.0;
    _playBar.alpha = y/1000.f;
}

- (void)beganDrag
{
    _lastBeganY = _musicInfoVC.view.frame.origin.y;
}

- (void)endDrag
{
    CGRect frame = _musicInfoVC.view.frame;
    CGFloat alpha = 0;
    // 计算y
    CGFloat y = frame.origin.y;
    if (y <= (kMainScreenHeight+topDistance)*3/4.0) {
        y = 0;
        alpha = 1.f;
    } else  { // 显示左边抽屉
        alpha = 0.f;
        y = kMainScreenHeight+topDistance;
    }
    frame.origin.y = y;
    [UIView animateWithDuration:.3 animations:^{
        _musicInfoVC.view.frame = frame;
        _musicInfoVC.view.alpha = alpha;
        _navigation.view.alpha = 1.0-alpha;
        _playBar.alpha = 1.0-alpha;
    }];
}
@end














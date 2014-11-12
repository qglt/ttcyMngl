//
//  MusicPlayerViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import "SongLrcTableView.h"
#import "SongObject.h"
#import <ASIHTTPRequest.h>
#import "PlayBar.h"
#import "UIBarButtonItem+Addition.h"
#import "MainViewControllerDelegate.h"
#import "SongObject.h"
#import "SongInfoView.h"
#import "HUD.h"
#import "PlayQueueListViewController.h"
#import "PlayBar.h"
#import "MusicOperationPanel.h"
#import "QTPageControl.h"
#import "SongOprationManager.h"
#import "AccountManager.h"
#import "AccountInfo.h"

#define TAG_HIDDE 100
#define TAG_LIST  101

@interface MusicPlayerViewController ()<ASIHTTPRequestDelegate,UIScrollViewDelegate,MusicOperationPanelDelegate,SongInfoViewDelegate>
{
    NSInteger currentLrcIndex;
    BOOL _listShow;
}
@property (nonatomic,strong)NSString * lrcFile;

@property (nonatomic,strong)SongObject * currentSong;

@property (nonatomic,strong)NSString * currentLrcInlocalPath;

@property (nonatomic,strong)SongLrcTableView * lrcTableView;

@property (nonatomic,strong)UIScrollView * contentView;

@property (nonatomic,strong)QTPageControl * pageControl;

@property (nonatomic,strong)UIViewController * callInitController;

@property (nonatomic,strong)SongInfoView * infoView;

@property (nonatomic,strong)PlayQueueListViewController * listVC;

@property (nonatomic,strong)MusicOperationPanel * operationPanel;

@end

@implementation MusicPlayerViewController

- (id)initWithSongObject:(SongObject *)obj andViewController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.callInitController = controller;
        self.currentSong = obj;
        currentLrcIndex = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setBaseCondition];
    
    [self createTopBar];
    
    [self createPageControl];
    
    [self createScorwView];
    
    [self createLrcTableView];
    
    [self createInfoView];
    
    [self createOprationPanel];
    
    [self getCurrentLrc];
    
    [self createSeparatorLine];
    
    [self createListView];
    
    [self addNotification];
    
}
-(void)createTopBar
{
    UIView * view = [[UIView alloc]init];
    if (isIOS7) {
        view.frame = CGRectMake(0, 0, kMainScreenWidth, 64);
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iOS7_NVB_BG"]];
    }else{
        view.frame = CGRectMake(0, 0, kMainScreenWidth, 44);
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iOS6_NVB_BG"]];
    }
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, view.bounds.size.height-.5f, kMainScreenWidth, .5f)];
    line.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    [view addSubview:line];
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, .5f);
    view.layer.shadowOpacity = .5f;
    [self.view addSubview:view];
    
    UIButton * listBtn = [self createButtonWithImage:@"queue_list" tag:TAG_LIST];
    listBtn.center = CGPointMake(kMainScreenWidth - listBtn.bounds.size.width/2.f-12, view.bounds.size.height-6-listBtn.bounds.size.height/2.f);
    [view addSubview:listBtn];
    UIButton * hidde = [self createButtonWithImage:@"hidde_bar" tag:TAG_HIDDE];
    hidde.center = CGPointMake(12+hidde.bounds.size.width/2.f, view.bounds.size.height-6-hidde.bounds.size.height/2.f);
    [view addSubview:hidde];
}
- (UIButton *)createButtonWithImage:(NSString *)image tag:(NSInteger)tag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, PlayBarHeight/2.f, PlayBarHeight/2.f);
    
    button.backgroundColor = [UIColor clearColor];
    
    button.tag = tag;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    return button;
}
- (void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_HIDDE:     [self hiddeSelf];    break;
        case TAG_LIST:      [self showListView]; break;
        default:
            break;
    }
}
- (void)showListView
{
    if (_listShow) {
        
        [UIView animateWithDuration:.2f animations:^{
            _listVC.view.alpha = 0;
        }];
    }else{
        [UIView animateWithDuration:.25 animations:^{
            _listVC.view.alpha = 1;
        }];
    }
    _listShow = !_listShow;
}
- (UIImage *)shotView:(UIView *)view inRect:(CGRect)rect
{
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(view.frame.size);
    }
    
    //获取图像
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *resultImg = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, rect)];
    UIGraphicsEndImageContext();
    return resultImg;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_listVC checkCurrontPlaying];
    [_operationPanel setPlayModeState:[SongOprationManager playMode]];
    AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
    if ([SongOprationManager checkCollectedSong:[[PlayBar defultPlayer] getCurrentPlayingSong] withUser:acc.phone]) {
        [_operationPanel setCollectButtonImage:@"collect_bar_selected"];
    }else{
        [_operationPanel setCollectButtonImage:@"collect_bar_unselected"];
    }
}
- (void)setBaseCondition
{
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    
    if (![_callInitController isKindOfClass:NSClassFromString(@"MainViewController")]) {
        [[PlayBar defultPlayer] Play:_currentSong];
    }
    getPlayBarHeight()
    getTopDistance()
}
#pragma mark -  获取当前歌词
-(void)getCurrentLrc
{
    self.lrcFile = nil;
    if (![self checkLrcFileInDocuments]) {
        
        [self grabLrcInBackground];
        
    }else{
        [_lrcTableView showEmptyLabel:NO];
        [self refreshLrcTable];
    }
    
    if (![_callInitController isKindOfClass:NSClassFromString(@"MainViewController")]) {
        [[PlayBar defultPlayer] Play:_currentSong];
    }
}
-(BOOL )checkLrcFileInDocuments
{
    NSString *docDir = [Utils applicationDocumentPath];
    self.currentLrcInlocalPath = [docDir stringByAppendingString:[NSString stringWithFormat:@"/%@.lrc",_currentSong.songName]];
    
    BOOL check = [[NSFileManager defaultManager] fileExistsAtPath:_currentLrcInlocalPath];
    if (check) {
        self.lrcFile = _currentLrcInlocalPath;
        return YES;
    }
    return NO;
}
- (void)grabLrcInBackground
{
    [HUD messageForBuffering];
    if (_currentSong && !([@"" isEqualToString:_currentSong.lrc_url] || nil == _currentSong.lrc_url || [_currentSong.lrc_url isKindOfClass:[NSNull class]])) {
        NSURL * url = [NSURL URLWithString: _currentSong.lrc_url];
        
        __unsafe_unretained ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.timeOutSeconds = 6;
        [request setCompletionBlock:^{
            
            NSString *responseString = [request responseString];
            
            [responseString writeToFile:_currentLrcInlocalPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            [self refreshLrcTable];
            
        }];
        [request setFailedBlock:^{
            
            [HUD clearHudFromApplication];
            [self refreshLrcTable];
            
        }];
        [request startAsynchronous];
    }else{
        [HUD clearHudFromApplication];
        [self refreshLrcTable];
    }
}
#pragma mark - 初始化控件 －－－－－－－－－－－－－－－－－－－－－－
-(void)createScorwView
{
    CGRect frame=CGRectMake(40, 44, kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight*2-44);
    if (isIOS7) {
        frame=CGRectMake(40, 64, kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight*2-44);
    }
    self.contentView = [[UIScrollView alloc]initWithFrame:frame];
    _contentView.backgroundColor = [UIColor clearColor];
    
    _contentView.contentSize = CGSizeMake(0, (kMainScreenHeight-PlayBarHeight*2-44)*2);
    _contentView.contentOffset = CGPointMake(0, 0);
    
    _contentView.pagingEnabled=YES;
    _contentView.showsVerticalScrollIndicator=NO;
    
    _contentView.delegate = self;
    
    [self.view addSubview:_contentView];
}
-(void)createPageControl
{
    self.pageControl=[[QTPageControl alloc]initWithFrame:CGRectMake(5, 80, 10, kMainScreenHeight-PlayBarHeight*2-120-64) itemCount:2];
    _pageControl.center = CGPointMake(20, (kMainScreenHeight - PlayBarHeight*2)/2.f+10);
    __unsafe_unretained MusicPlayerViewController * main = self;
    _pageControl.pageItemClick =^(NSInteger index){
        [main.pageControl setSelectedIndex:index];
        [main pageTurn:index];
    };
    _pageControl.pageItemClick(1);
    [self.view addSubview:_pageControl];
}
-(void)createLrcTableView
{
    self.lrcTableView = [[SongLrcTableView alloc]initWithFrame:CGRectOffset(_contentView.bounds, 0, _contentView.frame.size.height) andRowHeight:60.0f];
    [self.contentView addSubview:_lrcTableView];
    
}

-(void)createInfoView
{
    self.infoView = [[SongInfoView alloc]initWithFrame:CGRectOffset(_contentView.bounds, 0, 0) Song:_currentSong];
    _infoView.delegate = self;
    [self.contentView addSubview:_infoView];
}
- (void)createListView
{
    self.listVC = [[PlayQueueListViewController alloc]initWithListArray:[[PlayBar defultPlayer]
                                        getPlayerQueueData]];
    [[PlayBar defultPlayer]addListener:_listVC];
    CGFloat y = 44;
    if (isIOS7) {
        y = 64;
    }
    _listVC.view.frame = CGRectMake(0, y, kMainScreenWidth, kMainScreenHeight - y + topDistance);
    _listVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.3f];
    [self addChildViewController:_listVC];
    [self.view addSubview:_listVC.view];
    _listVC.view.alpha  = 0;
}
-(void)createSeparatorLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(40, 64, .3f, kMainScreenHeight-PlayBarHeight*2-64)];
    line.backgroundColor = [Utils colorWithHexString:@"#04DDFF"];
    [self.view addSubview:line];
}
- (void)createOprationPanel
{
    self.operationPanel = [[MusicOperationPanel alloc]initWithFrame:CGRectMake(0, kMainScreenHeight-PlayBarHeight*2+topDistance, kMainScreenWidth, PlayBarHeight*2)];
    _operationPanel.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
    _operationPanel.delegate = self;
    [self.view addSubview:_operationPanel];
}
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCondition) name:NOTIFICATION_SONG_COLLECTED object:nil];
}
- (void)updateCondition
{
    AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
    if ([SongOprationManager checkCollectedSong:[[PlayBar defultPlayer] getCurrentPlayingSong] withUser:acc.phone]) {
        [_operationPanel setCollectButtonImage:@"collect_bar_selected"];
    }else{
        [_operationPanel setCollectButtonImage:@"collect_bar_unselected"];
    }
}
#pragma mark - 操作方法 －－－－－－－－－－－－－
- (void)hiddeSelf
{
    _hiddeButtonClicked();
}
-(void)pageTurn:(NSInteger )index
{
    CGSize viewSize=_contentView.frame.size;
    [_contentView setContentOffset:CGPointMake(0, index*viewSize.height)];
}
#pragma mark - 辅加功能方法 －－－－－－－－－－－－－－
-(void)refreshLrcTable
{
    [_lrcTableView refreshLrcDataWithFileName:self.lrcFile];
}
-(void)refreshInfoView
{
    [_infoView refreshData:_currentSong];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PlayControlDelegate methods----------------

-(void)refreshPlayTime:(NSInteger)time andDuration:(NSInteger)duration
{
    static int count = 0;
    if (count == 10) {
        [_lrcTableView displaySondWord:time];
        count = 0;
    }
    count ++;
    [_operationPanel refreshSliderWithProgress:time duration:duration];
}
-(void)changeCurrentPlayingSong:(SongObject *)song
{
    _currentSong = song;
    AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
    if ([SongOprationManager checkCollectedSong:song withUser:acc.phone]) {
        [_operationPanel setCollectButtonImage:@"collect_bar_selected"];
    }else{
        [_operationPanel setCollectButtonImage:@"collect_bar_unselected"];
    }
    [self refreshInfoView];
    [self getCurrentLrc];
}
-(void)playerStatusChanged:(int)status
{
    [_operationPanel setPlayState:status];
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageHeight=self.contentView.frame.size.height;
    int currentPage=floor((self.contentView.contentOffset.y-pageHeight/2)/pageHeight)+1;
    [self.pageControl setSelectedIndex:currentPage];
}
#pragma mark - operationPanel methods ------------
-(void)operationPanelPlayModeButtonPressed
{
    [SongOprationManager changePlayMode];
    [_operationPanel setPlayModeState:[SongOprationManager playMode]];
}
-(void)operationPanelCollectButtonPressed
{
    AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
    if (![SongOprationManager checkCollectedSong:[[PlayBar defultPlayer] getCurrentPlayingSong] withUser:acc.phone]) {
        [SongOprationManager collect:safe Song:[[PlayBar defultPlayer] getCurrentPlayingSong] callBack:^(BOOL isOK) {
            if (isOK) {
                [_operationPanel setCollectButtonImage:@"collect_bar_selected"];
            }
        }];
    }else{
        [SongOprationManager collect:unSafe Song:[[PlayBar defultPlayer] getCurrentPlayingSong] callBack:^(BOOL isOK) {
            if (isOK) {
                [_operationPanel setCollectButtonImage:@"collect_bar_unselected"];
            }
        }];
    }
}
-(void)operationPanelSahareButtonPressed
{
    [SongOprationManager shareSong:[[PlayBar defultPlayer] getCurrentPlayingSong]];
}
-(void)operationPanelHiddeButtonPressed
{
    [self hiddeSelf];
}
-(void)operationPanelSliderValueChanged:(float)value
{
    [[PlayBar defultPlayer] seekToTime:value];
}
#pragma mark - SongInfoViewDelegate methods ---------
-(void)infoViewDownloadButtonPressed:(SongObject *)song
{
    [SongOprationManager download:safe Song:song callBack:^(BOOL isOK) {
        
    }];
}
-(void)infoViewGoArtlistButtonPressed:(SongObject *)song
{

}
- (void)infoViewGoAlbumButtonPressed:(SongObject *)song
{

}
@end




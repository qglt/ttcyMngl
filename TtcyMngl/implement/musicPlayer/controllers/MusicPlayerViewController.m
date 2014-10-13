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

@interface MusicPlayerViewController ()<ASIHTTPRequestDelegate,UIScrollViewDelegate,MusicOperationPanelDelegate,SongInfoViewDelegate>
{
    NSInteger currentLrcIndex;
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
    
    [self createPageControl];
    
    [self createScorwView];
    
    [self createLrcTableView];
    
    [self createInfoView];
    
    [self createOprationPanel];
    
    [self getCurrentLrc];
    
    [self createListView];
    
//    [self createHiddeButton];
    
    [self createSeparatorLine];
    
    [self addNotification];
    
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
    CGRect frame=CGRectMake(40, topDistance, kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight*2);
    self.contentView = [[UIScrollView alloc]initWithFrame:frame];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.contentSize = CGSizeMake(0, (kMainScreenHeight-PlayBarHeight*2)*3);
    _contentView.contentOffset = CGPointMake(0, kMainScreenHeight-PlayBarHeight*2);
    
    _contentView.pagingEnabled=YES;
    _contentView.showsVerticalScrollIndicator=NO;
    
    _contentView.delegate = self;
    
    [self.view addSubview:_contentView];
}
-(void)createPageControl
{
    self.pageControl=[[QTPageControl alloc]initWithFrame:CGRectMake(5, 0, 5, kMainScreenHeight-PlayBarHeight*2-120) itemCount:3];
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
    self.lrcTableView = [[SongLrcTableView alloc]initWithFrame:CGRectMake(0, (kMainScreenHeight-PlayBarHeight*2)*2, kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight) andRowHeight:60.0f];
    [self.contentView addSubview:_lrcTableView];
    
}

-(void)createInfoView
{
    self.infoView = [[SongInfoView alloc]initWithFrame:CGRectMake(0, (kMainScreenHeight-PlayBarHeight*2), kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight) Song:_currentSong];
    _infoView.delegate = self;
    [self.contentView addSubview:_infoView];
}
- (void)createListView
{
    self.listVC = [[PlayQueueListViewController alloc]initWithListArray:[[PlayBar defultPlayer]
                                        getPlayerQueueData]];
    [[PlayBar defultPlayer]addListener:_listVC];
    _listVC.view.frame = CGRectMake(0, 0, kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight*2);
    _listVC.view.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_listVC.view];
}
-(void)createSeparatorLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(40, topDistance, .3f, kMainScreenHeight-PlayBarHeight*2)];
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




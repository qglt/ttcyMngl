//
//  PlayQueueListViewController.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-20.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "PlayQueueListViewController.h"

#import "SongInfoListCell.h"
#import "SongObject.h"

#import "PlayBar.h"
#import "SongOprationManager.h"
#import "AccountManager.h"
#import "MoreOperationPanel.h"

@interface PlayQueueListViewController ()<UITableViewDelegate,UITableViewDataSource,SongInfoListCellDelegate>
{
    NSInteger playingSongIndex;
}
@property (nonatomic,strong)NSMutableArray * listData;

@property (nonatomic,strong)UITableView * dataTabel;

@property (nonatomic,strong)NSIndexPath * currentOperationIndex;

@property (nonatomic,strong)MoreOperationPanel * moreOperationPanel;

@end

@implementation PlayQueueListViewController

- (id)initWithListArray:(NSArray *)listArray 
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.listData = [NSMutableArray array];
        self.listData = [NSMutableArray arrayWithArray:listArray];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBaseCondition];
    [self createTable];
    [self createMoreOperationPanel];
    [self addNotification];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeCurrentPlayingSong:[[PlayBar defultPlayer] getCurrentPlayingSong]];
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
    getTopDistance();
    getPlayBarHeight();
}
-(void)createTable
{
    self.dataTabel = [[UITableView alloc]init];
    _dataTabel.backgroundColor = [UIColor clearColor];
    _dataTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTabel.rowHeight = 50;
    _dataTabel.delegate = self;
    _dataTabel.dataSource = self;
    _dataTabel.showsVerticalScrollIndicator = NO;
    _dataTabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _dataTabel.frame = CGRectMake(0, 0, kMainScreenWidth-40, kMainScreenHeight-PlayBarHeight*2);
    [self.view addSubview:_dataTabel];
}
- (void)createMoreOperationPanel
{
    MenuItem * item1 = [MenuItem itemWithIcon:@"" hightLightIcon:@"" title:@"" vcClass:@"share" andTag:0];
    MenuItem * item2 = [MenuItem itemWithIcon:@"" hightLightIcon:@"" title:@"" vcClass:@"down" andTag:1];
    MenuItem * item3 = [MenuItem itemWithIcon:@"" hightLightIcon:@"" title:@"" vcClass:@"delete" andTag:2];
    
    self.moreOperationPanel = [[MoreOperationPanel alloc]initWithFrame:CGRectMake(0, 0 , 180.f, 150.f) andItems:@[item1,item2,item3]];
    _moreOperationPanel.center = self.view.center;
    __unsafe_unretained PlayQueueListViewController * main = self;
    _moreOperationPanel.itemClick = ^(MenuItem * item){
        switch (item.tag) {
                
            case 0:
            {
                [SongOprationManager shareSong:main.listData[[main getcurrntIndex]]];
            }break;
            case 1:
            {
                [SongOprationManager download:safe Song:main.listData[[main getcurrntIndex]] callBack:^(BOOL isOK) {
                    
                }];
            }break;
            case 2:
            {
                [SongOprationManager operation:unSafe song:main.listData[[main getcurrntIndex]] withQueue:QueueTypeHistory callBack:^(BOOL isOK) {
                    
                }];
                [main reloadSourceData];
                [main.dataTabel reloadData];
                
            }break;
            default:
                break;
        }
        
        [main operationPanelShow:NO];
    };
    _moreOperationPanel.alpha = 0;
    [self.view addSubview:_moreOperationPanel];
}
- (NSInteger)getcurrntIndex
{
    return _currentOperationIndex.row;
}
-(void)reloadSourceData
{
    self.listData = [SongOprationManager hisPlayArray];
}

-(void)updatesubviews
{
    [_dataTabel reloadData];
}
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatesubviews) name:NOTIFICATION_SONG_COLLECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCondition) name:NOTIFICATION_QUEUE_UPDATE object:nil];
}
- (void)updateCondition
{
    [self reloadSourceData];
    [self updatesubviews];
}
- (void)operationPanelShow:(BOOL)show
{
    CGFloat alpha = 0;
    if (show) {
        alpha = 1;
    }else{
        alpha = 0;
    }
    [UIView animateWithDuration:.3f animations:^{
        _moreOperationPanel.alpha = alpha;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SongInfoListCell * cell = (SongInfoListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SongInfoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andRowheight:tableView.rowHeight];
        cell.delegate = self;
    }
    if (_listData.count == 0||_listData == nil) {
        
    }else{
        AccountManager * manager = [AccountManager shareInstance];
        if (indexPath.row == playingSongIndex) {
            cell.fontColor = [Utils colorWithHexString:@"#362875"];
        } else {
            cell.fontColor = [Utils colorWithHexString:@"#762836"];
        }
        [cell setUpCellWithSOngObject:_listData[indexPath.row] collected:[SongOprationManager checkCollectedSong:_listData[indexPath.row] withUser:manager.currentAccount.phone]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlayBar defultPlayer]Play:_listData[indexPath.row]];
}
- (void)checkCurrontPlaying
{
    [self changeCurrentPlayingSong:[[PlayBar defultPlayer] getCurrentPlayingSong]];
}
#pragma mark - PlayControlDelegate methods
-(void)changeCurrentPlayingSong:(SongObject *)song
{
    for (int i = 0;i<_listData.count;i++) {
        if ([[song description] isEqualToString:[_listData[i] description]]) {
            [self updateLrcTableView:i];
            break;
        }
    }
}
-(void)playQueueChanged:(NSArray *)songArray
{
    [_listData removeAllObjects];
    _listData = [NSMutableArray arrayWithArray:songArray];
    [self updatesubviews];
}

- (void)updateLrcTableView:(NSUInteger)lineNumber {
    
    playingSongIndex = lineNumber;
    
    if (playingSongIndex>=1) {
        [UIView animateWithDuration:0.3f animations:^{
            _dataTabel.contentOffset = CGPointMake(0, (playingSongIndex-1)*_dataTabel.rowHeight);
        }];
    }else{
        _dataTabel.contentOffset = CGPointMake(0, 0);
    }
    [_dataTabel reloadData];
}

- (void)collectButtonPressedWithCell:(id)cell
{
    NSIndexPath * indexPath = [_dataTabel indexPathForCell:cell];
    AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
    if (![SongOprationManager checkCollectedSong:_listData[indexPath.row] withUser:acc.phone]) {
        [SongOprationManager collect:safe Song:_listData[indexPath.row] callBack:^(BOOL isOK) {
            
        }];
    }else{
        [SongOprationManager collect:unSafe Song:_listData[indexPath.row] callBack:^(BOOL isOK) {
            
        }];
    }
}
- (void)morebuttonClickedWithCell:(id)cell
{
    self.currentOperationIndex = [_dataTabel indexPathForCell:cell];
    [self operationPanelShow:YES];
}
@end

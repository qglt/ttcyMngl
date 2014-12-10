//
//  BaseViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "BaseViewController.h"
#import <UIImageView+WebCache.h>
#import "SongInfoListCell.h"
#import "SongOprationManager.h"
#import "AccountInfo.h"
#import "AccountManager.h"
#import "MenuItem.h"
#import "MoreOperationPanel.h"

@interface BaseViewController ()<SongInfoListCellDelegate>

@property (nonatomic,strong)NSIndexPath * currentOperationIndex;

@property (nonatomic,strong)MoreOperationPanel * moreOperationPanel;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.arrayWithSongObject = [[NSArray alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBaseCondition];
    [self createBaseTableView];
    [self createMoreOperationPanel];
    [self addNotification];
}
- (void)setBaseCondition
{
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    if (isIOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    getPlayBarHeight()
    getTopDistance()
}
-(void)createBaseTableView
{
    self.baseTableView = [[UITableView alloc]init];
    _baseTableView.backgroundColor = [UIColor clearColor];
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.rowHeight = 50;
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    CGFloat y = 44;
    if (isIOS7) {
        y = 64;
    }
    _baseTableView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight+topDistance-y-PlayBarHeight);
    [self.view addSubview:_baseTableView];
}
- (void)createMoreOperationPanel
{
    MenuItem * item1 = [MenuItem itemWithIcon:@"" hightLightIcon:@"" title:@"" vcClass:@"share" andTag:0];
    MenuItem * item2 = [MenuItem itemWithIcon:@"" hightLightIcon:@"" title:@"" vcClass:@"down" andTag:1];
    MenuItem * item3 = [MenuItem itemWithIcon:@"" hightLightIcon:@"" title:@"" vcClass:@"delete" andTag:2];
    
    self.moreOperationPanel = [[MoreOperationPanel alloc]initWithFrame:CGRectMake(0, 0 , 180.f, 150.f) andItems:@[item1,item2,item3]];
    _moreOperationPanel.center = self.view.center;
    __unsafe_unretained BaseViewController * main = self;
    _moreOperationPanel.itemClick = ^(MenuItem * item){
        switch (item.tag) {
            
            case 0:
            {
                [SongOprationManager shareSong:main.arrayWithSongObject[[main getcurrntIndex]]];
            }break;
            case 1:
            {
                [SongOprationManager download:safe Song:main.arrayWithSongObject[[main getcurrntIndex]] callBack:^(BOOL isOK) {
                    
                }];
            }break;
            case 2:
            {
                if ([main getObjectType] == ObjectTypeHistory) {
                    [SongOprationManager operation:unSafe song:main.arrayWithSongObject[[main getcurrntIndex]] withQueue:QueueTypeHistory callBack:^(BOOL isOK) {

                    }];
                }else if ([main getObjectType] == ObjectTypeCollect){
                    [SongOprationManager operation:unSafe song:main.arrayWithSongObject[[main getcurrntIndex]] withQueue:QueueTypeCollect callBack:^(BOOL isOK) {
                        
                    }];
                }
                [main reloadSourceData];
                [main.baseTableView reloadData];
                
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
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateList) name:NOTIFICATION_SONG_COLLECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateList) name:NOTIFICATION_QUEUE_UPDATE object:nil];
}
- (void)updateList
{
    [self reloadSourceData];
    [_baseTableView reloadData];
}
#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayWithSongObject.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SongInfoListCell * cell = (SongInfoListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SongInfoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier andRowheight:tableView.rowHeight];
        cell.delegate = self;
    }
    if (_arrayWithSongObject.count == 0||_arrayWithSongObject == nil) {
        
    }else{
        AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
        [cell setUpCellWithSOngObject:_arrayWithSongObject[indexPath.row]
                            collected:[SongOprationManager checkCollectedSong:_arrayWithSongObject[indexPath.row]
                                                                     withUser:acc.phone]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[PlayBar defultPlayer]Play:_arrayWithSongObject[indexPath.row]];
    SongInfoListCell * cell = (SongInfoListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)collectButtonPressedWithCell:(id)cell
{
    _currentOperationIndex = [_baseTableView indexPathForCell:cell];
    AccountInfo * acc = [[AccountManager shareInstance] currentAccount];
    if (![SongOprationManager checkCollectedSong:_arrayWithSongObject[_currentOperationIndex.row] withUser:acc.phone]) {
        [SongOprationManager collect:safe Song:_arrayWithSongObject[_currentOperationIndex.row] callBack:^(BOOL isOK) {
            
        }];
    }else{
        [SongOprationManager collect:unSafe Song:_arrayWithSongObject[_currentOperationIndex.row] callBack:^(BOOL isOK) {
            
        }];
    }
}
- (void)morebuttonClickedWithCell:(id)cell
{
    self.currentOperationIndex = [_baseTableView indexPathForCell:cell];
    [self operationPanelShow:YES];
}
@end

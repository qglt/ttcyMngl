//
//  LocalCententView.m
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LocalCententView.h"
#import "LocalMenuButon.h"

#import "FMDBManager.h"
#import "FMDBManager+CollectSong.h"
#import "FMDBManager+DownloadSong.h"
#import "FMDBManager+PlayRecord.h"
#import "LocalMainViewController.h"
#import "AccountManager.h"

@interface LocalCententView ()<LocalMenuButonDelegate>

@property (nonatomic,strong)NSArray * titleArray;
@property (nonatomic,strong)NSArray * iconArray;
@property (nonatomic,strong)NSArray * classArray;

@end

@implementation LocalCententView


- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles icons:(NSArray *)icons classes:(NSArray *)classes
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleArray = [NSArray arrayWithArray:titles];
        self.iconArray = [NSArray arrayWithArray:icons];
        self.classArray = [NSArray arrayWithArray:classes];
        
        [self setBaseCondition];
        [self createMenuItems];
    }
    return self;
}
-(void)setBaseCondition
{
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    
    CGSize newSize = CGSizeMake(kMainScreenWidth,  kMainScreenHeight);
    self.contentSize = newSize;
}
-(void)createMenuItems
{
    static NSInteger index = 0;
    
    for (int i = 0; i < _titleArray.count; i++) {
        LocalMenuButon * button = [[LocalMenuButon alloc]initWithTitle:_titleArray[i] Icon:_iconArray[i] Class:_classArray[i] item:nil];
       
        CGFloat centerX = kMainScreenWidth/(_titleArray.count * 2) + (index * kMainScreenWidth/_titleArray.count);
        CGFloat centerY = self.bounds.size.height/5.0+50;
        button.center = CGPointMake(centerX, centerY);
        button.delegate = self;
        [self addSubview:button];
        index ++;
        index %= _titleArray.count;
    }
}
#pragma mark - localMenuDelegate methods ---------------------
-(void)menuItemPressed:(LocalMenuButon *)sender
{
    self.itemClick(sender);
}
#pragma mark - -----------------------------------------------
- (NSArray *)getSongCountInfo
{
    FMDBManager *dbManger = [FMDBManager defaultManager];
    int localSongCount = [dbManger getLocalSongsCount];
    int downloadSongCount = [dbManger getDownLoadSongCount];
    int playRecordSongCount = [dbManger getPlayRecordCount];
    NSString *collectStr = [[NSString alloc] init];
    int collectSongCount;
    AccountManager *accountManger = [AccountManager shareInstance];
    if (accountManger.status == onLine) {
        NSString *phone = accountManger.currentAccount.phone;
        collectSongCount = [dbManger getCollectSongCountWithuserID:phone];
    }else {
        collectSongCount = 0;
    }
    NSString *localStr = [NSString stringWithFormat:@"  %d ", localSongCount];
    NSString *downloadStr = [NSString stringWithFormat:@" %d ", downloadSongCount];
    NSString *playRecordStr = [NSString stringWithFormat:@" %d ", playRecordSongCount];
    collectStr = [NSString stringWithFormat:@" %d ", collectSongCount];
    NSArray *array = [[NSArray alloc] init];
    array = @[localStr, collectStr, downloadStr, playRecordStr];
    return array;
}

@end










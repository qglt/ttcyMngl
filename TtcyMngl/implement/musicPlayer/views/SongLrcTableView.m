//
//  SongLrcTableView.m
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongLrcTableView.h"
#import "MnglSongCell.h"

@interface SongLrcTableView()<UITableViewDataSource,UITableViewDelegate>
{
    NSUInteger lrcLineNumber;
}

@property (nonatomic,assign)CGFloat rowHeight;

@property (nonatomic,strong)UITableView * LrcTable;

@property (nonatomic,strong)UILabel * emptyLabel;

@property(nonatomic,strong)NSMutableArray * timeArray;

@property(nonatomic,strong)NSMutableDictionary * LrcDictionary;


@end

@implementation SongLrcTableView

-(id)initWithFrame:(CGRect)frame andRowHeight:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        getTopDistance()
        self.rowHeight = height;
        [self setBaseCondition];
        [self createEmptyLabel];
        [self createTableView];
    }
    return self;
}
-(void)setBaseCondition
{
    getTopDistance()
    getPlayBarHeight()
    
    self.backgroundColor = [UIColor clearColor];
    
    self.LrcDictionary = [NSMutableDictionary dictionary];
    self.timeArray = [NSMutableArray array];
}
-(void)createEmptyLabel
{
    NSString * str = @"  \n  \n   ";
    
    self.emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 100)];
    
    _emptyLabel.backgroundColor = [UIColor clearColor];
    _emptyLabel.center = CGPointMake(self.bounds.size.width/2.0f-10, self.bounds.size.height/2.5f);
    _emptyLabel.text = str;
    _emptyLabel.textColor = [Utils colorWithHexString:@"#22C5DF"];
    _emptyLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:17.0f];
    _emptyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _emptyLabel.numberOfLines = 0;
    [self addSubview:_emptyLabel];
    _emptyLabel.hidden = YES;
    _emptyLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    LOG_UI_DEBUG(@"歌词界面 emptyLabel ：%@",_emptyLabel);
}
-(void)createTableView
{
    
    CGFloat width = self.bounds.size.height;
    CGFloat height = self.bounds.size.width;
    CGRect rect = CGRectMake(0, 0, width-topDistance+TopBarHeight, height-10);
    
    self.LrcTable = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    _LrcTable.center = CGPointMake((self.bounds.origin.x+self.bounds.size.width)/2.0f, (self.bounds.size.height)/2.0f +TopBarHeight);
    
    _LrcTable.scrollEnabled = NO;
    
    _LrcTable.delegate = self;
    _LrcTable.dataSource = self;
    _LrcTable.showsVerticalScrollIndicator = NO;
    
    _LrcTable.rowHeight = self.rowHeight;
    _LrcTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:_LrcTable];
    
    _LrcTable.backgroundColor = [UIColor clearColor];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
    [_LrcTable setTransform:rotate];
    
}
-(void)showEmptyLabel:(BOOL)show
{
    _emptyLabel.hidden = !show;
}
-(void)reset
{
    lrcLineNumber = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lrcLineNumber inSection:0];
    [_LrcTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

-(void)refreshLrcDataWithFileName:(NSString *)lrcFileName
{
    [_LrcDictionary removeAllObjects];
    [_timeArray removeAllObjects];
    if (lrcFileName == nil) {
        [self showEmptyLabel:YES];
        
    }else{
        NSError * error;
        
        NSString *contentStr = [NSString stringWithContentsOfFile:lrcFileName encoding:NSUTF8StringEncoding error:&error];
        
        NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
        
        for (int i = 0; i < [array count]; i++) {
            
            NSString *linStr = array[i];
            NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
            
            if ([lineArray[0] length] > 8) {
                
                NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
                
                if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                    
                    NSString *lrcStr = [lineArray objectAtIndex:1];
                    NSString *timeStr = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区
                    
                    [_LrcDictionary setObject:lrcStr forKey:timeStr];
                    [_timeArray addObject:timeStr];//timeArray的count就是行数
                }
            }
        }
        
        [_LrcTable reloadData];
        
    }
    
}

- (void)myTask {
    
    sleep(3);
    
}
#pragma mark 动态显示歌词
- (void)displaySondWord:(NSUInteger)time {
    time ++;
    for (int i = 0; i < [_timeArray count]; i++) {
        
        NSArray *array = [_timeArray[i] componentsSeparatedByString:@":"];//把时间转换成秒
        NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
        if (i == [_timeArray count]-1) {
            
            //求最后一句歌词的时间点
            NSArray *array1 = [_timeArray[_timeArray.count-1] componentsSeparatedByString:@":"];
            NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
            
            if (time > currentTime1) {
                [self updateLrcTableView:i];
                break;
            }
            
        } else {
            
            //求出第一句的时间点，在第一句显示前的时间内一直加载第一句
            NSArray *array2 = [_timeArray[0] componentsSeparatedByString:@":"];
            NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
            
            if (time < currentTime2) {
                [self updateLrcTableView:0];
                //                NSLog(@"马上到第一句");
                break;
            }
            
            //求出下一步的歌词时间点，然后计算区间
            NSArray *array3 = [_timeArray[i+1] componentsSeparatedByString:@":"];
            NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
            
            if (time >= currentTime && time <= currentTime3) {
                [self updateLrcTableView:i];
                break;
            }
        }
    }
}

#pragma mark 动态更新歌词表歌词
- (void)updateLrcTableView:(NSUInteger)lineNumber {
    
    //重新载入 歌词列表lrcTabView
    lrcLineNumber = lineNumber;
    
    if (lrcLineNumber>=2) {
        [UIView animateWithDuration:.3 animations:^{
            _LrcTable.contentOffset = CGPointMake(0, (lrcLineNumber-2)*_LrcTable.rowHeight);
        }];
    }else{
        _LrcTable.contentOffset = CGPointMake(0, 0);
    }
    [_LrcTable reloadData];
}
#pragma mark - UITableView delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _timeArray.count == 0 ? 1: _timeArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MnglSongCell * cell = (MnglSongCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[MnglSongCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_timeArray.count == 0||_timeArray == nil) {
        
    }else{
        if (indexPath.row == lrcLineNumber) {
            cell.fontColor = [UIColor colorWithWhite:1 alpha:1];
        } else {
            cell.fontColor = [UIColor colorWithWhite:0 alpha:1];
        }
        [cell setUpCellWithText:_LrcDictionary[_timeArray[indexPath.row]]];
    }
    return cell;
}

@end

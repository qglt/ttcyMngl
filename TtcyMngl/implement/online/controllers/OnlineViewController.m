//
//  OnlineViewController.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-7-1.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineViewController.h"
#import "Celebrity.h"
#import "CommonClass.h"
#import "CelebrityCell.h"
#import "Celebrity.h"
#import "OnlineCelebritView.h"
#import "Model.h"
#import "HUD.h"

#define navigationWhile 51
#define sideLabelColor whiteColor
#define celebrityCellHeight kMainScreenHeight-120-44

@interface OnlineViewController ()

@property (nonatomic,strong)UILabel * emptyLabel;

@end

@implementation OnlineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

-(void)initView{
    CGRect frame=self.view.frame;
    
    frame.origin.y=0;
    
    self.mostlyView=[[UIView alloc]initWithFrame:frame];
    
    
    [self.view addSubview: self.mostlyView];
    
}
- (void)OnlineviewDidLoad
{
    [super viewDidLoad];
    getTopDistance()
    getPlayBarHeight()
    [CommonClass backgroundColorWhitUIView:self.mostlyView];
    [self addNavigationView];
    [self createEmptyLabel];
}
- (void)createEmptyLabel
{
    self.emptyLabel = [[UILabel alloc]init];
    _emptyLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    _emptyLabel.frame = CGRectMake(0, 0, 80, 40);
    _emptyLabel.center = celebrityTableView.center;
    _emptyLabel.hidden = YES;
    [self.view addSubview:_emptyLabel];
}
#pragma mark 添加右侧导航
-(void)addNavigationView{
    
    OnlineCelebritView *onlineCelebritView=[[OnlineCelebritView  alloc] initWithFrame:CGRectMake(0, 0, navigationWhile, kMainScreenHeight-20-PlayBarHeight*2/3.f+topDistance)];
    
    onlineCelebritView.delegate=self;
    
    [self.mostlyView addSubview: [onlineCelebritView addCelebritTypesViewViewTitle:_navigationTitle url:_navigationUrl]];
    _typeModel=[onlineCelebritView getTypeModels];
    
}
//初始化  UITableView
-(void)initialize{
    _pageCount=0;
    _models=[[NSMutableArray alloc]init];
    [celebrityTableView removeFromSuperview];
    celebrityTableView=[[UITableView alloc]init];
    celebrityTableView.dataSource=self;
    celebrityTableView.delegate=self;
    celebrityTableView.transform =CGAffineTransformMakeRotation(-M_PI_2);
    celebrityTableView.frame=CGRectMake(navigationWhile+2,0, kMainScreenWidth-navigationWhile,kMainScreenHeight-PlayBarHeight);
    [celebrityTableView setBackgroundColor:[UIColor clearColor]];
    celebrityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mostlyView addSubview:celebrityTableView];
    
    celebrityTableView.showsVerticalScrollIndicator = NO;
    celebrityTableView.showsHorizontalScrollIndicator = NO;
}
#pragma mark  数据源方法
#pragma mark 有多少数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self isKindOfClass:NSClassFromString(@"OnlineAlbumMusicViewController")]) {
        return _models.count;
    }
    return  _models.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}
#pragma mark --代理方法
#pragma mark  行高  旋转后的行宽
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark 加载数据
-(void)loadMore
{
    _pageCount++;
    NSMutableArray *mutabs=[[NSMutableArray alloc]init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *array = [CommonClass getJosnNSArrayUrl:_Url  sid:@"Model"];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD clearHudFromApplication];
            NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:_models.count inSection:0];
            CelebrityCell *loadMoreCell=(CelebrityCell *)[celebrityTableView cellForRowAtIndexPath:newPath];
            loadMoreCell.userInteractionEnabled = NO;
            if (array==nil) {
                [loadMoreCell setLoadTitle:@"  "];
            }else{
                for (NSDictionary *dict in array) {
                    Class class= NSClassFromString(_modeName);
                    
                    Model *model=[class  initWithDict:dict];
                    [mutabs addObject:model];
                     [_models addObject:model];
                }
                [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:mutabs waitUntilDone:NO];
            }
        });
    });
}
-(void) appendTableWith:(NSMutableArray *)data
{
    //[HUD clearHudFromApplication];
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:15];
    
    for (int ind = 0; ind < [data count]; ind++) {
        
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[_models indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
        
    }
    [celebrityTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark 歌曲分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    [self initialize];
    _nonceType=selButton.tag;
    [self loadMore];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


@end

//
//  PlayListViewController.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "PlayListViewController.h"

@interface PlayListViewController ()

@property (nonatomic,strong)NSMutableArray * listArray;

@end

@implementation PlayListViewController

-(id)initWithListArray:(NSMutableArray *)queuelist;
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.listArray = [NSMutableArray array];
        self.listArray = queuelist;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

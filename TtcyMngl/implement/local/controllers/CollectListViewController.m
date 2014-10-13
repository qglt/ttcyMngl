//
//  CollectListViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-27.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "CollectListViewController.h"
#import "AccountManager.h"
#import "SongOprationManager.h"
#import "HUD.h"

@interface CollectListViewController ()

@end

@implementation CollectListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationBarTitle = @" ";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadSourceData];
}
- (void)reloadSourceData
{
    AccountManager *accountManger = [AccountManager shareInstance];
    if (accountManger.status == onLine) {
        NSString *phone = accountManger.currentAccount.phone;
        self.arrayWithSongObject = [SongOprationManager collectArrayWithUserId:phone];
    }else{
        [HUD message:@"  "];
    }
}
- (ObjectType)getObjectType
{
    return ObjectTypeCollect;
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

//
//  SongListViewController.m
//  TtcyMngl
//
//  Created by Lucky_Truda on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "SongListViewController.h"



@interface SongListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
     UIImageView *singerImage;
     UILabel *singerLabel;
     UILabel *songLabel;
}

@end

@implementation SongListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        NSString *title = 
        self.navigationBarTitle = @" ";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    FMDBManager* manger = [FMDBManager defaultManager];
    NSArray* songList = [[NSArray alloc] init];
    songList = [manger getAllSongFromDB];
    self.arrayWithSongObject = songList; 
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

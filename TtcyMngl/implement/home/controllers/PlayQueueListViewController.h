//
//  PlayQueueListViewController.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-20.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayControlDelegate.h"

@interface PlayQueueListViewController : UIViewController<PlayControlDelegate>

- (id)initWithListArray:(NSArray *)listArray;

- (void)checkCurrontPlaying;

@end

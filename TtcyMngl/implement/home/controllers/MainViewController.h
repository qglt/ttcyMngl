//
//  MainViewController.h
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewControllerDelegate.h"

@interface MainViewController : UIViewController

@property (nonatomic, weak)__weak id <MainViewControllerPlayerDelegate>playDelegate;

@end

//
//  IntroViewManager.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntroView.h"
@class IntroPage;


@protocol IntroViewManagerDelegate

@optional
- (void)introDidFinish;

@end

@interface IntroViewManager : NSObject<IntroViewDelegate>

@property (nonatomic,strong)UIView * view;

@property (nonatomic,weak) __weak id<IntroViewManagerDelegate>delegate;

- (id)initWithView:(UIView *)view delegate:(id<IntroViewManagerDelegate>)delegate;

- (void)showIntroWithCrossDissolve;
- (void)showBasicIntroWithBg;
- (void)showBasicIntroWithFixedTitleView;
- (void)showCustomIntro;
- (void)showIntroWithCustomView;
- (void)showIntroWithSeparatePagesInit;

@end

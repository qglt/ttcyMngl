//
//  IntroView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroViewDelegate

@optional
- (void)introDidFinish;

@end

@interface IntroView : UIView<UIScrollViewDelegate>

@property (nonatomic, weak) __weak id<IntroViewDelegate> delegate;

@property (nonatomic, assign) bool swipeToExit;
@property (nonatomic, assign) bool hideOffscreenPages;
@property (nonatomic, retain) UIImage *bgImage;
@property (nonatomic, retain) UIView *titleView;
@property (nonatomic, assign) CGFloat titleViewY;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat pageControlY;
@property (nonatomic, retain) UIButton *skipButton;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIImageView *pageBgBack;
@property (nonatomic, retain) UIImageView *pageBgFront;
@property (nonatomic, retain) NSArray *pages;

- (id)initWithFrame:(CGRect)frame andPages:(NSArray *)pagesArray;

- (void)showInView:(UIView *)view animateDuration:(CGFloat)duration;
- (void)hideWithFadeOutDuration:(CGFloat)duration;

@end

//
//  IntroViewManager.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "IntroViewManager.h"
#import "IntroView.h"
#import "IntroPage.h"
#import "CustomPage.h"

@implementation IntroViewManager

-(id)initWithView:(UIView *)view delegate:(id<IntroViewManagerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.view = view;
        self.delegate = delegate;
    }
    return self;
}
- (void)showIntroWithCrossDissolve {
    
    
    IntroPage *page1 = [IntroPage page];
    page1.title = @"page 1";
    page1.desc = @"这是第 1 个页面 ～";
    page1.bgImage = [Utils createImageWithColor:[UIColor redColor]];
    page1.titleImage = [UIImage imageNamed:@"players_img_default"];
    
    
    
    IntroPage *page2 = [IntroPage page];
    page2.title = @"page 2";
    page2.desc = @"这是第 2 个页面 ～";
    page2.bgImage = [Utils createImageWithColor:[UIColor blueColor]];
    page2.titleImage = [UIImage imageNamed:@"players_img_default"];
    
    
    
    IntroPage *page3 = [IntroPage page];
    page3.title = @"page 3";
    page3.desc = @"这是第 3 个页面 ～";
    page3.bgImage = [Utils createImageWithColor:[UIColor greenColor]];
    page3.titleImage = [UIImage imageNamed:@"players_img_default"];
    
    IntroView *intro = [[IntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0];
}

- (void)showBasicIntroWithBg {
    IntroPage *page1 = [IntroPage page];
    page1.title = @"";
    page1.desc = @"";
    page1.titleImage = [UIImage imageNamed:@""];
    
    IntroPage *page2 = [IntroPage page];
    page2.title = @"";
    page2.desc = @"";
    page2.titleImage = [UIImage imageNamed:@""];
    
    IntroPage *page3 = [IntroPage page];
    page3.title = @"";
    page3.desc = @"";
    page3.titleImage = [UIImage imageNamed:@""];
    
    IntroView *intro = [[IntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    intro.bgImage = [UIImage imageNamed:@"introBg"];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showBasicIntroWithFixedTitleView {
    IntroPage *page1 = [IntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"";
    
    IntroPage *page2 = [IntroPage page];
    page2.title = @"page 2";
    page2.desc = @"";
    
    IntroPage *page3 = [IntroPage page];
    page3.title = @"";
    page3.desc = @"";
    
    IntroView *intro = [[IntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"original"]];
    intro.titleView = titleView;
    intro.backgroundColor = [UIColor colorWithRed:0.0f green:0.49f blue:0.96f alpha:1.0f];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showCustomIntro {
    
    NSString * image1 = @"IMG_4210.PNG";
    NSString * image2 = @"IMG_4213.PNG";
    NSString * image3 = @"IMG_4209.PNG";
    if (is4Inch) {
        image1 = @"IMG_0233.PNG";
        image2 = @"IMG_0238.PNG";
        image3 = @"IMG_0232.PNG";
    }
    CustomPage * cp1 = [[CustomPage alloc]initWithImage:image1 title:@"    " detail:@"    "];
    
    IntroPage *page1 = [IntroPage pageWithCustomView:cp1];
    
    CustomPage * cp2 = [[CustomPage alloc]initWithImage:image2 title:@"      App" detail:@"          \n TengrTal          "];
    IntroPage *page2 = [IntroPage pageWithCustomView:cp2];
    
    CustomPage * cp3 = [[CustomPage alloc]initWithImage:image3 title:@"" detail:@"  www.ttcy.com   \n        "];
    IntroPage *page3 = [IntroPage pageWithCustomView:cp3];
    
    IntroView *intro = [[IntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
    intro.bgImage = [UIImage imageNamed:@"introBg@2x.png"];
    intro.pageControlY = 100.0f;
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithCustomView {
    IntroPage *page1 = [IntroPage page];
    page1.title = @"";
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@""];
    page1.titleImage = [UIImage imageNamed:@""];
    
//    UIView *viewForPage2 = [[UIView alloc] initWithFrame:self.view.bounds];
    UILabel *labelForPage2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 300, 30)];
    labelForPage2.text = @"";
    labelForPage2.font = [UIFont systemFontOfSize:32];
    labelForPage2.textColor = [UIColor whiteColor];
    labelForPage2.backgroundColor = [UIColor clearColor];
    labelForPage2.transform = CGAffineTransformMakeRotation(M_PI_2*3);
//    [viewForPage2 addSubview:labelForPage2];
//    IntroPage *page2 = [IntroPage pageWithCustomView:viewForPage2];
    
    IntroPage *page3 = [IntroPage page];
    page3.title = @"";
    page3.desc = @"";
    page3.bgImage = [UIImage imageNamed:@"3"];
    page3.titleImage = [UIImage imageNamed:@"femalecodertocat"];
    
//    IntroView *intro = [[IntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3]];
//    
//    [intro setDelegate:self];
//    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithSeparatePagesInit {
//    IntroView *intro = [[IntroView alloc] initWithFrame:self.view.bounds];
    
//    [intro setDelegate:self];
//    [intro showInView:self.view animateDuration:0.0];
    
    IntroPage *page1 = [IntroPage page];
    page1.title = @"";
    page1.desc = @"";
    page1.bgImage = [UIImage imageNamed:@""];
    page1.titleImage = [UIImage imageNamed:@""];
    
    IntroPage *page2 = [IntroPage page];
    page2.title = @"";
    page2.desc = @"";
    page2.bgImage = [UIImage imageNamed:@""];
    page2.titleImage = [UIImage imageNamed:@""];
    
    IntroPage *page3 = [IntroPage page];
    page3.title = @"";
    page3.desc = @"";
    page3.bgImage = [UIImage imageNamed:@""];
    page3.titleImage = [UIImage imageNamed:@""];
    
//    [intro setPages:@[page1,page2,page3]];
}

- (void)introDidFinish {
    if ([(id)self.delegate respondsToSelector:@selector(introDidFinish)]) {
        [self.delegate introDidFinish];
    }
}

@end

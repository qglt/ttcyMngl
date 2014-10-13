//
//  OnlineMainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineMainViewController.h"
#import "OnlineCelebritysViewController.h"
#import "OnlineAlbumViewController.h"
#import "OnlineRecViewController.h"
#import "OnlineTaxisViewController.h"
#import "CommonClass.h"
#import "LocalCententView.h"
#import "OnlineAvd.h"

@interface OnlineMainViewController ()<UIScrollViewDelegate>{
   
}
@property (nonatomic,strong)LocalCententView * contentView;

@property (nonatomic,strong)OnlineAvd * adView;

@property (nonatomic,strong)UIPageControl * pageControl;

@end

@implementation OnlineMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createAdvertisementView];
    [self createPageControl];
    [self createContentView];
}
- (void)setBaseCondition
{
    getTopDistance()
    getPlayBarHeight()
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        
    }
}
- (void)createAdvertisementView
{
    NSArray *holders = @[@"intro_content_img@2x.png",@"ad_img@2x.png"];
    NSArray *items  = @[@"http://mongol.ttcy.com/image_app_ad/iosAppAdv_1.jpg",@"http://mongol.ttcy.com/image_app_ad/iosAppAdv_2.jpg"];
    
    self.adView = [[OnlineAvd alloc]initWithFrame:CGRectMake(0, 20, kMainScreenWidth, 140) items:items placeHolders:holders];
    _adView.delegate = self;
    [self.view addSubview:_adView];
}
- (void)createPageControl
{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.view.center.x-5, 140, 30, 10)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = 2;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
}

- (void)createContentView
{
    NSArray * titleArray = @[@"",@"",@"",@""];
    NSArray * imageArray = @[@"item_tag",@"item_tag",@"item_tag",@"item_tag"];
    NSArray * classArray = @[@"OnlineRecViewController",@"OnlineAlbumViewController",@"OnlineCelebritysViewController",@"OnlineTaxisViewController"];
    
    self.contentView = [[LocalCententView alloc]initWithFrame:CGRectMake(0, 160, kMainScreenWidth, kMainScreenHeight-160)
                                                       titles:titleArray
                                                        icons:imageArray
                                                      classes:classArray];
    [self.view addSubview:_contentView];
    
    __unsafe_unretained OnlineMainViewController * main = self;
    
    _contentView.itemClick = ^(LocalMenuButon *item) {
        
        Class c = NSClassFromString(item.vcClass);
        UIViewController *vc = [[c alloc] init];
        [main.navigationController pushViewController:vc animated:YES];
    };
}
#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth=self.adView.frame.size.width;
    int currentPage=floor((self.adView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = currentPage;
}
@end

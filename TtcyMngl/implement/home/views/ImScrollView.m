//
//  ImScrollView.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-24.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "ImScrollView.h"


@interface ImScrollView () <UIScrollViewDelegate>{

  
}
@end
@implementation ImScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWth{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}
+(id)ImScrollViewWithFrame:(CGRect)frame jsonUrl:(NSString *)jsonUrl{
    
    ImScrollView *imscrollView=[[ImScrollView alloc]initWithFrame:frame];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
    @"intro_content_img@2x.png",@"ad_img@2x.png",nil];
    UIScrollView *scrollView=[[UIScrollView alloc]init];
    int i=0;
    frame.origin.y=0;
    scrollView.frame=frame;
    for (NSString *imageUrl in array) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height)];
        imageView.image=[UIImage imageNamed:imageUrl];
        [scrollView addSubview:imageView];
        i++;
    }
    //设置水平和吹着滚动
    scrollView.contentSize=CGSizeMake(i*frame.size.width,0);
      scrollView.showsHorizontalScrollIndicator = NO;
    

    
      scrollView.delegate = imscrollView;
    scrollView.pagingEnabled=YES;

    // 禁止默认的点击功能
    //pageControl.enabled = NO;
    [imscrollView addSubview:scrollView];
   
    // 添加PageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    //pageControl.center = CGPointMake(50,20);
    pageControl.frame=CGRectMake((frame.size.width-150)*0.5,frame.size.height-20, 150, 10);
    pageControl.numberOfPages = array.count; // 一共显示多少个圆点（多少页）
    // 设置非选中页的圆点颜色
    pageControl.pageIndicatorTintColor = [UIColor redColor];
    // 设置选中页的圆点颜色
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    
    [pageControl addTarget:imscrollView action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];

    [imscrollView addSubview:pageControl];
     imscrollView.pageControl = pageControl;
    imscrollView.scrollView=scrollView;
    return imscrollView;

}
-(void)pageChanged:(id)sender{
    UIPageControl* control = (UIPageControl*)sender;
    NSInteger page = control.currentPage;
    CGRect from= self.scrollView.frame;
    
    self.scrollView.contentOffset=CGPointMake(from.size.width*page, self.scrollView.contentOffset.y);
  

    //添加你要处理的代码
}
#pragma mark - UIScrollView的代理方法
#pragma mark 当scrollView正在滚动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    //    NSLog(@"%d", page);
    
    // 设置页码
    self.pageControl.currentPage = page;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

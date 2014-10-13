//
//  OnlineCelebritView.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineCelebritView.h"
#import "CommonClass.h"
@implementation OnlineCelebritView
#define navigationWhile 51
#define sideLabelColor [Utils colorWithHexString:@"#04DDFF"]
#define PageSize 15

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    _nonceType=1;
    return self;
}
#pragma mark 添加右侧导航
-(id)addCelebritTypesViewViewTitle:(NSString *)viewTitle url:(NSString*)url {

    CGRect frame=self.frame;
     _models=[[NSMutableArray alloc]init];
    UILabel *sideLabel=[[UILabel alloc]initWithFrame:CGRectMake(navigationWhile,0, 0.4 , frame.size.height)];
    sideLabel.backgroundColor=[Utils colorWithHexString:@"#04DDFF"];
    [self addSubview:sideLabel];
    
#warning 这个是标题
//    UILabel *titleLabel=[[UILabel alloc]init];
//    titleLabel.text=viewTitle;//
//    titleLabel.font=[CommonClass setTransformUIView:titleLabel uiFont:titleLabel.font];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [self addSubview:titleLabel];
//    
//    titleLabel.frame=CGRectMake(0, 10, navigationWhile-1, 100);
    
    UILabel *side2Label=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, navigationWhile, 0.4)];
    side2Label.backgroundColor=sideLabelColor;
    [self addSubview: side2Label];
    
    UIScrollView *navigationScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 51, navigationWhile, self.frame.size.height-51)];
    navigationScrollView.tag=92;
    navigationScrollView.showsVerticalScrollIndicator = FALSE;
    navigationScrollView.showsHorizontalScrollIndicator = FALSE;

       NSString * path = [[NSBundle mainBundle] pathForResource: url ofType:nil];
  
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:path];  //读取出来
    
     NSArray *array = [dic objectForKey:@"Model"];
   
    int count=0;
    UILabel *side3Label;
    UIButton *typeButton;
    
    
    for (NSDictionary *dict in array) {
        typeButton=[[UIButton alloc]init];
        typeButton.titleLabel.font=[CommonClass setTransformUIView:typeButton uiFont:typeButton.titleLabel.font];
        [typeButton setTitle:dict[@"MO_Name"] forState:UIControlStateNormal];
        [_models addObject:dict[@"id"]];
        
        typeButton.tag=count+1;
        typeButton.frame=CGRectMake(0, (count*180), navigationWhile-1, 180);
        side3Label=[[UILabel alloc]initWithFrame:CGRectMake(typeButton.frame.size.height-1,0,0.4 , navigationWhile)];
        side3Label.backgroundColor=sideLabelColor;
        [typeButton addSubview: side3Label];
        [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(TypebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navigationScrollView addSubview:typeButton];
        count++;
    }

    [self addSubview:navigationScrollView];
    
    UILabel *side4Label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-.4f, navigationWhile, 0.4)];
    side4Label.backgroundColor=sideLabelColor;
    [self addSubview: side2Label];
    
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [self TypebtnClick:butt];
    //设置水平和吹着滚动
    navigationScrollView.contentSize=CGSizeMake(0,count*190+50);
    return self;
}

#pragma mark 分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    
    UIScrollView * view = (UIScrollView *)[self viewWithTag:92];
    
    [view viewWithTag:_nonceType].backgroundColor=[UIColor clearColor];
    _nonceType=selButton.tag;
    [view viewWithTag:_nonceType].backgroundColor=[Utils colorWithHexString:@"#04DDFF"];
    [delegate TypebtnClick:selButton];
    
    if (_nonceType ==1) {
        [UIView animateWithDuration:.5f animations:^{
            view.contentOffset = CGPointMake(0, 180);
        }];
        
        [self performSelector:@selector(scrollToTop) withObject:nil afterDelay:.5f];
    }else{
        [self scrollToIndex:(_nonceType-1)];
    }
    
}
- (void)scrollToTop
{
    UIScrollView * view = (UIScrollView *)[self viewWithTag:92];
    [UIView animateWithDuration:.5f animations:^{
        view.contentOffset = CGPointMake(0, 0);
    }];
}
- (void)scrollToIndex:(NSInteger)index
{
    UIScrollView * view = (UIScrollView *)[self viewWithTag:92];
    
    [UIView animateWithDuration:.3f animations:^{
        view.contentOffset = CGPointMake(0, 180 * index);
    }];
}
-(NSMutableArray *)getTypeModels{
    return _models;
}

@end

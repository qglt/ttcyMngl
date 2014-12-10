//
//  OnlineCelebritView.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "OnlineCelebritView.h"
#import "CommonClass.h"
#import <objc/runtime.h>

#define navigationWhile 51
#define sideLabelColor [Utils colorWithHexString:@"#04DDFF"]
#define PageSize 15

@implementation OnlineCelebritView
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
     self.models=[NSMutableArray array];
    UILabel *sideLabel=[[UILabel alloc]initWithFrame:CGRectMake(navigationWhile,0, 0.4 , frame.size.height)];
    sideLabel.backgroundColor=[Utils colorWithHexString:@"#04DDFF"];
    [self addSubview:sideLabel];
    getTopDistance()
    
    UIScrollView *navigationScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, navigationWhile, kMainScreenHeight-84-PlayBarHeight*2/3.f+topDistance)];
    navigationScrollView.tag=92;
    navigationScrollView.showsVerticalScrollIndicator = FALSE;
    navigationScrollView.showsHorizontalScrollIndicator = FALSE;

       NSString * path = [[NSBundle mainBundle] pathForResource:url ofType:nil];
  
        NSDictionary* dic = [[NSDictionary alloc] initWithContentsOfFile:path];  //读取出来
    
     NSArray *array = [dic objectForKey:@"Model"];
   
    int count=0;
    UILabel *side3Label;
    UIButton *typeButton;
    
    CGFloat y = 0;
    
    for (NSDictionary *dict in array) {
        typeButton=[[UIButton alloc]init];
        typeButton.titleLabel.font=[CommonClass setTransformUIView:typeButton uiFont:typeButton.titleLabel.font];
        [typeButton setTitle:dict[@"MO_Name"] forState:UIControlStateNormal];
        [_models addObject:dict[@"id"]];
        typeButton.tag=count+1;
        
        CGSize size = [dict[@"MO_Name"] sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:20]];
        typeButton.frame=CGRectMake(0, y, navigationWhile-1, size.width+30);
        
        if (array.count <=3) {
            typeButton.frame=CGRectMake(0, ((kMainScreenHeight-44-PlayBarHeight*2/3.f)/3.f)*count-1, navigationWhile-1, (kMainScreenHeight-44-PlayBarHeight*2/3.f)/3.f);
            objc_setAssociatedObject(typeButton, @"scroll", @"no", OBJC_ASSOCIATION_RETAIN);
        }
        side3Label=[[UILabel alloc]initWithFrame:CGRectMake(typeButton.frame.size.height-1,0,0.4 , navigationWhile)];
        side3Label.backgroundColor=sideLabelColor;
        [typeButton addSubview: side3Label];
        [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeButton addTarget:self action:@selector(TypebtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navigationScrollView addSubview:typeButton];
        count++;
        y += size.width+30;
    }
    
    navigationScrollView.contentSize = CGSizeMake(navigationWhile, y);
    
    [self addSubview:navigationScrollView];
    
    UILabel *side4Label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-.4f, navigationWhile, 0.4)];
    side4Label.backgroundColor=sideLabelColor;
    
    UIButton *butt=[[UIButton alloc]init];
    butt.tag=1;
    [self TypebtnClick:butt];
    return self;
}

#pragma mark 分类导航按钮单击事件
-(void)TypebtnClick:(UIButton *)selButton{
    
    UIScrollView * view = (UIScrollView *)[self viewWithTag:92];
    
    [view viewWithTag:_nonceType].backgroundColor=[UIColor clearColor];
    _nonceType=selButton.tag;
    [view viewWithTag:_nonceType].backgroundColor=[Utils colorWithHexString:@"#04DDFF"];
    [delegate TypebtnClick:selButton];
    NSString * identifier = objc_getAssociatedObject(selButton, @"scroll");
    if ([@"no" isEqualToString:identifier]) {
        
    }else{
        if (_nonceType ==1) {
            [UIView animateWithDuration:.5f animations:^{
                view.contentOffset = CGPointMake(0, selButton.frame.size.height);
            }];
            [self performSelector:@selector(scrollToTop) withObject:nil afterDelay:.5f];
        }else{
            
            [UIView animateWithDuration:.3f animations:^{
                view.contentOffset = CGPointMake(0, selButton.frame.origin.y);
            }];
        }
    }
}
- (void)scrollToTop
{
    UIScrollView * view = (UIScrollView *)[self viewWithTag:92];
    [UIView animateWithDuration:.5f animations:^{
        view.contentOffset = CGPointMake(0, 0);
    }];
}
-(NSMutableArray *)getTypeModels{
    return _models;
}

@end

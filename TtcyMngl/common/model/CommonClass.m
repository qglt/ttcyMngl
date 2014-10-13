//
//  CommonClass.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-19.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "CommonClass.h"
#import "RequestJson.h"

@implementation CommonClass

+(id) setTransformUIView:(UIView *)veie uiFont:(UIFont *)uiFont{
    uiFont = [UIFont fontWithName:@"Menksoft Qagan" size:20];
    veie.transform = CGAffineTransformMakeRotation(M_PI*0.5);
    return uiFont;
    
}
+(id)setTransformuiFont:(UIFont *)uiFont{
    uiFont = [UIFont fontWithName:@"Menksoft Qagan" size:20];
    return uiFont;
}

+(id)getJosnNSArrayUrl:(NSString*)url sid:( NSString *)sid{
    @autoreleasepool {
        NSString *strUrl=[NSString stringWithFormat:@"%@%@",@"http://api.ttcy.com",url];
        
        return   [[RequestJson alloc]getJosnNSArrayUrl:strUrl sid:sid];
    }
    
}
#pragma mark设置背景色
+(void)backgroundColorWhitUIView:(UIView *)uiview{
    if (is4Inch) {
        uiview.backgroundColor = CENT_COLOR_4INCH;
    }else{
        uiview.backgroundColor = CENT_COLOR;
    }
}

+(id)loadingWithViewController:(UIViewController *)con{
    
    [[con.view viewWithTag:91]removeFromSuperview];
    CGRect from=con.view.frame;
    UIView *loadingView=[[UIView alloc]initWithFrame:CGRectMake(from.size.width/2, (from.size.height-200)/2, 60, 200)];
    UIActivityIndicatorView  *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    
    //创建一个UIActivityIndicatorView对象：_activityIndicatorView，并初始化风格。
    _activityIndicatorView.frame = CGRectMake(20,10,20,20);
    //设置对象的位置，大小是固定不变的。WhiteLarge为37 * 37，White为20 * 20
    _activityIndicatorView.color = [UIColor blueColor];
    //设置活动指示器的颜色
    _activityIndicatorView.hidesWhenStopped = NO;
    //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
    [loadingView addSubview:_activityIndicatorView];
    //将对象加入到view
    [_activityIndicatorView startAnimating];
    [loadingView addSubview:_activityIndicatorView];
    
    UIButton *shutBut=[[UIButton alloc]initWithFrame:CGRectMake(35, -3, 25, 25)];
    [shutBut addTarget:con action:@selector(shutButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shutBut setImage:[UIImage imageNamed:@"remove_btn_h@2x.png"] forState:UIControlStateNormal];
    
    [loadingView addSubview:shutBut];
    UILabel *loadLabel=[[UILabel alloc]init];
    loadLabel.font=[self setTransformUIView:loadLabel uiFont:loadLabel.font];
    
    loadLabel.frame=CGRectMake(19, 44, 21, 145);
    loadLabel.text=@"   ";
    [loadLabel setBackgroundColor:[UIColor clearColor]];
    [loadingView addSubview:loadLabel];
    
    [con.view addSubview:loadingView];
    return loadingView;
}
+(id)nilRemindViewForm:(CGRect)from content:(NSString *)content{
    UIView *loadingView=[[UIView alloc]initWithFrame:CGRectMake(from.size.width/2, (from.size.height-200)/2, 60, 200)];
    UILabel *loadLabel=[[UILabel alloc]init];
    loadingView.tag=91;
    loadLabel.font=[self setTransformUIView:loadLabel uiFont:loadLabel.font];
    
    loadLabel.frame=CGRectMake(19, 44, 21, 145);
    loadLabel.text=content; //@"无数据";//@"   ";
    [loadingView addSubview:loadLabel];
    return loadingView;
    
}

-(void)shutButClicked:(UIButton *)set{
    
    
}



@end

//
//  ImScrollView.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-24.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImScrollView : UIView
{

}

@property (assign,nonatomic) UIScrollView *scrollView; //
@property (nonatomic,assign)double imageHigh; //图片高
@property (nonatomic,assign)double imageWide; //图片的宽
@property (nonatomic,copy)NSString *jsonUel; //图片列表的json地址;
@property (nonatomic,assign)int pageCount; //页数

@property (assign,nonatomic) UIPageControl *pageControl; //

//
-(id)initWth;
+(id)ImScrollViewWithFrame:(CGRect)frame jsonUrl:(NSString *)jsonUrl;

@end

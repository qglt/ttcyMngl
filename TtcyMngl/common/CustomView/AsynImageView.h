//
//  AsynImageView.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-22.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsynImageView : NSObject
{
    NSURLConnection *connection;
    NSMutableData *loadData;
}
//图片对应的缓存在沙河中的路径
@property (nonatomic, retain) NSString *fileName;

//指定默认未加载时，显示的默认图片
@property (nonatomic, retain) UIImage *placeholderImage;
//请求网络图片的URL
@property (nonatomic, retain) NSString *imageURL;
-(void)initWithUIImageView:(UIImageView *)uIImageView url:(NSString *)url;
@property (nonatomic, retain) UIImageView *imageView;


@end
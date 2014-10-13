//
//  AsynImageView.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-22.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "AsynImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AsynImageView

@synthesize imageURL = _imageURL;
@synthesize placeholderImage = _placeholderImage;

@synthesize fileName = _fileName;


-(void)initWithUIImageView:(UIImageView *)uIImageView url:(NSString *)url{


    _imageView=uIImageView;
    _imageURL=url;
    [self loadImage];

}

-(void)initWithUIImageView:(UIImageView *)uIImageView url:(NSString *)url placeholderImage:(UIImage *)placeholderImage{
    _imageView=uIImageView;
    _imageURL=url;
    _placeholderImage=placeholderImage;
    [self loadImage];
    
}




//重写imageURL的Setter方法
-(void)setImageURL:(NSString *)imageURL
{
    if(imageURL != _imageURL)
    {
        _imageView.image=[UIImage imageNamed:@"face.jpg"];
        if (_placeholderImage) {
            _imageView.image = _placeholderImage;    //指定默认图片
        }
        
   
        _imageURL = imageURL;
    }
    
    if(self.imageURL)
    {
        //确定图片的缓存地址
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        NSString *tmpPath=[docDir stringByAppendingPathComponent:@"AsynImage"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSArray *lineArray = [self.imageURL componentsSeparatedByString:@"/"];
        self.fileName = [NSString stringWithFormat:@"%@/%@", tmpPath, [lineArray objectAtIndex:[lineArray count] - 1]];
        
        //下载图片，保存到本地缓存中
            [self loadImage];
    }
}

//网络请求图片，缓存到本地沙河中
-(void)loadImage
{
    //设置默认图片
    _imageView.image=[UIImage imageNamed:@"face.jpg"];
    if (_placeholderImage) {
        _imageView.image = _placeholderImage;    //指定默认图片
    }
    
    //对路径进行编码
    @try {
        //请求图片的下载路径
        //定义一个缓存cache
        NSURLCache *urlCache = [NSURLCache sharedURLCache];
        /*设置缓存大小为1M*/
        [urlCache setMemoryCapacity:1*124*1024];
        
        //设子请求超时时间为30s
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.imageURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
        
        //从请求中获取缓存输出
        NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
        if(response != nil)
        {
            [request setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        }
        
        /*创建NSURLConnection*/
        if(!connection)
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        //开启一个runloop，使它始终处于运行状态
        
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
       
    }
    @catch (NSException *exception) {
        //        NSLog(@"没有相关资源或者网络异常");
    }
    @finally {
        ;//.....
    }
}

#pragma mark - NSURLConnection Delegate Methods
//请求成功，且接收数据(每接收一次调用一次函数)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(loadData==nil)
    {
        loadData=[[NSMutableData alloc]initWithCapacity:2048];
    }
    [loadData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
    //    NSLog(@"将缓存输出");
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    //    NSLog(@"即将发送请求");
    return request;
}
//下载完成，将文件保存到沙河里面
-(void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //图片已经成功下载到本地缓存，指定图片
//    if([loadData writeToFile:_fileName atomically:YES])
//    {
 
    _imageView.image =[UIImage imageWithData:loadData ];
    if(_imageView.image==nil){
    
        //设置默认图片
        _imageView.image=[UIImage imageNamed:@"face.jpg"];
        if (_placeholderImage) {
            _imageView.image = _placeholderImage;    //指定默认图片
        }
    }
    //}
    
    connection = nil;
    loadData = nil;
    
}
//网络连接错误或者请求成功但是加载数据异常
-(void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    
    //如果发生错误，则重新加载
    connection = nil;
    loadData = nil;
    [self loadImage];
}



@end
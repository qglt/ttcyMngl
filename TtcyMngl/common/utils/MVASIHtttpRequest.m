//
//  MVASIHtttpRequest.m
//  JZMarket
//
//  Created by Maple on 7/20/13.
//  Copyright (c) 2013 Apps123. All rights reserved.
//

#import "MVASIHtttpRequest.h"
#import "AppsAPIConstants.h"
#import <CJSONDeserializer.h>
#import "NSString+URLEncoding.h"
#import <CJSONSerializer.h>

@implementation MVASIHtttpRequest

- (id) init{
    
    self = [super init];
    if (self) {

    }
    return self;
}


//网络请求并对参数进行加密
- (void)requestForGetWithPramaStr:(NSString*)requestParamStr method:(NSString*)methodStr serverType:(int)serverType
{
    NSDictionary * paramDict = [self toValue:requestParamStr];
    
    NSString *server = nil;
    if (serverType==1) {
        server = ID_API_SERVER1;
        encodingNum=kCFStringEncodingUTF8;
    }else{

        server = ID_API_SERVER4;
        encodingNum=kCFStringEncodingUTF8;
    }
    
    NSString *requestStr = nil;
    
    requestStr = [NSString stringWithFormat:@"%@?Method=%@&phone=%@&pass=%@&lang=mo",server,methodStr,[paramDict objectForKey:@"phone"],[paramDict objectForKey:@"pass"]];
    
    LOG_GENERAL_INFO(@"request %@",requestStr);
    
    NSURL *URL = [NSURL URLWithString:requestStr];
    self.asiRequest = [[ASIHTTPRequest alloc] initWithURL:URL];
    _asiRequest.delegate = self;
}

- (void)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr serverType:(int)serverType{

    NSString *paramsJson = [self dictoryToJsonStr:requestParams];
    [self requestForGetWithPramaStr:paramsJson method:methodStr serverType:serverType];
    
    [self startRequest:nil];
}



- (void)requestForGetWithPramas:(NSDictionary*)requestParams method:(NSString*)methodStr loadString:(NSString *)loadString serverType:(int)serverType listener:(void (^)(NSDictionary *))listener{
    
    _listener = listener;
    NSString *paramsJson = [self dictoryToJsonStr:requestParams];
    [self requestForGetWithPramaStr:paramsJson method:methodStr serverType:serverType];
    
    [self startRequest:loadString];
}

- (id)toValue:(NSString *)json {
    return [[CJSONDeserializer deserializer] deserialize:[json dataUsingEncoding:NSUTF8StringEncoding] error:nil];
}

- (NSString*)dictoryToJsonStr:(NSDictionary*)jsonDic
{
    return [[NSString alloc]initWithData:[[CJSONSerializer serializer] serializeDictionary:jsonDic error:nil] encoding:NSUTF8StringEncoding];
}

//网络请求得到结果并进行解密
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    //解密接受到的数据
    NSString *responseString = [[request responseString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *newString = [responseString URLDecodedString:0x08000100];
    //非200的请求错误，200是成功
    if(request.responseStatusCode!=200){
        
        if(request.responseStatusCode==500)    //500 服务器的内部错误  返回html内容
            
            LOG_GENERAL_ERROR(@"%s 服务器出错!",__FUNCTION__);
        
        else if(request.responseStatusCode==404) //404 找不到
            
            LOG_GENERAL_ERROR(@"%s 找不到相关资源!",__FUNCTION__);

        //501 未实现
        //502 网关出错
        //405 不允许此方法
        //400 请求出错
        else    LOG_GENERAL_ERROR(@"%s 请求失败!",__FUNCTION__);
//
        [self stopRequest];
        return;
    }

    if(!responseString||[@"" isEqualToString:responseString]){
        LOG_GENERAL_ERROR(@"网络无返回 ！");
        NSDictionary * dict = @{@"LoginState":@"n",@"MSG": @"   "};
        _listener(dict);
        [self stopRequest];
        return;
    }
    
    NSDictionary *json= [[CJSONDeserializer deserializer] deserialize:[newString dataUsingEncoding:NSUTF8StringEncoding] error:nil];
    NSLog(@"[request responseString] ---->%@\n\nresponseString----->%@",[request responseString],responseString);
    NSLog(@"new string--> %@,json  %@",newString, json.description);
    
    [self stopRequest];
    
    _listener([[json objectForKey:@"dt"] objectForKey:@"data"][0]);
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
    NSDictionary *dict = @{@"LoginState":@"n",@"MSG": @"链接错误 "};
    
    _listener(dict);
    
    [self stopRequest];
}

- (void)startRequest:(NSString *)loadString{
    
    [_asiRequest startAsynchronous];
    if (!loadString) {
        loadString = @"loding";
    }
    if (![loadString isEqualToString:@""]) {
        LOG_NETWORK(4,@"%@",loadString);
    }

}
- (void)stopRequest{
    
//    [RUIProgressView dismiss];
    
}

- (void)clearRequest{
    if (_asiRequest) {
        [_asiRequest clearDelegatesAndCancel];
    }
}

@end

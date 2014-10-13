//
//  RequestJson.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-24.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestJson : NSObject
#pragma mark 获取josn数据集合 json对象的标识
-(id)getJosnNSArrayUrl:(NSString*)url sid:(NSString *)sid;
#pragma mark 判断连接地址网络是否可引用
-(BOOL) isConnectionAvailableWithUrl:(NSString*)url;

@end

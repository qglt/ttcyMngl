//
//  QueueItemId.h
//  TtcyMngl
//
//  Created by admin on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueItemId : NSObject
@property (readwrite) int count;
@property (readwrite) NSURL* url;

-(id) initWithUrl:(NSURL*)url andCount:(int)count;

@end

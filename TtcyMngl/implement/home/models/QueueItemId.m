//
//  QueueItemId.m
//  TtcyMngl
//
//  Created by admin on 14-6-13.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "QueueItemId.h"

@implementation QueueItemId

-(id) initWithUrl:(NSURL*)url andCount:(int)count
{
    if (self = [super init])
    {
        self.url = url;
        self.count = count;
    }
    
    return self;
}

-(BOOL) isEqual:(id)object
{
    if (object == nil)
    {
        return NO;
    }
    
    if ([object class] != [QueueItemId class])
    {
        return NO;
    }
    
    return [((QueueItemId*)object).url isEqual: self.url] && ((QueueItemId*)object).count == self.count;
}

-(NSString*) description
{
    return [self.url description];
}

@end

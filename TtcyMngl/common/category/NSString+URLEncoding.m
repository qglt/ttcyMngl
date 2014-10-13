//
//  NSString+URLEncoding.m
//  AShop
//
//  Created by FlipFlopStudio on 12-7-23.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[] "),
                                            kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

- (NSString*)URLDecodedString:(int)codingNum
{
    self = [self stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    self = (NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            codingNum);
    
    return [self autorelease];
}

- (NSDictionary*)PareseDic
{
    NSArray *contentArr = [self componentsSeparatedByString:@","];
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] init];
    for (NSString * content in contentArr) {
        NSArray *childArr = [content componentsSeparatedByString:@"="];
        NSString *key =[childArr objectAtIndex:0];
        NSString *value = [childArr objectAtIndex:1];
        [returnDic setObject:value forKey:key];
    }
    return [returnDic autorelease];
}
@end

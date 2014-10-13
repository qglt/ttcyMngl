//
//  NSString+URLEncoding.h
//  AShop
//
//  Created by FlipFlopStudio on 12-7-23.
//  Copyright (c) 2012年 easee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString:(int)codingNum;
- (NSDictionary*)PareseDic;
@end

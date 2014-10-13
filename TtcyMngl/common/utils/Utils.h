//
//  Utils.h
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-5.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(UIImage *)scaleAndRotateImage:(UIImage *)image scaleMaxResolution:(int) kMaxResolution;

+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim;

+ (UIColor *) colorWithHexString: (NSString *)color;

+ (void)setTableViewFullBackground:(NSString *)imageName inview:(UITableView *)table;

+ (BOOL)checkTel:(NSString *)tel;

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color;


+(UIImage *)getFullBackgroundImageView:(NSString *)imageName WithCapInsets:(UIEdgeInsets)capInsets hLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;


//number to 10:22
+(NSString *)formatTimeByNumber:(float)time;

//number transfer  B to (KB or GB)
+(NSString *)transferNumberToString:(double)number;



//file operator
+(NSString *) md5HexDigest :(NSString *)originString;

+(NSString *)applicationDocumentPath;//得到Document文件夹
+(BOOL)isExistFileAtPath:(NSString *)path;//是否存在指定文件
+(BOOL)removeFileAtPath:(NSString *)path;//删除path文件
+(double)getFileSizeAtPath:(NSString *)path;

+(BOOL)isEmptyString:(NSString *)string;

@end

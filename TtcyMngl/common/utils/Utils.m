//
//  Utils.m
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-5.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Utils

+(UIImage *)getFullBackgroundImageView:(NSString *)imageName WithCapInsets:(UIEdgeInsets)capInsets hLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
    UIImage *image;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] < 5.0) {
        image = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    }else {
        image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets];
    }
    return image;
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+(void)setTableViewFullBackground:(NSString *)imageName inview:(UITableView *)table
{
    table.backgroundView = [[UIView alloc] initWithFrame:table.bounds];
    table.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}
+(UIImage *)scaleAndRotateImage:(UIImage *)image scaleMaxResolution:(int) kMaxResolution
{
    //    int kMaxResolution = [UIScreen mainScreen].bounds.size.width; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
+(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    html = [html stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    
    // trim off whitespace
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}
+ (BOOL)checkTel:(NSString *)tel

{
    
    if ([tel length] == 0) {
        
        return NO;
        
    }
    
    //1[0-9]{10}
    
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    
    //    NSString *regex = @"[0-9]{11}";
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:tel];
    
    if (!isMatch) {
        
        
        return NO;
        
    }
    return YES;
    
}

/**
 * 将UIColor变换为UIImage
 *
 **/
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+(NSString *)formatTimeByNumber:(float)time
{
    NSString *result=@"00:00";
    if(time>=3600)//hour
    {
        int hour= time/3600;
        int minute=(time-hour*3600)/60;
        int second=time-hour*3600-minute*60;
        
        NSString *hourString=[NSString stringWithFormat:@"%d",hour];
        if(hour<10)
        {
            hourString=[NSString stringWithFormat:@"0%d",hour];
        }
        
        NSString *minString=[NSString stringWithFormat:@"%d",minute];
        if(minute<10)
        {
            minString=[NSString stringWithFormat:@"0%d",minute];
        }
        
        NSString *secondString=[NSString stringWithFormat:@"%d",second];
        if(second<10)
        {
            secondString=[NSString stringWithFormat:@"0%d",second];
        }
        
        result=[NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secondString];
    }
    else if(time<3600)
    {
        
        int minute=time/60;
        int second=time-minute*60;;
        NSString *minString=[NSString stringWithFormat:@"%d",minute];
        if(minute<10)
        {
            minString=[NSString stringWithFormat:@"0%d",minute];
        }
        
        NSString *secondString=[NSString stringWithFormat:@"%d",second];
        if(second<10)
        {
            secondString=[NSString stringWithFormat:@"0%d",second];
        }
        
        result=[NSString stringWithFormat:@"%@:%@",minString,secondString];
    }
    return result;
}

+(NSString *)transferNumberToString:(double)number
{
    NSString *result=@"";
    //    if(number==0)
    //    {
    ////        result=@"-";
    //        result=@"0";
    //    }
    //byte
    if(number<1024)
    {
        result=[NSString stringWithFormat:@"%0.1fB",number];
    }
    //kB
    else if(number<1024*1024)
    {
        result=[NSString stringWithFormat:@"%0.1fK",number/1024.0];
    }
    //MB
    else if(number<1024*1024*1024)
    {
        result=[NSString stringWithFormat:@"%0.1fM",number/1024.0/1024.0];
    }
    //GB
    else
    {
        result=[NSString stringWithFormat:@"%0.1fG",number/1024.0/1024.0/1024.0];
    }
    return result;
}

+(NSString *)applicationDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(double)getFileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    NSDictionary *ret=[fileManager attributesOfItemAtPath:path error:&error];
    if(error)
    {
        NSLog(@"getFileSizeAtPath===============%@",error);
    }
    return [[ret objectForKey:NSFileSize] doubleValue];
}

+(BOOL)isExistFileAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+(BOOL)removeFileAtPath:(NSString *)path
{
    NSError *error=nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path])
    {
        return NO;
    }
    BOOL result= [fileManager removeItemAtPath:path error:&error];
    if(error)
    {
        NSLog(@"移除文件失败：%@",error);
        result=NO;
    }
    return result;
}

+(NSString *)md5HexDigest:(NSString *)originString
{
    const char *str = [originString UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}
+(BOOL)isEmptyString:(id)string
{
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (string == nil) {
        return YES;
    }
    NSString *text = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length == 0) {
        return YES;
    }
    return NO;
}
@end

//
//  UIBarButtonItem+Addition.h

//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Addition)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action name:(NSString *)name;
@end

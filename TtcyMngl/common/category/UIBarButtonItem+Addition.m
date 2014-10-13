//
//  UIBarButtonItem+Addition.m

//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "UIBarButtonItem+Addition.h"

@implementation UIBarButtonItem (Addition)
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action name:(NSString *)name {
    UIButton *btn = [[UIButton alloc] init];
    if (target && action) {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    btn.bounds = (CGRect){CGPointZero, {35, 30}};
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
@end

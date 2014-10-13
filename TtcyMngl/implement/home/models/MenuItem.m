//
//  LeftItem.m
//  iNews
//

//
//

#import "MenuItem.h"

@interface MenuItem()
{
    UIViewController *_vc;
}
@end

@implementation MenuItem
+ (id)itemWithIcon:(NSString *)icon hightLightIcon:(NSString *)h_icon title:(NSString *)title vcClass:(NSString *)vcClass andTag:(NSUInteger)tag;
{
    MenuItem *item = [[MenuItem alloc] init];
    item.icon = icon;
    item.h_icon = h_icon;
    item.title = title;
    item.vcClass = vcClass;
    item.tag = tag;
    return item;
}
@end
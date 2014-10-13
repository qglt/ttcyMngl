//
//  LeftItem.h
//  iNews
//
//
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *h_icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *vcClass;
@property (nonatomic, assign) NSUInteger tag;

+ (id)itemWithIcon:(NSString *)icon hightLightIcon:(NSString *)h_icon title:(NSString *)title vcClass:(NSString *)vcClass andTag:(NSUInteger)tag;

@end
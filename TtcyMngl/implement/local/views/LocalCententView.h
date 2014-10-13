//
//  LocalCententView.h
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalMenuButon.h"

@interface LocalCententView : UIScrollView

@property (nonatomic, copy) void (^itemClick)(LocalMenuButon *item);

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles icons:(NSArray *)icons classes:(NSArray *)classes;

@end

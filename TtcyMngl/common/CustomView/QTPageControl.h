//
//  QTPageControl.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTPageControl : UIView

@property (nonatomic,strong)void(^pageItemClick)(NSInteger index);
@property (nonatomic,assign)NSInteger currentIndex;

-(id)initWithFrame:(CGRect)frame itemCount:(NSInteger)count;
- (void)setSelectedIndex:(NSInteger)index;

@end

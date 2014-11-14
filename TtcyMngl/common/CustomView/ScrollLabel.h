//
//  ScrollLabel.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-22.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    Center,
    Left,
    Right
}Alignment;

@interface ScrollLabel : UIView

@property (nonatomic,strong,setter=setFont:)UIFont * font;

@property (nonatomic,strong,setter=setText:)NSString * text;

@property (nonatomic,strong,setter=setTextColor:)UIColor * textColor;

@property (nonatomic,assign,setter=setTextAlignment:)Alignment textAlignment;

@end

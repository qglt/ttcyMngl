//
//  LocalMenuButon.h
//  TtcyMngl
//
//  Created by admin on 14-6-10.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocalMenuButon;

@protocol LocalMenuButonDelegate <NSObject>

-(void)menuItemPressed:(LocalMenuButon *)sender;

@end 

@interface LocalMenuButon : UIButton

@property (nonatomic,strong)NSString * vcClass;
@property (nonatomic,weak) __weak id <LocalMenuButonDelegate>delegate;

-(UIButton *)initWithTitle:(NSString *)title Icon:(NSString *)iconName Class:(NSString *)className item:(NSString *)itemName;

@end

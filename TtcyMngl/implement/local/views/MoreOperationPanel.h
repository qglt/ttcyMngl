//
//  MoreOperationPanel.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-30.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MoreOperationPanel : UIView

@property (nonatomic, copy) void (^itemClick)(MenuItem *item);

@property (nonatomic,strong)NSMutableArray * menuItems;

-(MoreOperationPanel *)initWithFrame:(CGRect)frame andItems:(NSArray *)itemsArray;

@end

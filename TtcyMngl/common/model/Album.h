//
//  Album.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-6-6.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
@interface Album :Model
@property(nonatomic,assign) NSInteger number; //专辑编号
@property(nonatomic,assign) NSInteger moID;//蒙文专辑编号
@property(nonatomic,copy) NSString *photoURL; //图片地址
@property(nonatomic,copy) NSString *name; //专辑名称
@property(nonatomic,assign) NSInteger albumCategoryId; //专辑分类编号
@end

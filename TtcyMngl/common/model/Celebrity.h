//
//  Celebrity.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-14.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#pragma mark 歌手模型
@interface Celebrity : Model
@property(nonatomic,assign) NSInteger number;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *sinforMation;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *photoURL;

@end

//
//  MusicCell.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-9.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Celebrity.h"

@interface CelebrityCell : UITableViewCell

-(id)initWith;
+(id)newCell;
+(NSString *)ID;
-(void)setLoadTitle:(NSString*)title;
-(void)celebrityWithModel:(Celebrity *)model;
@property (weak, nonatomic) UILabel *lblName;

@end

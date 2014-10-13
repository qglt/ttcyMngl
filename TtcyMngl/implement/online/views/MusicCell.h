//
//  MusicCell.h
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-9.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongObject.h"
#import "Album.h"

@interface MusicCell : UITableViewCell{


}

-(id)initWith;
+(id)newCell;
+(NSString *)ID;
-(void)setLoadTitle:(NSString*)title;
-(void)celebrityWithModel:(SongObject *)model;

-(void)albumWithModel:(Album *)model;

@property (weak, nonatomic) UILabel *lblName;
//带歌手图片的歌曲cell
-(void)setMusicWithModel:(SongObject *)model;

@end

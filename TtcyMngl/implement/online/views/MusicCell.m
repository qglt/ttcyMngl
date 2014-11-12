//
//  MusicCell.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-9.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "MusicCell.h"
#import "AsynImageView.h"
#import "CommonClass.h"
#import <UIImageView+WebCache.h>
#define CellH kMainScreenHeight

@implementation MusicCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(NSString *)ID{

    return @"MusicCellCell";

}
-(id)initWith{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}
+(id)newCell{
    getPlayBarHeight();
    MusicCell *selfCell= [[MusicCell alloc]initWithFrame:CGRectMake(0, 0, 60, CellH)];
    selfCell.transform = CGAffineTransformMakeRotation(M_PI);
    
    UILabel *uiLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CellH,.4f )];
    uiLabel.backgroundColor=[UIColor colorWithWhite:.7f alpha:1.f];
    [selfCell addSubview:uiLabel];
    
    selfCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(6, 13, CellH, 36)];
    
    lblName.font=[CommonClass setTransformuiFont:lblName.font];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [selfCell setLblName:lblName];
   
    [selfCell setBackgroundColor:[UIColor clearColor]];
    [selfCell addSubview:lblName];
    
    return selfCell;
}

-(void)celebrityWithModel:(SongObject *)model{
    
    _lblName.text=model.songName;
  
}
-(void)albumWithModel:(Album *)model{

    model.name = [model.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _lblName.text=model.name;
}
-(void)setMusicWithModel:(SongObject *)model{
    
    if (model.avatarImageUrl!=nil) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 50, 50)];
        image.tag=1001;
        image.layer.cornerRadius = 25.f;
        image.layer.masksToBounds = YES;
        
        [image sd_setImageWithURL:[NSURL URLWithString:model.avatarImageUrl] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
        image.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self addSubview:image];
    }
    model.songName = [model.songName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _lblName.frame=CGRectMake(85, 13, 267, 36);
    _lblName.text=model.songName;
}

-(void)setLoadTitle:(NSString*)title{
    _lblName.frame=CGRectMake(60, 13, 267, 36);
    _lblName.text=title;
   

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

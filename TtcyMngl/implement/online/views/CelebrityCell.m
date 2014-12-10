//
//  MusicCell.m
//  MyMusicPlayer
//
//  Created by 牛利江 on 14-5-9.
//  Copyright (c) 2014年 ttcy. All rights reserved.
//

#import "CelebrityCell.h"
#import "AsynImageView.h"
#import <UIImageView+WebCache.h>
#import "CommonClass.h"
//#define CellH
@implementation CelebrityCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(NSString *)ID{
    return @"celebrityCell";
}
-(id)initWith{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}
+(id)newCell{
   
    CelebrityCell *selfCell= [[CelebrityCell alloc]initWithFrame:CGRectMake(0, 0, 60, kMainScreenHeight)];
    selfCell.transform = CGAffineTransformMakeRotation(M_PI);
    UILabel *uiLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight,0.4 )];
    uiLabel.backgroundColor=[UIColor colorWithWhite:.7f alpha:1.f];
    [selfCell addSubview:uiLabel];
    selfCell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *lblName=[[UILabel alloc]init];
    lblName.font=[CommonClass setTransformuiFont:lblName.font];
    lblName.frame=CGRectMake(85, 13, kMainScreenHeight, 36);
    [lblName setBackgroundColor:[UIColor clearColor]];
    [selfCell setLblName:lblName];
    [selfCell setBackgroundColor:[UIColor clearColor]];
    [selfCell addSubview:lblName];
    return selfCell;
}

-(void)celebrityWithModel:(Celebrity *)model{
    if (model.photoURL!=nil) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 6, 50, 50)];
        image.tag=1001;
        image.layer.cornerRadius = 25.f;
        image.layer.masksToBounds = YES;
        [image setImageWithURL:[NSURL URLWithString:model.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
        
        image.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self addSubview:image];
    }
    model.name = [model.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _lblName.text=model.name;
    _lblName.font=[self setTransformuiFont:_lblName.font];
}

-(void)setLoadTitle:(NSString*)title{
    _lblName.text=title;
    _lblName.font=[self setTransformuiFont:_lblName.font];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    
}
-(id) setTransformuiFont:(UIFont *)uiFont{
    uiFont = [UIFont fontWithName:@"Menksoft Qagan" size:20];
    return uiFont;
    
}

@end

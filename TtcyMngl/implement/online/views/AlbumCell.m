//
//  AlbumCell.m
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "AlbumCell.h"
#import "CommonClass.h"
#import "AsynImageView.h"
#import <UIImageView+WebCache.h>
#define CellH kMainScreenHeight

@implementation AlbumCell

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
    AlbumCell *selfCell= [[AlbumCell alloc]initWithFrame:CGRectMake(0, 0, 60, CellH)];
    UILabel *uiLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CellH,0.4 )];
    uiLabel.backgroundColor=[UIColor whiteColor];
    [selfCell addSubview:uiLabel];
     [selfCell setBackgroundColor:[UIColor clearColor]];
    selfCell.transform = CGAffineTransformMakeRotation(M_PI);

    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(85, 13, CellH, 36)];
    lblName.font=[CommonClass setTransformuiFont:lblName.font];
    [lblName setBackgroundColor:[UIColor clearColor]];
    [selfCell setLblName:lblName];
    [selfCell addSubview:lblName];
     selfCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return selfCell;
}



-(void)AlbumWithModel:(Album *)model{
    if (model.photoURL!=nil) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(6, 6, 50, 50)];
        [image setImageWithURL:[NSURL URLWithString:model.photoURL] placeholderImage:[UIImage imageNamed:@"face.jpg"]];
        
        image.transform = CGAffineTransformMakeRotation(-M_PI_2);
        [self addSubview:image];
    }
    _lblName.text=model.name;
    [self addSubview:_lblName];
}

-(void)setLoadTitle:(NSString*)title{
    _lblName.frame=CGRectMake(60, 13, 267, 36);
    _lblName.text=title;
    
}



@end

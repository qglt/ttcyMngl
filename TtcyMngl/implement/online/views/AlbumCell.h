//
//  AlbumCell.h
//  TtcyMngl
//
//  Created by 牛利江 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface AlbumCell : UITableViewCell{}

-(id)initWith;
+(id)newCell;
+(NSString *)ID;
-(void)setLoadTitle:(NSString*)title;
-(void)AlbumWithModel:(Album *)model;
@property (weak, nonatomic) UILabel *lblName;

@end

//
//  MnglSongCell.h
//  TTCYMnglLibrary
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MnglSongCell : UITableViewCell

@property(nonatomic,strong)UIColor *fontColor;
@property(nonatomic)CGFloat fontSize;

-(void)setUpCellWithText:(NSString *)text;

@end

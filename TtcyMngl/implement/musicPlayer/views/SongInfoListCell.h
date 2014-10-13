//
//  SongInfoListCell.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-24.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongObject;

@protocol SongInfoListCellDelegate <NSObject>

- (void)collectButtonPressedWithCell:(id)cell;
- (void)morebuttonClickedWithCell:(id)cell;

@end

@interface SongInfoListCell : UITableViewCell

@property (nonatomic,strong)UIColor * fontColor;

@property (nonatomic,weak)__weak id<SongInfoListCellDelegate>delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  andRowheight:(NSInteger)rowHeight;

-(void)setUpCellWithSOngObject:(SongObject *)song collected:(BOOL)collected;

@end

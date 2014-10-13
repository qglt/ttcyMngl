//
//  DownLoadInfoCell.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-7-11.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "DownLoadInfoCell.h"
#import "DownloadItem.h"
#import <objc/runtime.h>

@implementation DownLoadInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setBaseCondition];
        [self createNameLabel];
        [self createProgressLabel];
        [self createProgress];
        [self createPauseButton];
        [self createCancelButton];
        [self createSeparatorLine];
        
    }
    return self;
}
- (void)setBaseCondition
{
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UILabel class]]|[obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMakeRotation(M_PI);

}
- (void)createNameLabel
{
    self.nameLabel = [[UILabel alloc]init];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_nameLabel];
}
- (void)createProgressLabel
{
    self.progressLabel = [[UILabel alloc]init];
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:18];
    [_progressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:_progressLabel];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_progressLabel(60)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_nameLabel]-5-[_progressLabel(==20)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel,_progressLabel)]];
}
- (void)createProgress
{
    self.progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progress.transform = CGAffineTransformMakeRotation(M_PI);
    
    [_progress setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:_progress];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_progressLabel]-5-[_progress]-65-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressLabel,_progress)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_nameLabel]-5-[_progress(10)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel,_progress)]];
}
- (void)createPauseButton
{
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pauseButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    _pauseButton.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
    _pauseButton.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:15];
    
    _pauseButton.layer.cornerRadius =8.0;
    _pauseButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_pauseButton];
    
    [_pauseButton addTarget:self action:@selector(pauseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_nameLabel]-5-[_pauseButton(==60)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel,_pauseButton)]];
}
- (void)createCancelButton
{
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    _cancelButton.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:16];
    _cancelButton.layer.cornerRadius = 8.0;
    _cancelButton.layer.masksToBounds = YES;
    [self.contentView addSubview:_cancelButton];
    
    [_cancelButton addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_nameLabel]-5-[_cancelButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel,_cancelButton)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_pauseButton(25)]-5-[_cancelButton(25)]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pauseButton,_cancelButton)]];
}
-(void)createSeparatorLine
{
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenHeight, .3f)];
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:.5f];
    [self addSubview:line];
    [self bringSubviewToFront:line];
}
- (void)cancelBtnAction:(id)sender {
    
    self.DownSongCellCancelClick(self);
}

- (void)pauseBtnAction:(id)sender {
    
    self.DownSongCellOperateClick(self);
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        DownloadItem * downItem = objc_getAssociatedObject(self, @"obj_down_Item");
        NSLog(@"%@",downItem);
        self.DownSongCellBodyClick(downItem);
    }
    
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if(highlighted){
        self.backgroundColor = [Utils colorWithHexString:@"66cc97"];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}
@end

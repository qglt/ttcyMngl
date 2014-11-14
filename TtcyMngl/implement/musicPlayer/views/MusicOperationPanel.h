//
//  MusicOperationPanel.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-17.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicOperationPanelDelegate <NSObject>

- (void)operationPanelCollectButtonPressed;
- (void)operationPanelSahareButtonPressed;
- (void)operationPanelPlayModeButtonPressed;
- (void)operationPanelHiddeButtonPressed;
- (void)operationPanelDownloadButtonPressed;
- (void)operationPanelSliderValueChanged:(float)value;

@end

@interface MusicOperationPanel : UIView

@property (nonatomic,weak)__weak id<MusicOperationPanelDelegate>delegate;

- (void)setPlayModeState:(int)modeState;
- (void)setCollectButtonImage:(NSString *)imageName;
- (void)setPlayState:(int)playState;
-(void)refreshSliderWithProgress:(NSInteger)progress duration:(NSInteger)duration;

@end

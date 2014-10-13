//
//  UserInfoView.h
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountInfo.h"

@protocol UserInfoViewDelegate <NSObject>

@optional
- (void) login:(NSString*) user pwd:(NSString*) pwd savepwd:(BOOL) save;
- (void) regist:(NSString*) userName pwd:(NSString*) pwd;
- (void) userOffLine;
- (void) deleteAccount:(NSString*) user;

@end

@interface UserInfoView : UIScrollView

@property (nonatomic, weak) id<UserInfoViewDelegate> m_delegate;

- (void)setLoginStatus:(BOOL)status withCurrntAccount:(AccountInfo *)acc;
- (void)resignFirstResponder;
- (void)resetConstrains;

@end

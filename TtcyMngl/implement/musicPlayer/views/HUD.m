//
//  HUD.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-6-18.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "HUD.h"


@interface HUD ()
{
    BOOL createMenu;
    BOOL createPromt;
}
@property (nonatomic,strong)UILabel * messageLabel;

@property (nonatomic,strong,setter = setIndicator:)UIActivityIndicatorView * indicator;

@property (nonatomic,strong,setter = setPromt:)UIView * promt;

@end

@implementation HUD

- (id)initWithFrame:(CGRect)frame showMenu:(BOOL)show andPromt:(BOOL)showPromt
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        createMenu = show;
        createPromt = showPromt;
        
        [self setBaseCondition];
        [self createMessageLabel];
        if (show) {
            [self createMenuButton];
        }else{
            [self createShutButton];
        }
    }
    return self;
}
#pragma mark - init methods
-(void)setBaseCondition
{
    [self setBackgroundColor:[UIColor colorWithWhite:1.f alpha:1.f]];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [Utils colorWithHexString:@"#1B98DA"].CGColor;
    self.layer.borderWidth = 2;
}
-(void)createShutButton
{
    UIButton * shut = [self createButtonWithTitle:@"" tag:20000];
    shut.frame = CGRectMake(self.bounds.size.width-35, 0, 35, self.bounds.size.height);
    [shut removeTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [shut addTarget:self action:@selector(shutButClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shut];
}
-(void)shutButClicked
{
    [self removeFromSuperview];
}
-(void)createMessageLabel
{
    self.messageLabel=[[UILabel alloc]init];
    _messageLabel.font=[UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.textColor = [Utils colorWithHexString:@"1B98DA"];
    [_messageLabel setBackgroundColor:[UIColor clearColor]];
    _messageLabel.numberOfLines = 0;
    _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self addSubview:_messageLabel];
    
    CGFloat top = 30;
    
    if (createPromt) {
        top += 30;
    }
    _messageLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - top);
    _messageLabel.center = CGPointMake((self.bounds.size.width-35)/2.f, self.bounds.size.height/2.f);
}
-(void)createMenuButton
{
    UIButton * cancel = [self createButtonWithTitle:@"" tag:0];
    cancel.frame = CGRectMake(self.bounds.size.width-35, self.bounds.size.height/2.f, 35, self.bounds.size.height/2.f);
    [self addSubview:cancel];
    
    UIButton * other = [self createButtonWithTitle:@"" tag:1];
    other.frame = CGRectMake(self.bounds.size.width-35, 0, 35, self.bounds.size.height/2.f);
    [self addSubview:other];
}
- (UIButton *)createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton * button = [[UIButton alloc]init];
    [button setBackgroundImage:[Utils createImageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[Utils createImageWithColor:[Utils colorWithHexString:@"#1B98DA"]] forState:UIControlStateSelected];
    [button setBackgroundImage:[Utils createImageWithColor:[Utils colorWithHexString:@"#1B98DA"]] forState:UIControlStateHighlighted];
    
    button.titleLabel.font=[UIFont fontWithName:@"Menksoft Qagan" size:20.0];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[Utils colorWithHexString:@"1B98DA"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.transform = CGAffineTransformMakeRotation(M_PI_2);
    button.layer.borderColor = [Utils colorWithHexString:@"#1B98DA"].CGColor;
    button.layer.borderWidth = 1;
    button.tag = tag;
    [button addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)menuButtonAction:(UIButton *)sender
{
    [self.delegate hud:self clickedButtonAtIndex:sender.tag];
}
-(void)setPromt:(UIView *)promt
{
    [_promt removeFromSuperview];
    _promt = promt;
    _promt.frame = CGRectMake(0, 0, 20, 20);
    _promt.center = CGPointMake((self.bounds.size.width-35)/2.f, 15);
    [self addSubview:_promt];
}

#pragma mark - call methods

+(void)messageForBuffering
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [@"   " sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:20.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 100, size.height+20) showMenu:NO andPromt:YES];
    loadingView.center = view.center;
    loadingView.messageLabel.text = @"   ";
    
    UIActivityIndicatorView  *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.color = [Utils colorWithHexString:@"#1B98DA"];
    _activityIndicatorView.hidesWhenStopped = YES;
    [_activityIndicatorView startAnimating];
    loadingView.promt = _activityIndicatorView;
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    
}
+(void)messageForComplect
{
    
}
+(void)messageForFailler
{
    [HUD clearHudFromApplication];
}

+(void)message:(NSString *)message
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:18.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 100, size.height+20) showMenu:NO andPromt:NO];
    loadingView.center = view.center;
    loadingView.messageLabel.text = message;
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    
    [UIView animateWithDuration:2.f animations:^{
        loadingView.alpha = 0;
    }];
    [[UIApplication sharedApplication].keyWindow.rootViewController performSelector:@selector(clearHudFromApplication) withObject:nil afterDelay:2.f];
}
+(void)message:(NSString *)message promtView:(UIView *)promt
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:18.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 100, size.height) showMenu:NO andPromt:YES];
    loadingView.center = view.center;
    loadingView.messageLabel.text = message;
    
    loadingView.promt = promt;
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    
     [[UIApplication sharedApplication].keyWindow.rootViewController performSelector:@selector(clearHudFromApplication) withObject:nil afterDelay:.3f];
}
+(void)clearHudFromApplication
{
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[HUD class]]) {
            [obj removeFromSuperview];
            break;
        }
    }
}
+(void)message:(NSString *)message delegate:(id <HUDDelgate>)delegate Tag:(NSInteger)tag
{
    [HUD clearHudFromApplication];
    
    UIView * view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    
    CGSize size = [message sizeWithFont:[UIFont fontWithName:@"Menksoft Qagan" size:18.0] constrainedToSize:CGSizeMake(20, kMainScreenWidth)];
    
    HUD *loadingView=[[HUD alloc]initWithFrame:CGRectMake(0, 0, 100, size.height+20) showMenu:YES andPromt:NO];
    loadingView.center = view.center;
    loadingView.messageLabel.text = message;
    loadingView.delegate = delegate;
    loadingView.tag = tag;
    [loadingView createMenuButton];
    
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    
   
}
@end

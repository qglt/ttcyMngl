//
//  LocalMainViewController.m
//  TtcyMngl
//
//  Created by admin on 14-6-9.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "LocalMainViewController.h"
#import "LocalCententView.h"
#import "DownloadListViewController.h"
#import "AccountManager.h"
#import "HUD.h"
#import "UserInfoView.h"
#import "SettingPanel.h"
#import "UserShareSDK.h"
#import "AppDataManager.h"
#import "AboutViewController.h"

@interface LocalMainViewController ()<AccountManagerDelegate,UserInfoViewDelegate>
{
    NSString * _userID;
    NSString * _pass;
    BOOL _settingViewIsShow;
}
@property (nonatomic,strong)UserInfoView * userInfoView;

@property (nonatomic,strong)LocalCententView * contentView;

@property (nonatomic,strong)SettingPanel * settingPanel;

@end

@implementation LocalMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (is4Inch) {
        self.view.backgroundColor = CENT_COLOR_4INCH;
    }else{
        self.view.backgroundColor = CENT_COLOR;
    }
    _settingViewIsShow = NO;
    [self settingViewShow:_settingViewIsShow];
    [self createInfoBG];
    [self createUserInfoView];
    [self createDetailView];
    [self createSettingButton];
    [self createSettingPanel];
    [self addTapGestrue];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUserInfoView];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.userInfoView resetConstrains];
}
#pragma mark - initlize -------------------
- (void)createInfoBG
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 160)];
    view.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
    [self.view addSubview:view];
}
- (void)createUserInfoView
{
    self.userInfoView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 160)];
    _userInfoView.m_delegate = self;
    [self.view addSubview:_userInfoView];
    [self refreshUserInfoView];
}
-(void)createDetailView
{
    NSArray * titleArray = @[@" ",@" ",@" "];
    NSArray * iconArray = @[@"item_tag",@"item_tag",@"item_tag"];
    NSArray * classArray = @[@"CollectListViewController",@"DownloadListViewController",@"PlayRecordViewController"];
    
    self.contentView = [[LocalCententView alloc]initWithFrame:CGRectMake(0, 160, kMainScreenWidth, kMainScreenHeight-160)
                                                       titles:titleArray
                                                        icons:iconArray
                                                      classes:classArray];
    [self.view addSubview:_contentView];
    LOG_UI_INFO(@"Local cententView:%@",_contentView);
    
    __unsafe_unretained LocalMainViewController * main = self;
    
    _contentView.itemClick = ^(LocalMenuButon *item) {
        
        if ([@"CollectListViewController" isEqualToString:item.vcClass]) {
            AccountManager *accountManger = [AccountManager shareInstance];
            if (accountManger.status == offLine) {
                [HUD message:@" "];
            }
            else {
                Class c = NSClassFromString(item.vcClass);
                UIViewController *vc = [[c alloc] init];
                [main.navigationController pushViewController:vc animated:YES];
            }
        }else if ([@"DownloadListViewController" isEqualToString:item.vcClass]){
            UIViewController *vc = [DownloadListViewController shareInstance];
            [main.navigationController pushViewController:vc animated:YES];
        }
        else{
            Class c = NSClassFromString(item.vcClass);
            UIViewController *vc = [[c alloc] init];
            [main.navigationController pushViewController:vc animated:YES];
        }
    };
}
- (void)createSettingButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 24);
    [button setBackgroundImage:[UIImage imageNamed:@"menu_setting"] forState:UIControlStateNormal];
    button.center = CGPointMake(kMainScreenWidth-25, 35);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)createSettingPanel
{
    MenuItem * item1 = [MenuItem itemWithIcon:@"share_setting" hightLightIcon:@"" title:@"" vcClass:@"share" andTag:0];
    MenuItem * item2 = [MenuItem itemWithIcon:@"check_update" hightLightIcon:@"" title:@"" vcClass:@"check" andTag:1];
    MenuItem * item3 = [MenuItem itemWithIcon:@"delete" hightLightIcon:@"" title:@"" vcClass:@"cache" andTag:2];
    MenuItem * item4 = [MenuItem itemWithIcon:@"about" hightLightIcon:@"" title:@"  " vcClass:@"AboutViewController" andTag:3];
    
    self.settingPanel = [[SettingPanel alloc]initWithFrame:CGRectMake(0, -160, kMainScreenWidth-40, 160) andItems:@[item1,item2,item3,item4]];
    _settingPanel.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
    __unsafe_unretained LocalMainViewController * main = self;
    _settingPanel.itemClick = ^(MenuItem * item){
        switch (item.tag) {
            case 0:
            {
                [[AppDataManager shareInstance] shareApp];
            }break;
            case 1:
            {
                [[AppDataManager shareInstance] checkUpdate];
            }break;
            case 2:
            {
                [[AppDataManager shareInstance] clearCache];
            }break;
            case 3:
            {
                AboutViewController * aboutVC = [[AboutViewController alloc]init];
                
                [UIView  beginAnimations:nil context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.75];
                [main.navigationController pushViewController:aboutVC animated:NO];
                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:main.navigationController.view cache:NO];
                [UIView commitAnimations];
            }break;
                
            default:
                break;
        }
    };
    _settingPanel.alpha = 0;
    [self.view addSubview:_settingPanel];
}
- (void)addTapGestrue
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)]];
}
- (void)viewTaped:(UITapGestureRecognizer *)gestrue
{
    [self.userInfoView resignFirstResponder];
}
- (void)refreshUserInfoView
{
    AccountManager *accountManger = [AccountManager shareInstance];
    if (accountManger.status == onLine) {
        [_userInfoView setLoginStatus:YES withCurrntAccount:[[AccountManager shareInstance] currentAccount]];
    }else{
        [_userInfoView setLoginStatus:NO withCurrntAccount:[[AccountManager shareInstance] currentAccount]];
    }
}
- (void)buttonAction:(UIButton *)sender
{
    _settingViewIsShow = !_settingViewIsShow;
    [self settingViewShow:_settingViewIsShow];
}
- (void)settingViewShow:(BOOL)show
{
    CGRect frame_u = _userInfoView.frame;
    CGRect frame_s = _settingPanel.frame;
    CGFloat alpha = 0;
    if (show) {
        alpha = 0;
        frame_s.origin.y = 0;
        frame_u.origin.y = -160;
        [_userInfoView resetConstrains];
    }else{
        alpha = 1;
        frame_s.origin.y = -160;
        frame_u.origin.y = 0;
        [self refreshUserInfoView];
    }
    [UIView animateWithDuration:.5f animations:^{
        _userInfoView.alpha = alpha;
        _settingPanel.alpha = 1-alpha;
        _userInfoView.frame = frame_u;
        _settingPanel.frame = frame_s;
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UserInfoViewDelegate methods -------------------------
#pragma mark - -- login ------------------------
-(void)login:(NSString *)user pwd:(NSString *)pwd savepwd:(BOOL)save
{
    [HUD messageForBuffering];
    
    [[AccountManager shareInstance] addListener:self];
    [[AccountManager shareInstance] login:user withPwd:pwd SavePWD:save];
}
- (void)loginSucess
{
    [HUD clearHudFromApplication];
    [self refreshUserInfoView];
    __unsafe_unretained AccountManager * acManager = [AccountManager shareInstance];
    [acManager addAccount:acManager.currentAccount callback:^(BOOL OK) {
        if (OK) {
            [acManager fetchAccountHistory:^(NSArray *list) {
                if (list.count>0) {
                    acManager.historyAccounts = [NSMutableArray arrayWithArray:list];
                }
            }];
        }
    }];
}
- (void)loginFailure:(NSDictionary*) data
{
    [HUD message:[data objectForKey:@"MSG"]];
    
}
#pragma mark - -- regist ------------------------
- (void)regist:(NSString *)userName pwd:(NSString *)pwd
{
    [HUD messageForBuffering];
    
    [[AccountManager shareInstance] addListener:self];
    [[AccountManager shareInstance] regist:userName withPwd:pwd];
    _userID = userName;
    _pass = pwd;
}
-(void)registSucess
{
    [HUD message:@"         "];
    [self performSelector:@selector(login) withObject:nil afterDelay:1.5f];
}
- (void)login
{
    [self login:_userID pwd:_pass savepwd:NO];
}
- (void)registFailure:(NSDictionary *)data
{
    [HUD message:[data objectForKey:@"MSG"]];
}
#pragma mark - -------------------------------
-(void)userOffLine
{
    [[AccountManager shareInstance] setAccountStatus:offLine];
}
@end
















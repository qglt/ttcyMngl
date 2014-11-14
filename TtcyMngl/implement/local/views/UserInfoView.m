//
//  UserInfoView.m
//  TtcyMngl
//
//  Created by 青格勒图 on 14-9-25.
//  Copyright (c) 2014年 hqglt. All rights reserved.
//

#import "UserInfoView.h"
#import "HUD.h"
#import <UIImageView+WebCache.h>

#define TAG_HEAD   100
#define TAG_REGIST 101
#define TAG_LOGIN  102
#define TAG_BACK   103
#define TAG_SAVEPASS 104
#define TAG_POPACCOUNT  105

typedef enum{
    none,
    login,
    regist
}OprationType;

@interface UserInfoView ()<UITextFieldDelegate>

@property (nonatomic,assign,setter=setOperationType:)OprationType operationType;

@property (nonatomic,strong,setter=setCurrentAccount:)AccountInfo * currentAccount;

@property (nonatomic,assign,setter=setSavePass:)BOOL savePass;

@property (nonatomic,strong)UIButton * headImage;

@property (nonatomic,strong)UIButton * loginButton;

@property (nonatomic,strong)UIButton * registButton;

@property (nonatomic,strong)UIButton * backButton;

@property (nonatomic,strong)UIButton * popAccountButton;

@property (nonatomic,strong)UITextField * userIDField;

@property (nonatomic,strong)UITextField * passField;

@property (nonatomic,strong)UITextField * conPassField;

@property (nonatomic,strong)UILabel * namePromt;

@property (nonatomic,strong)UILabel * passPromt;

@property (nonatomic,strong)UILabel * checkPass;

@property (nonatomic,strong)UILabel * accNameLabel;

@property (nonatomic,strong)UIButton * savePassImage;

@end

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBaseCondition];
        [self createHeadImage];
        [self createLoginButton];
        [self createRegisterButton];
        
        [self createBackButton];
        
        [self createLoginExreaView];
        [self createRegistExtraView];
        
        [self createAccountNameLabel];
        [self createPopAccontButton];
    }
    return self;
}
- (void)setBaseCondition
{
    self.backgroundColor = [Utils colorWithHexString:@"#1B98DA"];
}
#pragma mark - buttons ------------------------------
- (void)createHeadImage
{
    self.headImage = [self createButtonWithTitle:@"" image:@"main_logo" tag:TAG_HEAD];
    _headImage.frame = CGRectMake(0, 0, 80, 80);
    _headImage.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    _headImage.layer.cornerRadius = _headImage.frame.size.width/2.0f;
    _headImage.layer.masksToBounds = YES;
    [self addSubview:_headImage];
}
- (void)createLoginButton
{
    self.loginButton = [self createButtonWithTitle:@" " image:@"" tag:TAG_LOGIN];
    _loginButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    _loginButton.frame = CGRectMake(0, 0, 100, 100);
    _loginButton.center = CGPointMake(self.bounds.size.width*4/5.f, self.bounds.size.height/2.0f);
}
- (void)createRegisterButton
{
    self.registButton = [self createButtonWithTitle:@" " image:@"" tag:TAG_REGIST];
    _registButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    _registButton.frame = CGRectMake(0, 0, 100, 100);
    _registButton.center = CGPointMake(self.bounds.size.width*1/5.f, self.bounds.size.height/2.0f);
}
- (void)createBackButton
{
    self.backButton = [self createButtonWithTitle:@"" image:@"nav_back_userInfo" tag:TAG_BACK];
    _backButton.frame = CGRectMake(5, 20, 39, 40);
}
- (void)createSavePassButton
{
    self.savePassImage = [self createButtonWithTitle:@"" image:@"pass_unsave" tag:TAG_SAVEPASS];
    _savePassImage.frame = CGRectMake(0, 0, 30, 30);
    _savePassImage.center = CGPointMake(300, self.bounds.size.height-25);
}
- (void)createPopAccontButton
{
    self.popAccountButton = [self createButtonWithTitle:@"" image:@"" tag:TAG_POPACCOUNT];
    _popAccountButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    _popAccountButton.frame = CGRectMake(0, 0, 100, 100);
    _popAccountButton.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
}
#pragma mark - labels --------------------------
- (void)createNamePromtLabel
{
    self.namePromt = [self createLabelWithTitle:@"\n"];
}
- (void)createPassPromtLabel
{
    self.passPromt = [self createLabelWithTitle:@"\n"];
}
- (void)createCheckPassLabel
{
    self.checkPass = [self createLabelWithTitle:@"\n"];
}
- (void)createAccountNameLabel
{
    self.accNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 155, 20)];
    _accNameLabel.backgroundColor = [UIColor clearColor];
    _accNameLabel.textAlignment = NSTextAlignmentCenter;
    _accNameLabel.textColor = [UIColor whiteColor];
    _accNameLabel.font = [UIFont systemFontOfSize:18.f];
    _accNameLabel.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
}
#pragma mark - Fields --------------------------
- (void)createUserInputField
{
    self.userIDField = [self createFieldWithHolder:@"13012345678" keyType:UIKeyboardTypeNumberPad returnType:UIReturnKeyNext isPass:NO];
}
- (void)createPassInputField
{
    self.passField = [self createFieldWithHolder:@"" keyType:UIKeyboardTypeDefault returnType:UIReturnKeyNext isPass:YES];
}
- (void)createConPassInputField
{
    self.conPassField = [self createFieldWithHolder:@"" keyType:UIKeyboardTypeDefault returnType:UIReturnKeyDone isPass:YES];
}
#pragma mark - 辅助方法 --------------------------
- (UIButton *)createButtonWithTitle:(NSString *)title image:(NSString *)imageName tag:(NSInteger)tag
{
    UIButton * button = [[UIButton alloc]init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.tag = tag;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
- (UILabel *)createLabelWithTitle:(NSString *)title
{
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Menksoft Qagan" size:15.0f];
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    label.text = title;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    label.frame = CGRectMake(0, 0, 40, 40);
    label.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
    label.alpha = 0;
    
    return label;
}
- (UITextField *)createFieldWithHolder:(NSString *)holder keyType:(UIKeyboardType)kayType returnType:(UIReturnKeyType)returnType isPass:(BOOL)isPass
{
    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 155, 30)];
    field.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.textAlignment = NSTextAlignmentCenter;
    field.secureTextEntry = isPass;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [field setTextColor:[UIColor colorWithRed:38/255.0f green:38/255.0 blue:38/255.0 alpha:1]];
    field.backgroundColor = [UIColor whiteColor];
    field.delegate = self;
    field.returnKeyType = returnType;
    field.enablesReturnKeyAutomatically = YES;
    field.keyboardType = kayType;
    field.placeholder = holder;
    field.alpha = 0;
    return field;
}
#pragma mark - 扩展方法 －－－－－－－－－－－－－－
- (void)show:(BOOL)show objects:(NSArray *)objs
{
    if (show) {
        for (id obj in objs) {
            [self addSubview:obj];
        }
    }else{
        for (id obj in objs) {
            [obj removeFromSuperview];
        }
    }
}
- (void)createRegistExtraView
{
    [self createCheckPassLabel];
    [self createConPassInputField];
}
- (void)createLoginExreaView
{
    [self createNamePromtLabel];
    [self createPassPromtLabel];
    [self createSavePassButton];
    [self createUserInputField];
    [self createPassInputField];
}
- (void)clearTextEditing
{
    [self.userIDField endEditing:YES];
    [self.passField endEditing:YES];
    [self.conPassField endEditing:YES];
}
- (void)clearAllText
{
    _userIDField.text = @"";
    _passField.text =@"";
    _conPassField.text = @"";
}
- (void)resignFirstResponder
{
    [self clearTextEditing];
}
- (void)resetConstrains
{
    [self beganAnimationWith:@"back"];
}
- (void)setFields
{
    if (_operationType == login) {
        if (_currentAccount) {
            _userIDField.text = _currentAccount.phone;
            if (_currentAccount.savePasswd) {
                _passField.text = _currentAccount.pass;
            }
        }else{
            [self clearAllText];
        }
    }else{
        [self clearAllText];
    }
}
-(void)setOperationType:(OprationType)operationType
{
    _operationType = operationType;
    if (operationType == login) {
        _passField.returnKeyType = UIReturnKeyDone;
    }else{
        _passField.returnKeyType = UIReturnKeyNext;
    }
}
- (void)setSavePass:(BOOL)savePass
{
    _savePass = savePass;
    if (savePass) {
        [_savePassImage setBackgroundImage:[UIImage imageNamed:@"pass_save"] forState:UIControlStateNormal];
    }else{
        [_savePassImage setBackgroundImage:[UIImage imageNamed:@"pass_unsave"] forState:UIControlStateNormal];
    }
}
- (void)setCurrentAccount:(AccountInfo *)currentAccount
{
    _currentAccount = currentAccount;
    if (currentAccount) {
         _accNameLabel.text = _currentAccount.phone;
    }
}
#pragma mark - Actions ------------------------------
-(void)buttonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case TAG_HEAD:
        {
            
        }break;
        case TAG_LOGIN:
        {
            [self setOperationType:login];
            [self setFields];
            [self beganAnimationWith:@"login"];
            
        }break;
        case TAG_REGIST:
        {
            [self setOperationType:regist];
            [self setFields];
            [self beganAnimationWith:@"regist"];
        }break;
        case TAG_BACK:
        {
            [self setOperationType:none];
            [self beganAnimationWith:@"back"];
        }break;
        case TAG_SAVEPASS:
        {
            self.savePass = !self.savePass;
        }break;
        case TAG_POPACCOUNT:
        {
            [self.m_delegate userOffLine];
            [self beganAnimationWith:@"pop"];
        }break;
        default:
            break;
    }
}
- (void)beganAnimationWith:(NSString *)buttonType
{
    if ([@"login" isEqualToString:buttonType]) {
        [self setToLoginContains];
    }else if([@"regist" isEqualToString:buttonType]){
        [self setToRegistContains];
    }else if([@"didlogin" isEqualToString:buttonType]){
        [self setToDidLoginContains];
    }else{
        [self setToDefaultContains];
    }
}
- (void)setToLoginContains
{
    [self show:NO objects:@[_registButton,_loginButton,_popAccountButton,_accNameLabel]];
    [self show:YES objects:@[_savePassImage,_namePromt,_passPromt,_userIDField,_passField,_backButton]];
    
    [UIView animateWithDuration:.3f animations:^{
        _namePromt.alpha = 1;
        _passPromt.alpha = 1;
        _userIDField.alpha = 1;
        _passField.alpha = 1;
        
        _headImage.frame = CGRectMake(0, 0, 60, 60);
        _headImage.layer.cornerRadius = _headImage.frame.size.width/2.f;
        
        _headImage.center = CGPointMake(45, 95);
        _namePromt.center = CGPointMake(100, 70);
        _passPromt.center = CGPointMake(100, 115);
        _userIDField.center = CGPointMake(200, 65);
        _passField.center = CGPointMake(200, 110);
        _popAccountButton.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _accNameLabel.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
    }];
}
- (void)setToRegistContains
{
    [self show:NO objects:@[_registButton,_loginButton,_popAccountButton,_accNameLabel]];
    [self show:YES objects:@[_namePromt,_passPromt,_checkPass,_userIDField,_passField,_conPassField,_backButton]];
    
    [UIView animateWithDuration:.3f animations:^{
        _namePromt.alpha = 1;
        _passPromt.alpha = 1;
        _checkPass.alpha = 1;
        _userIDField.alpha = 1;
        _passField.alpha = 1;
        _conPassField.alpha = 1;
        
        _headImage.frame = CGRectMake(0, 0, 60, 60);
        _headImage.layer.cornerRadius = _headImage.frame.size.width/2.f;
        
        _headImage.center = CGPointMake(45, 95);
        
        _namePromt.center = CGPointMake(100, 45);
        _passPromt.center = CGPointMake(100, 85);
        _checkPass.center = CGPointMake(100, 125);
        
        _userIDField.center = CGPointMake(200, 40);
        _passField.center = CGPointMake(200, 80);
        _conPassField.center = CGPointMake(200, 120);
        _popAccountButton.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _accNameLabel.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
    }];
}
- (void)setToDefaultContains
{
    [self clearAllText];
    [self show:YES objects:@[_loginButton,_registButton]];
    [self show:NO objects:@[_namePromt,_passPromt,_checkPass,_userIDField,_passField,_conPassField,_backButton,_savePassImage,_popAccountButton,_accNameLabel]];
    
    [UIView animateWithDuration:.3f animations:^{
        
        _namePromt.alpha = 0;
        _passPromt.alpha = 0;
        _userIDField.alpha = 0;
        _passField.alpha = 0;
        _registButton.alpha = 1;
        _loginButton.alpha = 1;
        
        _headImage.frame = CGRectMake(0, 0, 80, 80);
        _headImage.layer.cornerRadius = _headImage.frame.size.width/2.f;

        _headImage.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _namePromt.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _passPromt.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _checkPass.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _userIDField.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _passField.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _conPassField.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _popAccountButton.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _accNameLabel.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
    }];
}
- (void)setToDidLoginContains
{
    [self clearAllText];
    [self show:NO objects:@[_namePromt,_passPromt,_checkPass,_userIDField,_passField,_conPassField,_backButton,_savePassImage,_loginButton,_registButton]];
    [self show:YES objects:@[_popAccountButton,_accNameLabel]];
    [UIView animateWithDuration:.3f animations:^{
        
        _namePromt.alpha = 0;
        _passPromt.alpha = 0;
        _userIDField.alpha = 0;
        _passField.alpha = 0;
        _registButton.alpha = 0;
        _loginButton.alpha = 0;
        _headImage.frame = CGRectMake(0, 0, 80, 80);
        _headImage.layer.cornerRadius = _headImage.frame.size.width/2.f;
        
        _popAccountButton.center = CGPointMake(300, self.bounds.size.height-25);
        _accNameLabel.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height-20);
        
        _headImage.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _namePromt.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _passPromt.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _checkPass.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _userIDField.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _passField.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
        _conPassField.center = CGPointMake(self.bounds.size.width/2.f, self.bounds.size.height/2.0f);
    }];
    [self show:YES objects:@[_loginButton,_registButton]];
}
#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:_userIDField]) {
        [_passField becomeFirstResponder];
    }else if([textField isEqual:_passField]){
        if (_operationType == login) {
            [self beganLogin];
        }else{
            [_conPassField becomeFirstResponder];
        }
    }else{
        [self beganRegist];
    }
    return YES;
}
#pragma mark - 账号操作 －－－－－－－－－－－－－－－－－－－－－
- (void)beganLogin
{
    [self clearTextEditing];
    if ([self checkFormat]) {
        [self.m_delegate login:_userIDField.text pwd:_passField.text savepwd:_savePass];
    }
}
- (void)beganRegist
{
    [self clearTextEditing];
    if ([self checkFormat]) {
        if ([self checkConPass]) {
            [self.m_delegate regist:_userIDField.text pwd:_passField.text];
        }
    }
}
- (BOOL)checkFormat
{
    if (![Utils checkTel:_userIDField.text]) {

        [HUD message:@"    "];
        return NO;
    }
    return YES;
}
- (BOOL)checkConPass
{
    if (![_passField.text isEqualToString:_conPassField.text]) {
        [HUD message:@"   "];
        return NO;
    }
    return YES;
}
- (void)setLoginStatus:(BOOL)status withCurrntAccount:(AccountInfo *)acc
{
    self.currentAccount = acc;
    if (status) {
        [self beganAnimationWith:@"didlogin"];
    }else{
        [self beganAnimationWith:@"back"];
    }
}
@end






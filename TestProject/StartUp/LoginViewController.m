//
//  LoginViewController.m
//  TestProject
//
//  Created by wangfei on 14-5-5.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "LoginViewController.h"
#import "PublicDefines.h"
#import "NetworkManager.h"
#import "UtilityTools.h"
#import "SVProgressHUD.h"
#import "GeneralData.h"
#import "MainViewController.h"
#import "AppDelegate.h"

// contentView位置定义
// 原始y位置
#define kInitialPlace       (IOS7?64:44)
// 点击第一个输入框y位置
#define kFirstPlace         (IOS7?64:44)
// 点击第二个输入框y位置
#define kSecondPlace        (IOS7?64:44)

@interface LoginViewController () {
    UITextField *_userName;
    UITextField *_password;
    UILabel *_userLabel;
    UILabel *_passwordLabe;
    UIButton *_btnLogin;
}

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)changedBtnLoginStatus {
    if (_userName.text && _userName.text.length > 0 &&
        _password.text && _password.text.length > 0) {
        _btnLogin.enabled = YES;
    }
    else {
        _btnLogin.enabled = NO;
    }
}

-(void)allResign {
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = kInitialPlace;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    }];
}

- (void)cancelEditing {
    [self allResign];
}

- (void)doneEditing {
    [self allResign];
}

- (void)createViews {
    CGFloat offsetY = IOS7?20:30;

    // 用户名称
    _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, IOS7?offsetY:(offsetY - 10), SCREEN_WIDTH - 90, 40)];
    _userLabel.backgroundColor = [UIColor clearColor];
    _userLabel.textColor = [UIColor lightGrayColor];
    _userLabel.textAlignment = NSTextAlignmentCenter;
    _userLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    _userLabel.text = @"手机号码";
    [self.contentView addSubview:_userLabel];

    _userName = [[UITextField alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    _userName.font = [UIFont boldSystemFontOfSize:17.0f];
    _userName.delegate = (id)self;
    _userName.keyboardType = UIKeyboardTypeNumberPad;
    _userName.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    _userName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_userName];

    offsetY += IOS7?40:30;
    // 下方线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 1)];
    lineView.backgroundColor = UIColorFromRGB(0x485e73);
    [self.contentView addSubview:lineView];
    
    offsetY += IOS7?5:15;
    // 密码
    _passwordLabe = [[UILabel alloc] initWithFrame:CGRectMake(45, IOS7?offsetY:(offsetY - 10), SCREEN_WIDTH - 90, 40)];
    _passwordLabe.backgroundColor = [UIColor clearColor];
    _passwordLabe.textColor = [UIColor lightGrayColor];
    _passwordLabe.textAlignment = NSTextAlignmentCenter;
    _passwordLabe.font = [UIFont boldSystemFontOfSize:17.0f];
    _passwordLabe.text = @"登录密码";
    [self.contentView addSubview:_passwordLabe];

    _password = [[UITextField alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    _password.font = [UIFont boldSystemFontOfSize:17.0f];
    _password.delegate = (id)self;
    _password.keyboardType = UIKeyboardTypeDefault;
    _password.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    _password.textAlignment = NSTextAlignmentCenter;
    _password.secureTextEntry = YES;
    [self.contentView addSubview:_password];
    
    offsetY += IOS7?40:30;
    // 下方线
    lineView = [[UIImageView alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 1)];
    lineView.backgroundColor = UIColorFromRGB(0x485e73);
    [self.contentView addSubview:lineView];

    offsetY += 23;
    // 登录按钮
    _btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLogin.frame = CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40);
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_main_pressed"] forState:UIControlStateHighlighted];
    [_btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_main_disable"] forState:UIControlStateDisabled];
    [_btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    _btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_btnLogin setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [_btnLogin setTitleColor:UIColorFromRGB(TEXT_DISABLE_COLOR) forState:UIControlStateDisabled];
    [_btnLogin addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    _btnLogin.enabled = NO;
    [self.contentView addSubview:_btnLogin];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self.contentView addGestureRecognizer:tapGesture];
}

- (void)onTapAction:(UITapGestureRecognizer*)gesture {
    [self allResign];
}

- (void)registerNotifcations {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged) name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"登录羞羞"];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifcations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleLogin {
#if LOCAL_VERSION
    // 跳转到主页面????
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    [appDelegate.navigationController pushViewController:mainVC animated:YES];
#else
    [SVProgressHUD showWithStatus:@"正在登录..."];
    self.view.userInteractionEnabled = NO;
    
    NetworkManager *manager = [NetworkManager getInstance];
    
    manager.loginBlock = ^(NSArray *arrUserInfo, NSInteger errorCode, NSString *errorDesc){
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            self.view.userInteractionEnabled = YES;
            
            if (errorCode == 200) {
                // 登录成功
                [UserInfoData shareInstance].userInfo = [arrUserInfo objectAtIndex:0];
                if (arrUserInfo.count > 1) {
                    [UserInfoData shareInstance].arrUserInfo = [arrUserInfo subarrayWithRange:NSMakeRange(1, arrUserInfo.count - 1)];
                }
                // 跳转到主页面????
                [self dismissViewControllerAnimated:YES completion:nil];
                AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
                MainViewController *mainVC = [[MainViewController alloc] init];
                
                [appDelegate.navigationController pushViewController:mainVC animated:YES];

            }
            else {
                // 登录失败
                if (errorDesc) {
                    [UtilityTools showGeneralAlertWithTitle:nil message:errorDesc cancelButton:nil delegate:nil tag:0];
                }
                else {
                    [UtilityTools showGeneralAlertWithTitle:nil message:@"网络不给力" cancelButton:nil delegate:nil tag:0];
                }
            }
        });
    };
    
    [manager asychronousLogin:_userName.text password:_password.text isList:NO];
#endif
}

- (void)onClickLogin {
    if (_userName.text == nil || _userName.text.length == 0) {
        [UtilityTools showGeneralAlertWithTitle:nil message:@"请输入用户名" cancelButton:nil delegate:self tag:200];
    }
    else if (_password.text == nil || _password.text.length == 0) {
        [UtilityTools showGeneralAlertWithTitle:nil message:@"请输入密码" cancelButton:nil delegate:self tag:201];
    }
    else {
        [self handleLogin];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 200: // 未输入用户名
            _userName.text = nil;
            _password.text = nil;
            [_userName becomeFirstResponder];
            break;
        case 201: // 未输入密码
            _password.text = nil;
            [_password becomeFirstResponder];
            break;
            
        default:
            break;
    }
}

#pragma mark-
#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = self.contentView.frame;
    
    if (textField == _userName) {
        _userLabel.hidden = YES;
        frame.origin.y = kFirstPlace;
    }
    else if (textField == _password) {
        _passwordLabe.hidden = YES;
        frame.origin.y = kSecondPlace;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
    }];
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _userName && _userName.text.length == 0) {
        _userLabel.hidden = NO;
    }
    else if (textField == _password && _password.text.length == 0) {
        _passwordLabe.hidden = NO;
    }
}

- (void)textFiledEditChanged {
    [self changedBtnLoginStatus];
}

@end

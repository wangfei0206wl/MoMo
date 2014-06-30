//
//  UserMainView.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "UserMainView.h"
#import "PublicDefines.h"
#import "UtilityTools.h"
#import "ChatRoomViewController.h"
#import "MainViewController.h"

@interface MatchUserView : UIView

- (id)initViews;

@end

@implementation MatchUserView

- (id)initViews {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height - 64);
    
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    
    return self;
}

- (void)createViews {
    self.backgroundColor = [UIColor whiteColor];
    CGFloat offsetY = 0;
    
    // 背景
    UIView *upBGView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, SCREEN_WIDTH)];
    upBGView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self addSubview:upBGView];
    
    offsetY += 20;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    titleLabel.text = @"配给你的羞羞小伙伴";
    [upBGView addSubview:titleLabel];

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame = CGRectMake(0, 0, 80, 80);
    indicatorView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_WIDTH / 2);
    [indicatorView startAnimating];
    [upBGView addSubview:indicatorView];
}

@end

@interface UserMainView() {
    UITextField *_greetingTextField;
    UILabel *_greetingLabel;
    UIButton *_btnChat;
    UIView *_bottomView;
    MatchUserView *_matchUserView;
    
    UserInfoItem *_userInfoItem;
    BOOL _bApply;
    NSString *_greeting;
}

@end

@implementation UserMainView

@synthesize bApply = _bApply;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initViews:(CGFloat)xOffset userInfo:(UserInfoItem *)userInfo isApply:(BOOL)bApply greeting:(NSString *)message {
    CGRect frame = CGRectMake(xOffset, 0, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height - 64);
    
    _userInfoItem = userInfo;
    _bApply = bApply;
    _greeting = message;
    
    if (self = [self initWithFrame:frame]) {
        [self createViews];
        if (_bApply == NO) {
            [self performSelector:@selector(delayOperation) withObject:nil afterDelay:3.0];
        }
    }
    
    return self;
}

- (void)animationWithType:(int)type {
    if (type == 0) {
        [UIView animateWithDuration:0.3f animations:^{
            _bottomView.alpha = 0;
        } completion:^(BOOL finished) {
            _bottomView.alpha = 1.0f;
        }];
    }
}

- (void)createViews {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetY = 0;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, SCREEN_WIDTH)];
    bgView.backgroundColor = UIColorFromRGB(_userInfoItem.bgColor);
    [self addSubview:bgView];

    // 标题
    offsetY += 20;
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
//    tipLabel.backgroundColor = [UIColor clearColor];
//    tipLabel.textAlignment = NSTextAlignmentCenter;
//    tipLabel.font = [UIFont boldSystemFontOfSize:15.0f];
//    tipLabel.textColor = [UIColor whiteColor];
//    tipLabel.text = _bApply?@"想和你聊羞羞的小伙伴":@"配给你的羞羞小伙伴";
//    [self addSubview:tipLabel];
    
    // 用户性别
    offsetY += 70;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) / 2, offsetY, 60, 60)];
    if (_userInfoItem.sex == 1) {
        bgImageView.image = [UIImage imageNamed:@"icon_boy_white"];
    }
    else {
        bgImageView.image = [UIImage imageNamed:@"icon_girl_white"];
    }
    [self addSubview:bgImageView];
    
    // 用户星级
    offsetY += 100;
    [self createEvaluationLevel:offsetY];
    
    // 用户评价
    offsetY += 45;
    [self createEvaluation:offsetY];
    
    // 底部视图
//    [self createBottomView];
    
    if (_bApply == NO) {
        // 创建加载视图
        [self createMatchUserView];
    }
}

- (void)createEvaluationLevel:(CGFloat)offsetY {
    CGFloat intervalX = 0;
    CGFloat offsetX = (SCREEN_WIDTH - _userInfoItem.evaluationValue * 40 - (_userInfoItem.evaluationValue - 1) * intervalX) / 2;
    offsetY += 10;
    
    for (int i = 0; i < _userInfoItem.evaluationValue; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, offsetY, 40, 40)];
        starImageView.image = [UIImage imageNamed:@"icon_star_white"];
        
        [self addSubview:starImageView];
        
        offsetX += (intervalX + 40);
    }
}

- (void)createEvaluation:(CGFloat)offsetY {
    UILabel *evalutationLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    evalutationLabel.backgroundColor = [UIColor clearColor];
    evalutationLabel.textAlignment = NSTextAlignmentCenter;
    evalutationLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    evalutationLabel.textColor = [UIColor whiteColor];
    evalutationLabel.text = _userInfoItem.econtent;
    [self addSubview:evalutationLabel];
}

- (void)createBottomView {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64 - SCREEN_WIDTH;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, height + 200)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bottomView];
    
    // 半透明背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height + 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.8;
    [_bottomView addSubview:bgView];
    
    CGFloat offsetY = ((height - 148) < 5)?5:(height - 148);
    // 问候语
    if (_bApply) {
        // 对方问候语
        UILabel *greetingLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
        greetingLabel.backgroundColor = [UIColor clearColor];
        greetingLabel.textAlignment = NSTextAlignmentCenter;
        greetingLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        greetingLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
        greetingLabel.text = _greeting;
        [_bottomView addSubview:greetingLabel];

        offsetY += 40;
    }
    else {
        // 我的问候语
        _greetingLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
        _greetingLabel.backgroundColor = [UIColor clearColor];
        _greetingLabel.textColor = [UIColor lightGrayColor];
        _greetingLabel.textAlignment = NSTextAlignmentCenter;
        _greetingLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _greetingLabel.text = @"写一句开场白";
        [_bottomView addSubview:_greetingLabel];

        offsetY += IOS7?0:10;
        _greetingTextField = [[UITextField alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
        _greetingTextField.font = [UIFont boldSystemFontOfSize:17.0f];
        _greetingTextField.delegate = (id)self;
        _greetingTextField.keyboardType = UIKeyboardTypeDefault;
        _greetingTextField.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
        _greetingTextField.textAlignment = NSTextAlignmentCenter;
        
        [_bottomView addSubview:_greetingTextField];
        offsetY -= IOS7?0:10;
        
        // 底部线
        offsetY += 40;
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x485e73);
        [_bottomView addSubview:lineView];
       
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    // 聊天按钮
    offsetY += IPHONE5?23:10;
    _btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnChat.frame = CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40);
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"btn_main_pressed"] forState:UIControlStateHighlighted];
    [_btnChat setBackgroundImage:[UIImage imageNamed:@"btn_main_disable"] forState:UIControlStateDisabled];
    [_btnChat setTitle:_bApply?@"答应ta":@"想和ta聊羞羞" forState:UIControlStateNormal];
    _btnChat.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_btnChat setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [_btnChat setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateHighlighted];
    [_btnChat setTitleColor:UIColorFromRGB(TEXT_DISABLE_COLOR) forState:UIControlStateDisabled];
    [_btnChat addTarget:self action:@selector(onClickChat) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnChat];
}

- (void)onTapAction:(UITapGestureRecognizer*)gesture {
    [self allResign];
}

- (void)createMatchUserView {
    _matchUserView = [[MatchUserView alloc] initViews];
    
    [self addSubview:_matchUserView];
}

-(void)allResign {
    [_greetingTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 0);
        _bottomView.transform = trans;
    }];
}

- (void)cancelEditing {
    [self allResign];
}

- (void)doneEditing {
    [self allResign];
}

- (void)onClickChat {
    ChatRoomViewController *controller = [[ChatRoomViewController alloc] init];
    
    UIResponder *nextResponder = [self.superview.superview nextResponder];
    if ([nextResponder isKindOfClass:[MainViewController class]]) {
        MainViewController *mainController = (MainViewController *)nextResponder;
        
        [mainController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)delayOperation {
    [_matchUserView removeFromSuperview];
}

#pragma mark-
#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _greetingLabel.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -(IPHONE5?260:260));
        _bottomView.transform = trans;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        _greetingLabel.hidden = NO;
    }
}

@end

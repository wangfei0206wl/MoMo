//
//  QuitMainView.m
//  TestProject
//
//  Created by wangfei on 14-5-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "QuitMainView.h"
#import "PublicDefines.h"
#import "GeneralData.h"
#import "UtilityTools.h"
#import "ChatRoomViewController.h"

@interface QuitView : UIView

- (id)initViews:(CGFloat)offsetY endAction:(SEL)endAction cancelAction:(SEL)cancelAction;

@end

@implementation QuitView

- (id)initViews:(CGFloat)offsetY endAction:(SEL)endAction cancelAction:(SEL)cancelAction {
    CGRect frame = CGRectMake(0, offsetY, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height - 64);
    
    if (self = [super initWithFrame:frame]) {
        [self createViews:endAction cancelAction:cancelAction];
    }
    
    return self;
}

- (void)createViews:(SEL)endAction cancelAction:(SEL)cancelAction {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetY = 25;
    // tips
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    tipLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    tipLabel.text = @"确认提前结束？";
    [self addSubview:tipLabel];
    
    // 线束按钮
    offsetY += 45;
    UIButton *btnEnd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEnd.frame = CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40);
    [btnEnd setBackgroundImage:[UIImage imageNamed:@"btn_red_normal"] forState:UIControlStateNormal];
    [btnEnd setBackgroundImage:[UIImage imageNamed:@"btn_red_pressed"] forState:UIControlStateHighlighted];
    [btnEnd setTitle:@"结束" forState:UIControlStateNormal];
    btnEnd.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnEnd setTitleColor:UIColorFromRGB(TEXT_RED_COLOR) forState:UIControlStateNormal];
    [btnEnd addTarget:self.superview action:endAction forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnEnd];
    
    // 按错了按钮
    offsetY += 70;
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(120, offsetY, SCREEN_WIDTH - 240, 40);
    [btnCancel setTitle:@"按错了" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnCancel setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [btnCancel addTarget:self.superview action:cancelAction forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCancel];
}

@end

#define kButtonStarBaseTag  200

@interface EvaluateView : UIView {
    // 评价内容
    UITextField *_eContent;
    // 做placeholder
    UILabel *_eContentLabel;
    // 评价按钮
    UIButton *_btnEvalute;
    // 星级按钮集
    NSArray *_arrBtnStars;
    
    // 星级值
    int _starLevel;
}

- (id)initViews:(CGFloat)offsetY evaluateAction:(SEL)evaluateAction cancelAction:(SEL)cancelAction;

@end

@implementation EvaluateView

- (id)initViews:(CGFloat)offsetY evaluateAction:(SEL)evaluateAction cancelAction:(SEL)cancelAction {
    CGRect frame = CGRectMake(0, offsetY, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height - 64);
    
    _starLevel = 0;
    
    if (self = [super initWithFrame:frame]) {
        [self createViews:evaluateAction cancelAction:cancelAction];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged) name:@"UITextFieldTextDidChangeNotification" object:nil];
    }
    
    return self;
}

-(void)allResign {
    [_eContent resignFirstResponder];
}

- (void)cancelEditing {
    [self allResign];
}

- (void)doneEditing {
    [self allResign];
}

- (void)createStars:(CGFloat)offsetY {
    int numStar = 5;
    CGFloat intervalX = 0;
    CGFloat offsetX = (SCREEN_WIDTH - numStar * 40 - (numStar - 1) * intervalX) / 2;
    NSMutableArray *arrButtons = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numStar; i++) {
        UIButton *btnStar = [UIButton buttonWithType:UIButtonTypeCustom];
        btnStar.frame = CGRectMake(offsetX, offsetY, 40, 40);
        [btnStar setImage:[UIImage imageNamed:@"btn_star_unselected"] forState:UIControlStateNormal];
        [btnStar setImage:[UIImage imageNamed:@"btn_star_pressed"] forState:UIControlStateHighlighted];
        [btnStar setImage:[UIImage imageNamed:@"btn_star_selected"] forState:UIControlStateSelected];
        [btnStar addTarget:self action:@selector(onClickStar:) forControlEvents:UIControlEventTouchUpInside];
        btnStar.tag = kButtonStarBaseTag + i;
        [self addSubview:btnStar];
        
        [arrButtons addObject:btnStar];
        
        offsetX += (intervalX + 40);
    }

    _arrBtnStars = arrButtons;
}

- (void)createViews:(SEL)evaluateAction cancelAction:(SEL)cancelAction {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetY = 25;
    // tips
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, offsetY, SCREEN_WIDTH - 80, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    tipLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    tipLabel.text = @"给ta一个评价以免别的小伙伴被坑~";
    tipLabel.numberOfLines = 0;
    [self addSubview:tipLabel];
    
    // 星级评分
    offsetY += 55;
    [self createStars:offsetY];
    
    // 评价
    offsetY += IOS7?45:55;
    _eContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, IOS7?offsetY:(offsetY - 10), SCREEN_WIDTH - 90, 40)];
    _eContentLabel.backgroundColor = [UIColor clearColor];
    _eContentLabel.textColor = [UIColor lightGrayColor];
    _eContentLabel.textAlignment = NSTextAlignmentCenter;
    _eContentLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    _eContentLabel.text = @"如：文艺 小清新 80后";
    [self addSubview:_eContentLabel];

    _eContent = [[UITextField alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    _eContent.font = [UIFont boldSystemFontOfSize:17.0f];
    _eContent.delegate = (id)self;
    _eContent.keyboardType = UIKeyboardTypeDefault;
    _eContent.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    _eContent.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_eContent];

    // 分隔线
    offsetY += IOS7?35:25;
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 1)];
    lineView.backgroundColor = UIColorFromRGB(0x485e73);
    [self addSubview:lineView];
    
    // 评价按钮
    offsetY += 22;
    _btnEvalute = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEvalute.frame = CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40);
    [_btnEvalute setBackgroundImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
    [_btnEvalute setBackgroundImage:[UIImage imageNamed:@"btn_main_pressed"] forState:UIControlStateHighlighted];
    [_btnEvalute setBackgroundImage:[UIImage imageNamed:@"btn_main_disable"] forState:UIControlStateDisabled];
    [_btnEvalute setTitle:@"评价" forState:UIControlStateNormal];
    _btnEvalute.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_btnEvalute setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [_btnEvalute setTitleColor:UIColorFromRGB(TEXT_DISABLE_COLOR) forState:UIControlStateDisabled];
    [_btnEvalute addTarget:self.superview action:evaluateAction forControlEvents:UIControlEventTouchUpInside];
    _btnEvalute.enabled = NO;
    [self addSubview:_btnEvalute];
    
    // 懒得评按钮
    offsetY += 58;
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(120, offsetY, SCREEN_WIDTH - 240, 40);
    [btnCancel setTitle:@"懒得评" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnCancel setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [btnCancel addTarget:self.superview action:cancelAction forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCancel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)onTapAction:(UITapGestureRecognizer*)gesture {
    [self allResign];
}

- (void)changeEvaluateButtonStatus {
    if (_starLevel == 0 && _eContent.text.length == 0) {
        _btnEvalute.enabled = NO;
    }
    else {
        _btnEvalute.enabled = YES;
    }
}

#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField  {
    _eContentLabel.hidden = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        _eContentLabel.hidden = NO;
    }
}

- (void)textFiledEditChanged {
    [self changeEvaluateButtonStatus];
}

- (void)onClickStar:(UIButton *)sender {
    _starLevel = (int)(sender.tag - kButtonStarBaseTag + 1);
    
    for (int i = 0; i < _arrBtnStars.count; i++) {
        UIButton *btnStar = [_arrBtnStars objectAtIndex:i];
        if (i < _starLevel) {
            [btnStar setSelected:YES];
        }
        else {
            [btnStar setSelected:NO];
        }
    }
    [self changeEvaluateButtonStatus];
}

@end

@interface QuitMainView() {
    // 聊天对象个人信息
    UserInfoItem *_userInfoItem;
    
    QuitView *_quitView;
    EvaluateView *_evaluateView;
    UIImageView *_bgUpImageView;
    UIImageView *_bgDownImageView;
}

@end

@implementation QuitMainView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initViews {
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height - 64);
    CGRect frame = CGRectMake(0, height, SCREEN_WIDTH, height * 2);
    
    if (self = [self initWithFrame:frame]) {
        [self createViews];
    }
    
    return self;
}

- (void)showView {
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height - 64);
    
    [UIView animateWithDuration:0.3f animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -height);
        self.transform = trans;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:_evaluateView];
}

- (void)createViews {
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height - 64);
    self.backgroundColor = [UIColor clearColor];
    
    _bgUpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    _bgUpImageView.image = _screenshotImage;
    [self addSubview:_bgUpImageView];

    _bgDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, height)];
    _bgDownImageView.image = _screenshotImage;
    [self addSubview:_bgDownImageView];

    // 添加退出提示view
    _quitView = [[QuitView alloc] initViews:0 endAction:@selector(onClickEnd:) cancelAction:@selector(onClickUnEnd:)];
    [self addSubview:_quitView];
    
    // 添加评价view
    _evaluateView = [[EvaluateView alloc] initViews:height evaluateAction:@selector(onClickEvaluate:) cancelAction:@selector(onClickUnEvaluate:)];
    [self addSubview:_evaluateView];
}

- (void)setScreenshotImage:(UIImage *)screenshotImage {
    _screenshotImage = screenshotImage;
    _bgUpImageView.image = _screenshotImage;
    _bgDownImageView.image = _screenshotImage;
}

- (void)onClickEnd:(UIButton *)sender {
    CGFloat height = ([[UIScreen mainScreen] bounds].size.height - 64);

    [UIView animateWithDuration:0.3f animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -2 * height);
        self.transform = trans;
    } completion:^(BOOL finished) {
        [_delegate QuitMainView:self didEndChat:YES];
    }];
}

- (void)onClickUnEnd:(UIButton *)sender {
    [UIView animateWithDuration:0.3f animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 0);
        self.transform = trans;
    } completion:^(BOOL finished) {
        [_delegate QuitMainView:self didEndChat:NO];
    }];
}

- (void)onClickEvaluate:(UIButton *)sender {
    [_delegate QuitMainView:self didEvaluate:YES];
}

- (void)onClickUnEvaluate:(UIButton *)sender {
    [_delegate QuitMainView:self didEvaluate:NO];
}

@end

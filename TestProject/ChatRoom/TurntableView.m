//
//  TurntableView.m
//  TestProject
//
//  Created by wangfei on 14-5-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "TurntableView.h"
#import "PublicDefines.h"
#import "BBCyclingLabel.h"

@interface TurntableView () {
    UIView *_textBGView;
    BBCyclingLabel *_messageLabel;
    UIButton *_btnTurntable;
    
    BOOL _bTextViewShow;
    BOOL _isAnimation;
    CGFloat _angle;
    int _showIndex;
    NSArray *_arrMessages;
    NSArray *_arrNewMessages;
    
    NSTimer *_turntableTimer;
    NSTimer *_showMessageTimer;
}

@end

@implementation TurntableView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initViews:(CGFloat)offsetY {
    CGRect frame = CGRectMake(0, offsetY, SCREEN_WIDTH, 75);
    
    _bTextViewShow = YES;
    _isAnimation = NO;
    _showIndex = 0;
    _arrMessages = [NSArray arrayWithObjects:@"你好！", @"你是哪位？", @"感谢你的帮助！", @"节日快乐，小朋友！", nil];
    
    if (self = [self initWithFrame:frame]) {
        [self createViews];
    }
    
    return self;
}

- (void)textViewAnimation:(BOOL)bShrink {
    if (bShrink) {
        // 收缩动画
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform trans = CGAffineTransformMakeTranslation(243, 0);
            _textBGView.transform = trans;
        } completion:^(BOOL finished) {
            _bTextViewShow = NO;
            self.userInteractionEnabled = YES;
        }];
    }
    else {
        // 伸展动画
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 0);
            _textBGView.transform = trans;
        } completion:^(BOOL finished) {
            _bTextViewShow = YES;
            self.userInteractionEnabled = YES;
            [self turntableAnimation];
            [self startTextAnimation];
        }];
    }
}

- (void) handleTimer: (NSTimer *) timer {
    _angle += 0.1;
    if (_angle > 2 * M_PI) {
        _angle = 0;
    }
    CGAffineTransform trans = CGAffineTransformMakeRotation(-_angle);
    _btnTurntable.transform = trans;
}

- (void)turntableAnimation {
//    if (_turntableTimer) {
//        [_turntableTimer invalidate];
//        _turntableTimer = nil;
//    }
//    _turntableTimer = [ NSTimer scheduledTimerWithTimeInterval: 0.01
//                                                        target: self
//                                                      selector: @selector(handleTimer:)
//                                                      userInfo: nil
//                                                       repeats: YES ];
    /*
     LayerKit
     http://www.cocoachina.com/bbs/read.php?tid-185-fpage-7-toread-1.html
     */
}

- (void)startAnimation {
    if (_bTextViewShow == NO) {
        [self textViewAnimation:NO];
    }
    else {
        [self turntableAnimation];
        [self startTextAnimation];
    }
}

- (void)stopAnimation {
    if (_turntableTimer) {
        [_turntableTimer invalidate];
        _turntableTimer = nil;
    }
    [self stopTextAnimation];
    if (_bTextViewShow) {
        [self textViewAnimation:YES];
    }
}

- (void)startTextAnimation {
    if([_showMessageTimer isValid])
    {
        [_showMessageTimer invalidate];
    }
    
    _showIndex = 0;
    
    _showMessageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showNextMessage) userInfo:nil repeats:YES];
}

- (void)stopTextAnimation {
    if([_showMessageTimer isValid])
    {
        [_showMessageTimer invalidate];
    }
}

- (void)showNextMessage {
    _showIndex++;
    
    if(_showIndex == [_arrMessages count]) {
        _showIndex = 0;
        
        if(_arrNewMessages != nil) {
            _arrMessages = _arrNewMessages;
            _arrNewMessages = nil;
        }
    }
    
    NSString *showString = [_arrMessages objectAtIndex:_showIndex];
    
    [_messageLabel setText:showString animated:YES];
}

- (void)createViews {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetX = 35;
    
    UIView *leftBGView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 15, 243, 45)];
    leftBGView.backgroundColor = [UIColor clearColor];
    leftBGView.clipsToBounds = YES;
    [self addSubview:leftBGView];

    // 创建消息背景
    _textBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 243, 45)];
    _textBGView.backgroundColor = [UIColor clearColor];
    [leftBGView addSubview:_textBGView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 243, 45)];
    bgImageView.image = [UIImage imageNamed:@"list_wheel"];
    [_textBGView addSubview:bgImageView];
    
    // 消息文本
#if 0
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 233, 45)];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _messageLabel.textColor = UIColorFromRGB(TEXT_RED_COLOR);
    _messageLabel.text = @"敢不敢用羞羞转盘？";
#else
    _messageLabel = [[BBCyclingLabel alloc] initWithFrame:CGRectMake(5, 0, 233, 45)];
    _messageLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _messageLabel.textColor = UIColorFromRGB(TEXT_RED_COLOR);
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.numberOfLines = 1;
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.transitionDuration = 0.5;
    _messageLabel.transitionEffect = BBCyclingLabelTransitionEffectScrollUp;
    _messageLabel.clipsToBounds = YES;
    [_messageLabel setText:@"敢不敢用羞羞转盘？" animated:NO];

#endif
    [_textBGView addSubview:_messageLabel];
    
    // 右侧view
    offsetX += 243;

    // 转盘按钮
    offsetX -= 23;
    _btnTurntable = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTurntable.frame = CGRectMake(offsetX, 15, 45, 45);
    [_btnTurntable setBackgroundImage:[UIImage imageNamed:@"btn_wheel_normal"] forState:UIControlStateNormal];
    [_btnTurntable setBackgroundImage:[UIImage imageNamed:@"btn_wheel_pressed"] forState:UIControlStateHighlighted];
    [_btnTurntable addTarget:self.superview action:@selector(onClickTurntable) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btnTurntable];
}

- (void)onClickTurntable {
    _isAnimation = !_isAnimation;
    if (_isAnimation) {
        if (_delegate) {
            [_delegate turntableView:self sendMessage:nil animationStart:YES];
        }
        [self startAnimation];
    }
    else {
        // 发送消息
        if (_delegate) {
            [_delegate turntableView:self sendMessage:[_arrMessages objectAtIndex:_showIndex] animationStart:NO];
        }
        [self stopAnimation];
    }
}

@end

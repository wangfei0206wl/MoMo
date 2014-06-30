//
//  ChatSettingView.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ChatSettingView.h"
#import "PublicDefines.h"

@interface ChatSettingView() {
    UISwitch *_silenceSwitch;
}

@end

@implementation ChatSettingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initViews:(CGFloat)xOffset {
    CGRect frame = CGRectMake(xOffset, 0, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height - 64);
    
    if (self = [self initWithFrame:frame]) {
        [self createViews];
    }
    
    return self;
}

- (void)createViews {
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat offsetY = 0;
    
    // 创建上方背景
    UIView *upBGView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, SCREEN_WIDTH)];
    upBGView.backgroundColor = UIColorFromRGB(0xeeeeee);
    [self addSubview:upBGView];
    
    offsetY += 105;
    _silenceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(130, 90, 60, 30)];
    _silenceSwitch.center = CGPointMake(SCREEN_WIDTH / 2, offsetY);
    [_silenceSwitch addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [upBGView addSubview:_silenceSwitch];
    
    offsetY += 25;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    titleLabel.text = @"免打扰";
    [upBGView addSubview:titleLabel];
    
    offsetY += 50;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 60)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    contentLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    contentLabel.text = @"打开后，小伙伴暂时找不到你了~";
    contentLabel.numberOfLines = 0;
    [upBGView addSubview:contentLabel];
}

- (void)onSwitchChanged:(id)sender {
    NSLog(@"-------switch status: %d", _silenceSwitch.on);
}

@end

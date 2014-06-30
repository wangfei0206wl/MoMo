//
//  IntroduceView.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "IntroduceView.h"
#import "PublicDefines.h"

@implementation IntroduceView

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
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    titleLabel.text = @"想要更多小伙伴？";
    [upBGView addSubview:titleLabel];
    
    offsetY += 55;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 70)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    contentLabel.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    contentLabel.text = @"每次仅能配给您3个小伙伴，如果不喜欢，40分钟后再来看另外3个~";
    contentLabel.numberOfLines = 0;
    [upBGView addSubview:contentLabel];
}

@end

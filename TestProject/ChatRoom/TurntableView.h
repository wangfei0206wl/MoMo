//
//  TurntableView.h
//  TestProject
//
//  Created by wangfei on 14-5-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TurntableView;

@protocol TurntableViewDelegate <NSObject>

@required
// 当点击停止时，进行消息发送
- (void)turntableView:(TurntableView *)turntable sendMessage:(NSString *)message animationStart:(BOOL)bStart;

@end

// 聊天转盘
@interface TurntableView : UIView

@property (nonatomic, assign) id<TurntableViewDelegate> delegate;

- (id)initViews:(CGFloat)offsetY;

// 开始动画
- (void)startAnimation;
// 停止动画
- (void)stopAnimation;

@end

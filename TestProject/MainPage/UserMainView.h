//
//  UserMainView.h
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralData.h"

// 包括想与我聊天的用户与我想聊天的用户
@interface UserMainView : UIView

// (YES: 想与聊天的用户; NO: 我想聊天的用户)
@property (nonatomic, assign) BOOL bApply;

/*
 初始化聊天用户页面
 xOffset: x方向偏移
 userInfo: 用户信息
 bApply: 对方申请与我聊天(YES), 我申请聊天(NO)
 message: 问候语(如果是我申请的，则可以为空)
 */
- (id)initViews:(CGFloat)xOffset userInfo:(UserInfoItem *)userInfo isApply:(BOOL)bApply greeting:(NSString *)message;

- (void)animationWithType:(int)type;

@end

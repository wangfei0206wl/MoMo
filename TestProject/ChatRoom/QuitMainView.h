//
//  QuitMainView.h
//  TestProject
//
//  Created by wangfei on 14-5-23.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuitMainView;

@protocol QuitMainViewDelegate <NSObject>

@required
// 是否结束聊天
- (void)QuitMainView:(QuitMainView *)mainView didEndChat:(BOOL)bEnd;
// 评价结束
- (void)QuitMainView:(QuitMainView *)mainView didEvaluate:(BOOL)bEvaluate;

@end

@interface QuitMainView : UIView

@property (nonatomic, assign) id<QuitMainViewDelegate> delegate;
@property (nonatomic, retain) UIImage *screenshotImage;

- (id)initViews;

- (void)showView;

- (void)removeObserver;

@end

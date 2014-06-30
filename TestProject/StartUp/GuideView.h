//
//  GuideView.h
//  TestProject
//
//  Created by wangfei on 14-5-5.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EndGuideDelegate <NSObject>
//引导页结束后的操作
-(void)guideDidEnded;

@end

@interface GuideView : UIView

@property (nonatomic, assign) id<EndGuideDelegate> delegate;

- (id)createGuideView;

-(void)showGuideView;

@end

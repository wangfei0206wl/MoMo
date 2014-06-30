//
//  GuideView.m
//  TestProject
//
//  Created by wangfei on 14-5-5.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "GuideView.h"
#import "PublicDefines.h"

@interface GuideView() {
    UIScrollView *_guideScrollView;
    NSArray *_arrGuideImages;
}

@end

@implementation GuideView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initGuideImages];
        [self createViews];
    }
    return self;
}

- (void)initGuideImages {
    if (IPHONE5) {
        _arrGuideImages = [NSArray arrayWithObjects:@"guide1.jpg", @"guide2.jpg", @"guide3.jpg", @"guide4.jpg", nil];
    }
    else {
        _arrGuideImages = [NSArray arrayWithObjects:@"guide1_4.jpg", @"guide2_4.jpg", @"guide3_4.jpg", @"guide4_4.jpg", nil];
    }
}

- (void)createViews {
    //滑动视图
    _guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _guideScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * [_arrGuideImages count], SCREEN_HEIGHT);
    _guideScrollView.pagingEnabled = YES;
    _guideScrollView.delegate = (id)self;
    _guideScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_guideScrollView];

    //添加引导图
    for (int i = 0; i < [_arrGuideImages count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageView setImage:[UIImage imageNamed:[_arrGuideImages objectAtIndex:i]]];
        [_guideScrollView addSubview:imageView];
    }
}

- (id)createGuideView {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
}

-(void)showGuideView {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

#pragma mark-----------UIScrollViewDelegate-------

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //向右滑动超出一定范围时，移除引导动画
    UITouch *touch = [[UITouch alloc] init];
    CGPoint p =[touch locationInView:_guideScrollView];
    
    if (p.x > _guideScrollView.contentSize.width - _guideScrollView.frame.size.width + 45) {
        [_delegate guideDidEnded];
    }
}

@end

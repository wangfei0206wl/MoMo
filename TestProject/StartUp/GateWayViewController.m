//
//  GateWayViewController.m
//  TestProject
//
//  Created by wangfei on 14-5-12.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "GateWayViewController.h"
#import "PublicDefines.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface GateWayViewController () {
    LoginViewController *_loginVC;
    RegisterViewController *_registerVC;
    UIScrollView *_contentScrollView;
    UIPageControl *_pageControl;
}

@end

@implementation GateWayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIView *)createUnitMiddleContent:(NSString *)content title:(NSString *)title offsetX:(CGFloat)offsetX {
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, SCREEN_WIDTH, 300)];
    midView.backgroundColor = [UIColor clearColor];

    if (title) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        titleLabel.text = title;
        [midView addSubview:titleLabel];
    }
    
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, SCREEN_WIDTH - 60, 80)];
    introduceLabel.backgroundColor = [UIColor clearColor];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    introduceLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    introduceLabel.text = content;
    introduceLabel.numberOfLines = 0;
    [midView addSubview:introduceLabel];

    return midView;
}

- (void)createMiddleContents {
    CGFloat offsetY = IPHONE5?110:90;
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, 300)];
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = (id)self;
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 300);
    
    [_contentScrollView addSubview:[self createUnitMiddleContent:@"我知道这世上有人在等我，不知道是不是你..." title:nil offsetX:0]];
    [_contentScrollView addSubview:[self createUnitMiddleContent:@"我用2/3柱香的时间认识你，再用一辈子忘记你..." title:nil offsetX:SCREEN_WIDTH]];
    [_contentScrollView addSubview:[self createUnitMiddleContent:@"想见你。" title:nil offsetX:SCREEN_WIDTH * 2]];
    [_contentScrollView addSubview:[self createUnitMiddleContent:@"和陌生的ta聊羞羞的话.." title:@"羞羞" offsetX:SCREEN_WIDTH * 3]];
    
    [self.view addSubview:_contentScrollView];
    
    // 创建page controller
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, IPHONE5?370:300, SCREEN_WIDTH, 40)];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.userInteractionEnabled = NO;
    [self.view addSubview:_pageControl];
}

- (void)createViews {
    self.view.backgroundColor = UIColorFromRGB(0xfbfbfb);
    // 介绍页
    UIImageView *introduceView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    introduceView.image = [UIImage imageNamed:IPHONE5?@"Default-568h":@"Default"];
    [self.view addSubview:introduceView];
    
    // 中间内容
    [self createMiddleContents];
#if 0
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, IPHONE5?110:90, SCREEN_WIDTH - 60, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:25.0f];
    titleLabel.text = @"羞羞";
    [self.view addSubview:titleLabel];

    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, IPHONE5?180:160, SCREEN_WIDTH - 60, 40)];
    introduceLabel.backgroundColor = [UIColor clearColor];
    introduceLabel.textColor = [UIColor whiteColor];
    introduceLabel.textAlignment = NSTextAlignmentCenter;
    introduceLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    introduceLabel.text = @"和陌生的ta聊羞羞的话..";
    [self.view addSubview:introduceLabel];
#endif
    // 注册
    UIButton *btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegister.frame = CGRectMake(45, IPHONE5?435:355, SCREEN_WIDTH - 90, 40);
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
    [btnRegister setBackgroundImage:[UIImage imageNamed:@"btn_main_pressed"] forState:UIControlStateHighlighted];
    [btnRegister setTitle:@"注册" forState:UIControlStateNormal];
    btnRegister.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnRegister setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(onClickRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
    
    // 登录
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(45, IPHONE5?495:415, SCREEN_WIDTH - 90, 40);
//    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
//    [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_main_pressed"] forState:UIControlStateHighlighted];
    [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateHighlighted];
    [btnLogin addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickRegister {
    _registerVC = [[RegisterViewController alloc] init];
    
    [self presentViewController:_registerVC animated:YES completion:nil];
}

- (void)onClickLogin {
    _loginVC = [[LoginViewController alloc] init];
    
    [self presentViewController:_loginVC animated:YES completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor(scrollView.contentOffset.x - pageWidth / 2) /pageWidth + 1;
    
    _pageControl.currentPage = page;
}

@end

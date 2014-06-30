//
//  AccountViewController.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "AccountViewController.h"
#import "PublicDefines.h"
#import "GeneralData.h"
#import "AppDelegate.h"

/*
 可选颜色值
 1、0x7388a8
 2、0xd86a7a
 3、0x666666
 4、0x00b7ee
 5、0x9881b5
 
 6、0x959595
 7、0xf58446
 8、0x9bbf4c
 9、0xecbc29
 10、0x68b788
 
 11、0xd34141
 12、0x69b1a7
 13、0xbf984c
 14、0xd37ac1
 15、0xc9b29c
 */
static int g_bgColors[] = {
//    0x7388a8, 0xd86a7a, 0x666666, 0x00b7ee, 0x9881b5,
//    0x959595, 0xf58446, 0x9bbf4c, 0xecbc29, 0x68b788,
//    0xd34141, 0x69b1a7, 0xbf984c, 0xd37ac1, 0xc9b29c
    0x7387a8, 0xe26e81, 0xd7caaa, 0xbec1ba, 0x1c1c1c,
    0xce0040, 0xff59bb, 0x0cba35, 0x33beff, 0xa921dd,
    0xf7c8da, 0xfff991, 0xbcdda4, 0x99d5f1, 0xdfcaeb
};

// 颜色选择x方向间距
#define COLOR_UNIT_INTERVAL_X       20
// 颜色选择y方向间距
#define COLOR_UNIT_INTERVAL_Y       18

typedef void(^SelectBGColorBlock)(int colorIndex);

@interface BGColorUnitView : UIView {
    int _index;
    SelectBGColorBlock _block;
}

@end

@implementation BGColorUnitView

- (id)initViews:(CGFloat)xOffset yOffset:(CGFloat)yOffset index:(int)index block:(SelectBGColorBlock)block {
    CGRect frame = CGRectMake(xOffset, yOffset, 40, 40);
    
    _index = index;
    _block = block;
    
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    
    return self;
}

- (void)createViews {
    self.backgroundColor = UIColorFromRGB(g_bgColors[_index]);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectUnitTap:)];
    tapGesture.delegate = (id)self;
    [self addGestureRecognizer:tapGesture];
}

#pragma mark -
#pragma mark UITapGestureRecognizer delegate

- (void)selectUnitTap:(UITapGestureRecognizer*)gesture {
    if (_block) {
        _block(_index);
    }
}

@end

@interface BGColorSelectView : UIView {
    SelectBGColorBlock _block;
}

@end

@implementation BGColorSelectView

- (id)initViews:(SelectBGColorBlock)block {
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, 192);
    
    _block = block;
    
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    
    return self;
}

- (void)createViews {
    self.backgroundColor = [UIColor whiteColor];

    CGFloat xOffset = COLOR_UNIT_INTERVAL_X;
    CGFloat yOffset = COLOR_UNIT_INTERVAL_Y;

    // 创建颜色块
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 5; j++) {
            BGColorUnitView *unitView = [[BGColorUnitView alloc] initViews:xOffset yOffset:yOffset index:(i * 5 + j) block:_block];
            
            [self addSubview:unitView];
            
            xOffset += (COLOR_UNIT_INTERVAL_X + 40);
        }
        
        xOffset = COLOR_UNIT_INTERVAL_X;
        yOffset += (COLOR_UNIT_INTERVAL_Y + 40);
    }
}

@end

@interface AccountViewController () {
    UIView *_bgView;
    BGColorSelectView *_bgColorSelectView;
    UILabel *_tipLabel;
    UIImageView *_bgImageView;
    
    BOOL _bShowColorSView;
}

@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)createViews {
    CGFloat offsetY = 0;
    
    // 背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, SCREEN_WIDTH)];
    _bgView.backgroundColor = UIColorFromRGB([UserInfoData shareInstance].userInfo.bgColor);
    [self.contentView addSubview:_bgView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgColorTap:)];
    tapGesture.delegate = (id)self;
    [_bgView addGestureRecognizer:tapGesture];
    
    // 选择性别标签
    offsetY += 20;
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    _tipLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    _tipLabel.textColor = ([UserInfoData shareInstance].userInfo.bgColor == 0xfff991)?UIColorFromRGB(0x485e73):[UIColor whiteColor];
    _tipLabel.text = @"点击切换我的背景";
    [self.contentView addSubview:_tipLabel];
    
    // 用户性别
    offsetY += 70;
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60) / 2, offsetY, 60, 60)];
    if ([UserInfoData shareInstance].userInfo.sex == 1) {
        _bgImageView.image = ([UserInfoData shareInstance].userInfo.bgColor == 0xfff991)?[UIImage imageNamed:@"icon_boy_blue"]:[UIImage imageNamed:@"icon_boy_white"];
    }
    else {
        _bgImageView.image = ([UserInfoData shareInstance].userInfo.bgColor == 0xfff991)?[UIImage imageNamed:@"icon_girl_blue"]:[UIImage imageNamed:@"icon_girl_white"];
    }
    [self.contentView addSubview:_bgImageView];
    
    // 退出登录
    CGRect frame = IOS7?[[UIScreen mainScreen] bounds]:[[UIScreen mainScreen] applicationFrame];
    offsetY = frame.size.height - (IOS7?64:44) - 80;
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogout.frame = CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40);
    [btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_red_normal"] forState:UIControlStateNormal];
    [btnLogout setBackgroundImage:[UIImage imageNamed:@"btn_red_pressed"] forState:UIControlStateHighlighted];
    [btnLogout setTitle:@"退出登录" forState:UIControlStateNormal];
    btnLogout.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnLogout setTitleColor:UIColorFromRGB(TEXT_RED_COLOR) forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(onClickLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnLogout];
    
    // 颜色选择view
    offsetY = frame.size.height - (IOS7?64:44);
    _bgColorSelectView = [[BGColorSelectView alloc] initViews:^(int colorIndex){
        // 改变背景色
        _bgView.backgroundColor = UIColorFromRGB(g_bgColors[colorIndex]);
        [self showBGColorSelectView:NO];
        _bShowColorSView = NO;
        // 修改个人颜色信息
        [UserInfoData shareInstance].userInfo.bgColor = g_bgColors[colorIndex];
        [self changeViewColors];
    }];
    frame = _bgColorSelectView.frame;
    frame.origin.y = offsetY;
    _bgColorSelectView.frame = frame;
    [self.contentView addSubview:_bgColorSelectView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bShowColorSView = NO;
    [self setTitle:@"我"];
    
    [self createViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickLogout {
    // 登出处理???需要登出接口
#if LOCAL_VERSION
    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.navigationController popToRootViewControllerAnimated:YES];
#else
#endif
}

- (void)showBGColorSelectView:(BOOL)bShow {
    if (bShow) {
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -192);
            _bgColorSelectView.transform = trans;
        } completion:^(BOOL finished){
            
        }];
    }
    else {
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 0);
            _bgColorSelectView.transform = trans;
        } completion:^(BOOL finished){
            
        }];
    }
}

#pragma mark -
#pragma mark UITapGestureRecognizer delegate

- (void)bgColorTap:(UITapGestureRecognizer*)gesture {
    _bShowColorSView = !_bShowColorSView;
    [self showBGColorSelectView:_bShowColorSView];
}

- (void)changeViewColors {
    _tipLabel.textColor = ([UserInfoData shareInstance].userInfo.bgColor == 0xfff991)?UIColorFromRGB(0x485e73):[UIColor whiteColor];
    if ([UserInfoData shareInstance].userInfo.sex == 1) {
        _bgImageView.image = ([UserInfoData shareInstance].userInfo.bgColor == 0xfff991)?[UIImage imageNamed:@"icon_boy_blue"]:[UIImage imageNamed:@"icon_boy_white"];
    }
    else {
        _bgImageView.image = ([UserInfoData shareInstance].userInfo.bgColor == 0xfff991)?[UIImage imageNamed:@"icon_girl_blue"]:[UIImage imageNamed:@"icon_girl_white"];
    }
}

@end

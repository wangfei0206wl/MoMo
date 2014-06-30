//
//  MainViewController.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "MainViewController.h"
#import "PublicDefines.h"
#import "AccountViewController.h"
#import "ChatSettingView.h"
#import "IntroduceView.h"
#import "UserMainView.h"
#import "GeneralData.h"
#import "ChatRoomViewController.h"

@interface MainViewController () {
    UIView *_contentScrollView;
    NSMutableArray *_arrMainViews;
    // 别人申请与我聊天的title
    UIView *_passiveTitle;
    // 我邀请别人聊天的title
    UIView *_initiativeTitle;
    // 别人申请与我聊天的bottom view
    UIView *_passiveBottom;
    // 我邀请别人聊天的bottom view
    UIView *_initiativeBottom;
    // 别人申请与我聊天的招乎语
    UILabel *_passiveGreeting;
    // 我邀请别人聊天的招乎语
    UILabel *_initiativeGreeting;
    // 我邀请别人聊天的招乎语输入框
    UITextField *_initiativeGreetingT;
    // 别人申请与聊天的聊天按钮
    UIButton *_passiveChatBtn;
    // 我邀请别人聊天的聊天按钮
    UIButton *_initiativeChatBtn;
    
    NSArray *_matchedUsers;
    NSArray *_requestUsers;
    // 当前页
    int _curPage;
    // 当前页是否为我邀请聊天页面
    BOOL _bInitiativePage;
    // content起始x坐标
    CGFloat _panOriginX;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIView *)createTitle:(BOOL)bApply {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    titleView.backgroundColor = [UIColor clearColor];

    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, SCREEN_WIDTH - 90, 40)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = bApply?@"想和你聊羞羞的小伙伴":@"配给你的羞羞小伙伴";
    [titleView addSubview:tipLabel];

    return titleView;
}

- (UIView *)createBottom:(BOOL)bApply {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64 - SCREEN_WIDTH;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, height + 200)];
    bottomView.backgroundColor = [UIColor clearColor];
    
    // 半透明背景
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height + 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.8;
    [bottomView addSubview:bgView];
    
    CGFloat offsetY = ((height - 148) < 5)?5:(height - 148);
    // 问候语
    if (bApply) {
        // 对方问候语
        _passiveGreeting = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
        _passiveGreeting.backgroundColor = [UIColor clearColor];
        _passiveGreeting.textAlignment = NSTextAlignmentCenter;
        _passiveGreeting.font = [UIFont boldSystemFontOfSize:17.0f];
        _passiveGreeting.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
        [bottomView addSubview:_passiveGreeting];
        
        offsetY += 40;
    }
    else {
        // 我的问候语
        _initiativeGreeting = [[UILabel alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
        _initiativeGreeting.backgroundColor = [UIColor clearColor];
        _initiativeGreeting.textColor = [UIColor lightGrayColor];
        _initiativeGreeting.textAlignment = NSTextAlignmentCenter;
        _initiativeGreeting.font = [UIFont boldSystemFontOfSize:17.0f];
        _initiativeGreeting.text = @"写一句开场白";
        [bottomView addSubview:_initiativeGreeting];
        
        offsetY += IOS7?0:10;
        _initiativeGreetingT = [[UITextField alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40)];
        _initiativeGreetingT.font = [UIFont boldSystemFontOfSize:17.0f];
        _initiativeGreetingT.delegate = (id)self;
        _initiativeGreetingT.keyboardType = UIKeyboardTypeDefault;
        _initiativeGreetingT.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
        _initiativeGreetingT.textAlignment = NSTextAlignmentCenter;
        
        [bottomView addSubview:_initiativeGreetingT];
        offsetY -= IOS7?0:10;
        
        // 底部线
        offsetY += 40;
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x485e73);
        [bottomView addSubview:lineView];
    }
    
    // 聊天按钮
    offsetY += IPHONE5?23:10;
    UIButton *btnChat = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChat.frame = CGRectMake(45, offsetY, SCREEN_WIDTH - 90, 40);
    [btnChat setBackgroundImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
    [btnChat setBackgroundImage:[UIImage imageNamed:@"btn_main_pressed"] forState:UIControlStateHighlighted];
    [btnChat setBackgroundImage:[UIImage imageNamed:@"btn_main_disable"] forState:UIControlStateDisabled];
    [btnChat setTitle:bApply?@"答应ta":@"想和ta聊羞羞" forState:UIControlStateNormal];
    btnChat.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [btnChat setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [btnChat setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateHighlighted];
    [btnChat setTitleColor:UIColorFromRGB(TEXT_DISABLE_COLOR) forState:UIControlStateDisabled];
    [btnChat addTarget:self action:@selector(onClickChat) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btnChat];
    
    if (bApply) {
        _passiveChatBtn = btnChat;
    }
    else {
        _initiativeChatBtn = btnChat;
    }

    return bottomView;
}

- (void)createTitleViews {
    //定制返回按钮
    UIButton *btnAccount = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAccount.frame = CGRectMake(0, 0, 44, 44);
    [btnAccount setImage:[UIImage imageNamed:@"btn_acc_normal"] forState:UIControlStateNormal];
    [btnAccount setImage:[UIImage imageNamed:@"btn_acc_pressed"] forState:UIControlStateHighlighted];
    [btnAccount addTarget:self action:@selector(onClickAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview:btnAccount];
}

- (void)createContentViews {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64;
    
    // 创建主窗口
    _contentScrollView = [[UIView alloc] initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, (2 + _matchedUsers.count + _requestUsers.count) * SCREEN_WIDTH, height)];
    _contentScrollView.clipsToBounds = YES;
    // 添加pan事件
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_contentScrollView addGestureRecognizer:pan];
    
    CGFloat offsetX = 0;
    // 创建各子view
    // 聊天设置页
    ChatSettingView *chatSettingView = [[ChatSettingView alloc] initViews:offsetX];
    [_contentScrollView addSubview:chatSettingView];
    
    // 创建请求聊天人页面
    for (int i = 0; i < _requestUsers.count; i++) {
        offsetX += SCREEN_WIDTH;
        
        UserMainView *mainView = [[UserMainView alloc] initViews:offsetX userInfo:[_requestUsers objectAtIndex:i] isApply:YES greeting:@"你好，可以聊天吗？"];
        [_contentScrollView addSubview:mainView];
        [_arrMainViews addObject:mainView];
    }
    // 创建匹配聊天人页面
    for (int i = 0; i < _matchedUsers.count; i++) {
        offsetX += SCREEN_WIDTH;
        
        UserMainView *mainView = [[UserMainView alloc] initViews:offsetX userInfo:[_matchedUsers objectAtIndex:i] isApply:NO greeting:nil];
        [_contentScrollView addSubview:mainView];
        [_arrMainViews addObject:mainView];
    }
    
    // 说明页
    offsetX += SCREEN_WIDTH;
    IntroduceView *introduceView = [[IntroduceView alloc] initViews:offsetX];
    [_contentScrollView addSubview:introduceView];
    
    [self.contentView addSubview:_contentScrollView];
   
    // 创建聊天上方title view
    if (_requestUsers.count > 0) {
        _passiveTitle = [self createTitle:YES];
        [self.contentView addSubview:_passiveTitle];
    }
    _initiativeTitle = [self createTitle:NO];
    [self.contentView addSubview:_initiativeTitle];
    // 创建聊天下方bottom view
    if (_requestUsers.count > 0) {
        _bInitiativePage = NO;
        _passiveBottom = [self createBottom:YES];
        [self.contentView addSubview:_passiveBottom];
    }
    _initiativeBottom = [self createBottom:NO];
    [self.contentView addSubview:_initiativeBottom];
}

- (void)viewDidLoad {
    self.noBtnBack = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _matchedUsers = [UserInfoData shareInstance].arrUserInfo;
    _requestUsers = [UserInfoData shareInstance].arrRequestUsers;
    _arrMainViews = [[NSMutableArray alloc] init];
    _curPage = 1;
    _bInitiativePage = YES;
    
    [self setTitle:@"羞羞"];
    [self showTitleBk];
    
    [self createTitleViews];
    [self createContentViews];
    
    [self showPassive:@"你好，可以聊天吗？"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapAction:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPassive:(NSString *)greeting {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64 - SCREEN_WIDTH;
    
    _passiveGreeting.text = greeting;
    _passiveTitle.transform = CGAffineTransformMakeTranslation(0, 0);
    _passiveBottom.transform = CGAffineTransformMakeTranslation(0, 0);
    
    // 移出上方边界
    _initiativeTitle.transform = CGAffineTransformMakeTranslation(0, -60);
    // 移出下方边界
    _initiativeBottom.transform = CGAffineTransformMakeTranslation(0, height);
}

- (void)onClickAccount {
    // 跳转到个人用户信息页面
    AccountViewController *controller = [[AccountViewController alloc] init];

    [self presentViewController:controller animated:YES completion:nil];
}

- (void)onClickChat {
    ChatRoomViewController *controller = [[ChatRoomViewController alloc] init];

    [self presentViewController:controller animated:YES completion:nil];
}

-(void)allResign {
    [_initiativeGreetingT resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, 0);
        _initiativeBottom.transform = trans;
    }];
}

#pragma mark-
#pragma mark textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _initiativeGreeting.hidden = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform trans = CGAffineTransformMakeTranslation(0, -(IPHONE5?260:260));
        _initiativeBottom.transform = trans;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        _initiativeGreeting.hidden = NO;
    }
}

- (void)onTapAction:(UITapGestureRecognizer*)gesture {
    if (_bInitiativePage) {
        [self allResign];
    }
}

- (void)pan:(UIPanGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _panOriginX = _contentScrollView.frame.origin.x;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat panX = [gesture translationInView:self.view].x;
        CGFloat offsetX = _panOriginX + panX;
        CGFloat minOffsetX = -SCREEN_WIDTH * (_matchedUsers.count + _requestUsers.count + 1);
        CGFloat maxOffsetX = 0;
        offsetX = (offsetX > maxOffsetX)?maxOffsetX:offsetX;
        offsetX = (offsetX < minOffsetX)?minOffsetX:offsetX;
        
        CGRect frame = _contentScrollView.frame;
        frame.origin.x = offsetX;
        _contentScrollView.frame = frame;
        
        // 此处需要有动画配合
        BOOL bScrollRight = (panX < 0)?YES:NO;
        int offsetRelativeX = abs((int)offsetX) % (int)SCREEN_WIDTH;
        
        [self switchAnimation:bScrollRight page:_curPage offsetX:offsetRelativeX];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled) {
        CGFloat panX = [gesture translationInView:self.view].x;
        __block CGRect frame = _contentScrollView.frame;
        
        if (panX > 0) {
            // 向左翻页
            if (_curPage > 0) {
                _curPage--;
                self.view.userInteractionEnabled = NO;
                frame.origin.x = _panOriginX + SCREEN_WIDTH;
                [UIView animateWithDuration:0.3f animations:^{
                    _contentScrollView.frame = frame;
                    [self switchAnimation:NO page:(_curPage + 1) offsetX:0];
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled = YES;
                }];
            }
        }
        else {
            // 向右翻页
            if(_curPage < (_matchedUsers.count + _requestUsers.count + 1)) {
                _curPage++;
                self.view.userInteractionEnabled = NO;
                frame.origin.x = _panOriginX - SCREEN_WIDTH;
                [UIView animateWithDuration:0.3f animations:^{
                    _contentScrollView.frame = frame;
                    [self switchAnimation:YES page:(_curPage - 1) offsetX:SCREEN_WIDTH];
                } completion:^(BOOL finished) {
                    self.view.userInteractionEnabled = YES;
                }];
            }
        }
        [self initInitiativePage];
    }
}

- (void)initInitiativePage {
    if (_curPage > _requestUsers.count && _curPage < (_requestUsers.count + _matchedUsers.count + 1)) {
        _bInitiativePage = YES;
    }
    else {
        _bInitiativePage = NO;
    }
}

- (void)switchAnimation:(BOOL)bScrollRight page:(int)page offsetX:(int)offsetX {
    page = bScrollRight?(page + 1):(page - 1);
    int type = [self switchType:bScrollRight page:page];
    
    switch (type) {
        case 0:
            if (_requestUsers.count > 0) {
                _passiveTitle.alpha = offsetX / SCREEN_WIDTH;
                _passiveBottom.alpha = offsetX / SCREEN_WIDTH;
            }
            else {
                _initiativeTitle.alpha = offsetX / SCREEN_WIDTH;
                _initiativeBottom.alpha = offsetX / SCREEN_WIDTH;
            }
            break;
        case 1:
            if (_requestUsers.count > 0) {
                _passiveTitle.alpha = offsetX / SCREEN_WIDTH;
                _passiveBottom.alpha = offsetX / SCREEN_WIDTH;
            }
            else {
                _initiativeTitle.alpha = offsetX / SCREEN_WIDTH;
                _initiativeBottom.alpha = offsetX / SCREEN_WIDTH;
            }
            break;
        case 2:
            if ((offsetX - SCREEN_WIDTH / 2) < 0) {
                // 显示左边页的招乎语???
                _passiveGreeting.alpha = fabs(2 * (offsetX - SCREEN_WIDTH / 2) / SCREEN_WIDTH);
            }
            else {
                // 显示右边页的招乎语???
                _passiveGreeting.alpha = 2 * (offsetX - SCREEN_WIDTH / 2) / SCREEN_WIDTH;
            }
            break;
        case 3:
        {
            CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64 - SCREEN_WIDTH;

            if ((offsetX - SCREEN_WIDTH / 2) < 0) {
                _passiveTitle.transform = CGAffineTransformMakeTranslation(0, -60 * 2 * offsetX / SCREEN_WIDTH);
                _passiveBottom.transform = CGAffineTransformMakeTranslation(0, height * 2 * offsetX / SCREEN_WIDTH);
                _passiveTitle.alpha = 1 - 2 * offsetX / SCREEN_WIDTH; _passiveBottom.alpha = 1 - 2 * offsetX / SCREEN_WIDTH;
                
                _initiativeTitle.transform = CGAffineTransformMakeTranslation(0,  - 60);
                _initiativeBottom.transform = CGAffineTransformMakeTranslation(0, height);
                _initiativeTitle.alpha = 0; _initiativeBottom.alpha = 0;
            }
            else {
                _passiveTitle.transform = CGAffineTransformMakeTranslation(0, -60);
                _passiveBottom.transform = CGAffineTransformMakeTranslation(0, height);
                _passiveTitle.alpha = 0; _passiveBottom.alpha = 0;

                _initiativeTitle.transform = CGAffineTransformMakeTranslation(0, 60 * 2 * (offsetX - SCREEN_WIDTH / 2) / SCREEN_WIDTH - 60);
                _initiativeBottom.transform = CGAffineTransformMakeTranslation(0, height - height * 2 * (offsetX - SCREEN_WIDTH / 2) / SCREEN_WIDTH);
                _initiativeTitle.alpha = 2 * (offsetX - SCREEN_WIDTH / 2) / SCREEN_WIDTH; _initiativeBottom.alpha = 2 * (offsetX - SCREEN_WIDTH / 2) / SCREEN_WIDTH;
            }
        }
            break;
        case 4:
            break;
        case 5:
            _initiativeTitle.alpha = 1 - offsetX / SCREEN_WIDTH;
            _initiativeBottom.alpha = 1 - offsetX / SCREEN_WIDTH;
            break;
        case 6:
            _initiativeTitle.alpha = 1 - offsetX / SCREEN_WIDTH;
            _initiativeBottom.alpha = 1 - offsetX / SCREEN_WIDTH;
            break;
    }
}

/*
 页面切换类型
 0:切换到设置页动画(上下内容淡出，中间信息移动)
 1:切换到UserMainView动画(上下内容淡入，中间信息移动)
 2:他人申请与我聊天页面间切换(上下内容不动，中间信息移动，下方打招乎信息淡入淡出)
 3:从他人申请切换到我申请聊天页面动画(上下内容向上向下淡出，新的反之)
 4:我申请聊天页面切换动画(上下内容不动，中间信息移动)
 5:我申请聊天页面切换到介绍页动画(上下内容淡出，中间信息移动)
 6:介绍页切换到我申请聊天页面动画(上下内容淡入，中间信息移动)
 */
- (int)switchType:(BOOL)bScrollRight page:(int)page {
    int result = 0;
    
    if (page == 0 && bScrollRight == NO) {
        result = 0;
    }
    else if (page == 1 && bScrollRight == YES) {
        result = 1;
    }
    else if (page == (_requestUsers.count + 1) && bScrollRight == YES) {
        // 他人申请到我申请页面切换
        result = 3;
    }
    else if (page == _requestUsers.count && bScrollRight == NO) {
        // 我申请到他人申请页面切换
        result = 3;
    }
    else if (page == (_requestUsers.count + _matchedUsers.count + 1) && bScrollRight == YES) {
        result = 5;
    }
    else if (page == (_requestUsers.count + _matchedUsers.count) && bScrollRight == NO) {
        result = 6;
    }
    else if ((page  > 1 && page < _requestUsers.count) ||
             (page == 1 && bScrollRight == NO) ||
             (page == _requestUsers.count && bScrollRight == YES)) {
        result = 2;
    }
    else if ((page > (_requestUsers.count + 1) && page < (_requestUsers.count + _matchedUsers.count)) ||
             (page == (_requestUsers.count + 1) && bScrollRight == NO) ||
             (page == (_requestUsers.count + _matchedUsers.count) && bScrollRight == YES)) {
        result = 4;
    }
    
    return result;
}

@end

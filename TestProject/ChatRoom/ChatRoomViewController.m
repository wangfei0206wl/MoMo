//
//  ChatRoomViewController.m
//  TestProject
//
//  Created by wangfei on 14-5-21.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "QuitMainView.h"
#import "TurntableView.h"
#import "PublicDefines.h"
#import "UtilityTools.h"
#import "ChatRoomTableViewCell.h"
#import "ChatMessageData.h"
#import "UIImage+REFrostedViewController.h"
#import "UIView+REFrostedViewController.h"

@interface ChatRoomViewController () {
    QuitMainView *_quitMainView;
    TurntableView *_turntableView;
    UITableView *_messageTableView;
    UIView *_chatView;
    UIView *_bottomView;
    UITextField *_messageTextField;
    UIButton *_btnSend;
    
    // 聊天消息集合
    NSMutableArray *_arrMessages;
    // 键盘高度
    CGFloat _keyboardHeight;
}

@end

@implementation ChatRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)allResign {
    [_messageTextField resignFirstResponder];
}

- (void)cancelEditing {
    [self allResign];
}

- (void)doneEditing {
    [self allResign];
}

- (void)createBottomView {
    CGFloat offsetY = [[UIScreen mainScreen] bounds].size.height - 64 - 45;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, offsetY, SCREEN_WIDTH, 45)];
    _bottomView.backgroundColor = UIColorFromRGB(0xfbfbfb);
    [_chatView addSubview:_bottomView];
    
    // 创建分隔线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [_bottomView addSubview:lineView];
    
    // 创建输入背景
    UIImageView *bgInput = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 235, 30)];
    bgInput.image = [UIImage imageNamed:@"input"];
    [_bottomView addSubview:bgInput];
    
    // 创建消息输入框
    _messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, 225, 25)];
    _messageTextField.font = [UIFont systemFontOfSize:15.0f];
    _messageTextField.placeholder = @"输入消息";
    _messageTextField.delegate = (id)self;
    _messageTextField.textColor = UIColorFromRGB(TEXT_NORMAL_COLOR);
    _messageTextField.textAlignment = NSTextAlignmentLeft;
    _messageTextField.returnKeyType = UIReturnKeySend;
    [_bottomView addSubview:_messageTextField];
    
    // 发送按钮
    _btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSend.frame = CGRectMake(260, 2, 50, 40);
    [_btnSend setTitle:@"发送" forState:UIControlStateNormal];
    _btnSend.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [_btnSend setTitleColor:UIColorFromRGB(TEXT_NORMAL_COLOR) forState:UIControlStateNormal];
    [_btnSend setTitleColor:UIColorFromRGB(TEXT_DISABLE_COLOR) forState:UIControlStateDisabled];
    [_btnSend addTarget:self action:@selector(onClickSend) forControlEvents:UIControlEventTouchUpInside];
    _btnSend.enabled = NO;
    [_bottomView addSubview:_btnSend];
}

- (void)createMessageTableView {
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - 64 - 45;

    _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _messageTableView.backgroundColor = [UIColor clearColor];
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.delegate = (id)self;
    _messageTableView.dataSource = (id)self;
    
    [_chatView addSubview:_messageTableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTap:)];
    tapGesture.delegate = (id)self;
    [_messageTableView addGestureRecognizer:tapGesture];
}

- (void)createViews {
    _chatView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [[UIScreen mainScreen] bounds].size.height - 64)];
    _chatView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_chatView];
    
    // 创建消息tableview
    [self createMessageTableView];
    // 创建下方发送view
    [self createBottomView];
    
    // 创建转盘view
    _turntableView = [[TurntableView alloc] initViews:0];
    _turntableView.delegate = (id)self;
    [self.contentView addSubview:_turntableView];
    
    // 创建退出提示view
    _quitMainView = [[QuitMainView alloc] initViews];
    _quitMainView.delegate = (id)self;
    [self.contentView addSubview:_quitMainView];
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged) name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"羞羞"];
    [self showTitleBk];
    
    _keyboardHeight = 0.0f;
    _arrMessages = [ChatMessageData shareInstance].arrChatMessages;
    
    [self createViews];
    [self observeKeyboard];
    [_messageTableView reloadData];
    [self scrollToBottom:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];

    [self moveChatContent:keyboardFrame.size.height duration:animationDuration];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [self moveChatContent:0 duration:animationDuration];
}

- (void)moveChatContent:(CGFloat)keyboardHeight duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = _bottomView.frame;
        frame.origin.y = _chatView.frame.size.height - (keyboardHeight + frame.size.height);
        _bottomView.frame = frame;
        frame = _messageTableView.frame;
        frame.size.height = _bottomView.frame.origin.y;
        _messageTableView.frame = frame;
    } completion:^(BOOL finished) {
        [self scrollToBottom:YES];
    }];
}

- (void)textFiledEditChanged {
    if (_messageTextField.text.length > 0) {
        _btnSend.enabled = YES;
    }
    else {
        _btnSend.enabled = NO;
    }
}

- (void)tableViewTap:(UITapGestureRecognizer*)gesture {
    [self allResign];
}

- (void)onClickBack {
    [self allResign];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.btnBack setHidden:YES];
    [_quitMainView setScreenshotImage:[[self.contentView re_screenshot] re_applyBlurWithRadius:10.0f tintColor:[UIColor colorWithWhite:1 alpha:0.75f] saturationDeltaFactor:1.8f maskImage:nil]];
    [_quitMainView showView];
}

- (void)onClickSend {
    NSLog(@"---------onClickSend");
#if LOCAL_VERSION
    [self sendMessage:_messageTextField.text];
#else
#endif
}

- (void)sendMessage:(NSString *)message {
    if (message && message.length > 0) {
        UserInfoItem *receiver = [[UserInfoItem alloc] init];
        receiver.userName = @"张三"; receiver.sex = 1;
        ChatMessageItem *item = [ChatMessageData createTextMessage:message sender:[UserInfoData shareInstance].userInfo receiver:receiver];
        [_arrMessages addObject:item];
        
        [_messageTableView reloadData];
        
        [self scrollToBottom:YES];
        _messageTextField.text = @"";
        _btnSend.enabled = NO;
    }
}

- (void)scrollToBottom:(BOOL)animation {
    [_messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(_arrMessages.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animation];
}

#pragma mark -
#pragma mark QuitMainView Delegate

- (void)QuitMainView:(QuitMainView *)mainView didEndChat:(BOOL)bEnd {
    if (bEnd == NO) {
        [self observeKeyboard];
        [self.btnBack setHidden:NO];
    }
}

- (void)QuitMainView:(QuitMainView *)mainView didEvaluate:(BOOL)bEvaluate {
    [self.btnBack setHidden:NO];
    [_quitMainView setHidden:YES];
    [_quitMainView removeObserver];
    if (bEvaluate) {
        // 提交评价数据????
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TurntableView Delegate

- (void)turntableView:(TurntableView *)turntable sendMessage:(NSString *)message animationStart:(BOOL)bStart {
    [self allResign];
    if (bStart == NO) {
        [self sendMessage:message];
    }
}

#pragma mark -
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessageItem *item = [_arrMessages objectAtIndex:indexPath.row];
    
    return [ChatRoomTableViewCell cellHeight:item.textBody];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return [_arrMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatMessageItem *item = [_arrMessages objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    
    if (item.direction == INCOMING) {
        static NSString *identifier = @"ChatMessageLeftCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[ChatRoomLeftCell alloc] initCellWithMessage:item reuseIdentifier:identifier];
        }
        else {
            [(ChatRoomLeftCell *)cell initViewsWithMessage:item];
        }
    }
    else if (item.direction == OUTGOING) {
        static NSString *identifier = @"ChatMessageRightCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[ChatRoomRightCell alloc] initCellWithMessage:item reuseIdentifier:identifier];
        }
        else {
            [(ChatRoomRightCell *)cell initViewsWithMessage:item];
        }
    }
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self allResign];
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self onClickSend];
    
    return YES;
}

@end

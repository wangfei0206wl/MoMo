//
//  ChatRoomTableViewCell.h
//  TestProject
//
//  Created by wangfei on 14-5-26.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageData.h"

// 聊天cell
@interface ChatRoomTableViewCell : UITableViewCell {
    ChatMessageItem *_messageItem;
}

// 用户头像
@property (nonatomic, retain) UIImageView *headImageView;
// 聊天内容
@property (nonatomic, retain) UILabel *messageLabel;

// 根据message创建cell
- (id)initCellWithMessage:(ChatMessageItem *)item reuseIdentifier:(NSString *)reuseIdentifier;
// 初始化cell
- (void)initViewsWithMessage:(ChatMessageItem *)item;
// 调整cell里ui
- (void)adjustViews;

+ (CGFloat)cellHeight:(NSString *)message;

@end

// 收到消息对应的cell
@interface ChatRoomLeftCell : ChatRoomTableViewCell

@end

// 发送消息对应的cell
@interface ChatRoomRightCell : ChatRoomTableViewCell

@end
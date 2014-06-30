//
//  ChatMessageData.h
//  TestProject
//
//  Created by wangfei on 14-5-26.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralData.h"

// 消息类型
typedef enum Type {
    TYPE_TEXT_MESSAGE = 0,  // 文本消息
    TYPE_VIDEO_MESSAGE,     // 视频消息
    TYPE_AUDIO_MESSAGE,     // 音频消息
    TYPE_NOTIFY_MESSAGE,    // 通知消息
}Type;

// 消息状态
typedef enum Status {
    INVALID,    // 失效
    // status for OUTGOING messages
    DRAFT,
    SENDING,    // 正在发送
    SENT_FAILED,// 发送失败
    SENT,       // 已发送
    SENT_AND_DELIVERD,  // 发送并传递
    SENT_AND_READ,      // 发送并已读
    // Status for INCOMING messages
    RECEIVING,  // 接收中
    RECEIVED,   // 已接收
    READ,       // 已读
}Status;

// 消息方向
typedef enum Direction {
    INCOMING,   // 接收到的消息
    OUTGOING,   // 发送的消息
}Direction;

// 聊天者信息
@interface ChatPeer : NSObject

// 聊天者id
@property (nonatomic, retain) NSString *jid;
// 聊天者姓名
@property (nonatomic, retain) NSString *jname;

@end

// 聊天记录单元(不考虑多人聊天)
@interface ChatMessageItem : NSObject

// 消息id
@property (nonatomic, retain) NSString *messageID;
// 消息类型(只实现文本消息)
@property (nonatomic, assign) Type type;
// 消息状态
@property (nonatomic, assign) Status status;
// 消息方向
@property (nonatomic, assign) Direction direction;
// 消息创建时间
@property (nonatomic, retain) NSString *createTime;
// 消息发送接收时间
@property (nonatomic, retain) NSString *sendReceiveTime;
// 消息更新时间
@property (nonatomic, retain) NSString *updatedTime;
// 文本内容
@property (nonatomic, retain) NSString *textBody;
// 发送者
@property (nonatomic, retain) UserInfoItem *sender;
// 接收者
@property (nonatomic, retain) UserInfoItem *receiver;

@end

// 聊天信息集
@interface ChatMessageData : NSObject

// 与某人聊天集合
@property (nonatomic, retain) NSMutableArray *arrChatMessages;

+ (ChatMessageData *)shareInstance;

+ (ChatMessageItem *)createTextMessage:(NSString *)message sender:(UserInfoItem *)sender receiver:(UserInfoItem *)receiver;

@end

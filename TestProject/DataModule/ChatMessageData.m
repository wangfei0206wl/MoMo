//
//  ChatMessageData.m
//  TestProject
//
//  Created by wangfei on 14-5-26.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ChatMessageData.h"
#import "PublicDefines.h"
#import "UtilityTools.h"
#import "GeneralData.h"

@implementation ChatPeer

@end

@implementation ChatMessageItem

@end

@implementation ChatMessageData

+ (ChatMessageData *)shareInstance {
    static dispatch_once_t onceToken;
    static ChatMessageData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[ChatMessageData alloc] init];
    });
    
    return sSharedInstance;
}

+ (ChatMessageItem *)createTextMessage:(NSString *)message sender:(UserInfoItem *)sender receiver:(UserInfoItem *)receiver {
    ChatMessageItem *item = [[ChatMessageItem alloc] init];
    item.messageID = @"0001";
    item.type = TYPE_TEXT_MESSAGE;
    item.status = RECEIVED;
    item.direction = OUTGOING;
    item.createTime = [UtilityTools getCurrentTimeString];
    item.sendReceiveTime = [UtilityTools getCurrentTimeString];
    item.textBody = message;
    item.sender = sender;
    item.receiver = receiver;
    
    return item;
}

- (void)initDatas {
#if LOCAL_VERSION
    NSMutableArray *arrMessages = [[NSMutableArray alloc] init];
    
    UserInfoItem *userItem = [[UserInfoItem alloc] init];
    userItem.userName = @"张三";
    userItem.sex = 1;
    
    ChatMessageItem *item = [[ChatMessageItem alloc] init];
    item.messageID = @"0001";
    item.type = TYPE_TEXT_MESSAGE;
    item.status = RECEIVED;
    item.direction = INCOMING;
    item.createTime = @"2014-05-22 12:30:30";
    item.sendReceiveTime = @"2014-05-22 12:30:30";
    item.textBody = @"你好，想和聊个天可以吗？你好啊！想和聊个天可以吗？在不在？不在吗？";
    item.sender = userItem;
    item.receiver = [UserInfoData shareInstance].userInfo;
    [arrMessages addObject:item];
 
    item = [[ChatMessageItem alloc] init];
    item.messageID = @"0002";
    item.type = TYPE_TEXT_MESSAGE;
    item.status = RECEIVED;
    item.direction = INCOMING;
    item.createTime = @"2014-05-22 12:35:30";
    item.sendReceiveTime = @"2014-05-22 12:35:30";
    item.textBody = @"在不在？不在吗？";
    item.sender = userItem;
    item.receiver = [UserInfoData shareInstance].userInfo;
    [arrMessages addObject:item];
    
    item = [[ChatMessageItem alloc] init];
    item.messageID = @"0003";
    item.type = TYPE_TEXT_MESSAGE;
    item.status = RECEIVED;
    item.direction = OUTGOING;
    item.createTime = @"2014-05-22 12:37:30";
    item.sendReceiveTime = @"2014-05-22 12:37:30";
    item.textBody = @"什么事？";
    item.sender = [UserInfoData shareInstance].userInfo;
    item.receiver = userItem;
    [arrMessages addObject:item];
    
    item = [[ChatMessageItem alloc] init];
    item.messageID = @"0004";
    item.type = TYPE_TEXT_MESSAGE;
    item.status = RECEIVED;
    item.direction = INCOMING;
    item.createTime = @"2014-05-22 12:35:30";
    item.sendReceiveTime = @"2014-05-22 12:35:30";
    item.textBody = @"你啥时候回家？";
    item.sender = userItem;
    item.receiver = [UserInfoData shareInstance].userInfo;
    [arrMessages addObject:item];

    _arrChatMessages = arrMessages;
#endif
}

- (id)init {
    if (self = [super init]) {
        [self initDatas];
    }
    
    return self;
}

@end

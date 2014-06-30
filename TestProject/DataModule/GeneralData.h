//
//  GeneralData.h
//  TestProject
//
//  Created by wangfei on 14-5-20.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

// 软件更新数据类
@interface AppUpdateData : NSObject

// 0:不需要更新; 1:需要更新
@property (nonatomic, assign) BOOL bNeedUpdate;
// 0:不需要强制更新; 1:需要强制更新
@property (nonatomic, assign) BOOL bEnforce;
// 软件渠道
@property (nonatomic, retain) NSString *pubChannel;
// 产品名称
@property (nonatomic, retain) NSString *appName;
// 版本号
@property (nonatomic, retain) NSString *appVersion;
// 产品描述
@property (nonatomic, retain) NSString *appDesc;
// 下载地址
@property (nonatomic, retain) NSString *downloadUrl;
// 软件包大小(单位:kb)
@property (nonatomic, assign) int fileSize;

@end

// 用户信息类
@interface UserInfoItem : NSObject

// 用户ID
@property (nonatomic,retain) NSString *userID;
// 用户名称
@property (nonatomic, retain) NSString *userName;
// 性别(1:男; 2:女)
@property (nonatomic, assign) int sex;
// 密码
@property (nonatomic, retain) NSString *password;
// 电话号码
@property (nonatomic, retain) NSString *phoneNo;
// 证件号码
@property (nonatomic, retain) NSString *identityNo;
// email
@property (nonatomic, retain) NSString *email;
// app背景色
@property (nonatomic, assign) int bgColor;
// 用户头像地址
@property (nonatomic, retain) NSString *headPicURL;
// 评价值
@property (nonatomic, assign) int evaluationValue;
// 评价内容
@property (nonatomic, retain) NSString *econtent;

- (void)initWithItem:(UserInfoItem *)item;

@end

@interface UserInfoData : NSObject

// 当前用户信息
@property (nonatomic, retain) UserInfoItem *userInfo;
// 给用户匹配其他用户信息集(UserInfoItem类型)
@property (nonatomic, retain) NSArray *arrUserInfo;
// 请求与我聊天的用户信息集
@property (nonatomic, retain) NSArray *arrRequestUsers;

+ (UserInfoData *)shareInstance;

@end


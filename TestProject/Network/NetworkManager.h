//
//  NetworkManager.h
//  TestProject
//
//  Created by wangfei on 14-5-19.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralData.h"

// 检查app更新block
typedef void(^AppUpdateBlock)(AppUpdateData *appUpdateData, NSInteger errorCode, NSString *errorDesc);

// 用户注册block
typedef void(^RegisterBlock)(UserInfoItem *userInfo, NSInteger errorCode, NSString *errorDesc);

// 用户信息修改block
typedef void(^UserModifyBlock)(BOOL bSuccess, NSInteger errorCode, NSString *errorDesc);

// 登录block(返回的arrUserInfo为UserInfoData数组，第一项为登录用户信息，后面项为给此用户匹配的其他用户)
typedef void(^LoginBlock)(NSArray *arrUserInfo, NSInteger errorCode, NSString *errorDesc);

// 请求聊天对象block
typedef void(^GetUserListBlock)(NSArray *arrUserInfo, NSInteger errorCode, NSString *errorDesc);

// 发布评价block
typedef void(^EvaluateBlock)(BOOL bSuccess, NSInteger errorCode, NSString *errorDesc);

// 用户信息查询block
typedef void(^QueryUserInfoBlock)(UserInfoItem *userInfo, NSInteger errorCode, NSString *errorDesc);

// 密码修改block
typedef void(^ChangePwdBlock)(BOOL bSuccess, NSInteger errorCode, NSString *errorDesc);

// 忘记密码block
typedef void(^ForgetPwdBlock)(BOOL bSuccess, NSInteger errorCode, NSString *errorDesc);

// 上传头像block
typedef void(^UploadPicBlock)(BOOL bSuccess, NSInteger errorCode, NSString *errorDesc);

// 用户反馈block
typedef void(^FeedbackBlock)(BOOL bSuccess, NSInteger errorCode, NSString *errorDesc);


@interface NetworkManager : NSObject

// 检查app更新block
@property (copy) AppUpdateBlock appUpdateCallBack;
// 用户注册block
@property (copy) RegisterBlock registerCallBack;
// 用户信息修改block
@property (copy) UserModifyBlock userModifyBlock;
// 登录block
@property (copy) LoginBlock loginBlock;
// 请求聊天对象block
@property (copy) GetUserListBlock getUserListBlock;
// 发布评价block
@property (copy) EvaluateBlock evaluateBlock;
// 用户信息查询block
@property (copy) QueryUserInfoBlock queryUIBlock;
// 密码修改block
@property (copy) ChangePwdBlock changePwdBlock;
// 忘记密码block
@property (copy) ForgetPwdBlock forgetPwdBlock;
// 上传头像block
@property (copy) UploadPicBlock uploadPicBlock;
// 用户反馈block
@property (copy) FeedbackBlock feedbackBlock;

+ (NetworkManager *)getInstance;

// 检查app更新
- (void)asychronousAppUpdate;

// 用户注册
- (void)asychronousRegister:(UserInfoItem *)userInfo;

// 用户信息修改
- (void)asychronousUserInfoModify:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor;

// 登录(bList为YES时，为需要用户列表)
- (void)asychronousLogin:(NSString *)userName password:(NSString *)password isList:(BOOL)bList;

// 请求聊天对象
- (void)asychronousGetUserList:(NSString *)userID;

// 发布评价
- (void)asychronousEvaluate:(NSString *)userID evaluatedUser:(NSString *)evaluatedID level:(int)level eContent:(NSString *)eContent;

// 用户信息查询
- (void)asychronousQueryUserInfo:(NSString *)userID queriedUser:(NSString *)queriedID;

// 密码修改
- (void)asychronousModifyPwd:(NSString *)userID oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd;

// 忘记密码
- (void)asychronousForgetPwd:(NSString *)userName;

// 上传头像
- (void)asychronousUploadPic:(NSString *)userID picPath:(NSString *)filePath;

// 用户反馈
- (void)asychronousFeedback:(NSString *)userID content:(NSString *)content;

@end

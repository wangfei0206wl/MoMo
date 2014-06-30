//
//  ParserManager.h
//  TestProject
//
//  Created by wangfei on 14-5-19.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralData.h"

@interface ParserManager : NSObject

// 错误描述
@property (nonatomic, retain) NSString *errorMessage;
// 错误代码
@property (nonatomic, assign) int errorCode;

// 应用更新response解析
- (AppUpdateData *)parseAppUpdateResponse:(NSString *)response;

// 注册response解析
- (UserInfoItem *)parseRegisterResponse:(NSString *)response;

// 用户信息修改response解析
- (BOOL)parseUserModifyResponse:(NSString *)response;

// 登录response解析
- (NSArray *)parseLoginResponse:(NSString *)response;

// 请求聊天对象response解析
- (NSArray *)parseUserListResponse:(NSString *)response;

// 发布评价response解析
- (BOOL)parseEvaluateResponse:(NSString *)response;

// 用户信息查询response解析
- (UserInfoItem *)parseUserInfoResponse:(NSString *)response;

// 密码修改response解析
- (BOOL)parseModifyPwdResponse:(NSString *)response;

// 忘记密码response解析
- (BOOL)parseForgetPwdResponse:(NSString *)response;

// 上传头像response解析
- (BOOL)parseUploadPicResponse:(NSString *)response;

// 用户反馈response解析
- (BOOL)parseFeedbackResponse:(NSString *)response;


// 应用更新请求json串
+ (NSString *)appUpdateReqString;
// 注册请求json串
+ (NSString *)registerReqString:(UserInfoItem *)userInfo;
// 用户信息修改请求json串
+ (NSString *)userModifyReqString:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor;
// 登录请求json串
+ (NSString *)loginReqString:(NSString *)userName password:(NSString *)password isList:(BOOL)bList;
// 请求聊天对象json串
+ (NSString *)userListReqString:(NSString *)userID;
// 评价请求json串
+ (NSString *)evaluationReqString:(NSString *)userID evaluatedUser:(NSString *)evaluatedUser level:(int)level eContent:(NSString *)eContent;
// 用户信息查询json串
+ (NSString *)userInfoReqString:(NSString *)userID destID:(NSString *)destID;
// 密码修改json串
+ (NSString *)modifyPwdReqString:(NSString *)userID srcPwd:(NSString *)srcPwd newPwd:(NSString *)newPwd;
// 忘记密码json串
+ (NSString *)forgetPwdReqString:(NSString *)userName;
// 用户反馈json串
+ (NSString *)feedbackReqString:(NSString *)userID appVerson:(NSString *)appVerson content:(NSString *)content;

// 应用更新请求json串
+ (NSDictionary *)appUpdateReqParams;
// 注册请求json串
+ (NSDictionary *)registerReqParams:(UserInfoItem *)userInfo;
// 用户信息修改请求json串
+ (NSDictionary *)userModifyReqParams:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor;
// 登录请求json串
+ (NSDictionary *)loginReqParams:(NSString *)userName password:(NSString *)password isList:(BOOL)bList;
// 请求聊天对象json串
+ (NSDictionary *)userListReqParams:(NSString *)userID;
// 评价请求json串
+ (NSDictionary *)evaluationReqParams:(NSString *)userID evaluatedUser:(NSString *)evaluatedUser level:(int)level eContent:(NSString *)eContent;
// 用户信息查询json串
+ (NSDictionary *)userInfoReqParams:(NSString *)userID destID:(NSString *)destID;
// 密码修改json串
+ (NSDictionary *)modifyPwdReqParams:(NSString *)userID srcPwd:(NSString *)srcPwd newPwd:(NSString *)newPwd;
// 忘记密码json串
+ (NSDictionary *)forgetPwdReqParams:(NSString *)userName;
// 用户反馈json串
+ (NSDictionary *)feedbackReqParams:(NSString *)userID appVerson:(NSString *)appVerson content:(NSString *)content;

@end

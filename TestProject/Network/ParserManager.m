//
//  ParserManager.m
//  TestProject
//
//  Created by wangfei on 14-5-19.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "ParserManager.h"
#import "JSONKit.h"
#import "UrlStringResource.h"
#import "NSMutableDictionary+NullObject.h"

// 应用名称
#define kAppName                    @"proname"
// 应用版本号
#define kAppVersion                 @"prover"
// 应用发布日期
#define kPublishDate                @"pubdate"
// 发布渠道
#define kAppChannel                 @"channel"

// 用户名称
#define kUserName                   @"username"
// 性别
#define kUserGender                 @"sex"
// 密码
#define kPassword                   @"password"
// 电话号码
#define kPhoneNo                    @"phone"
// 证件号码
#define kIndentityNo                @"idnumber"
// 电子邮件
#define kEmail                      @"email"

// 用户id
#define kUserID                     @"uid"
// 背景颜色
#define kBGColor                    @"bgcolor"

// 是否需要用户列表
#define kISList                     @"islist"

// 发布评价用户id
#define kPubUserID                  @"pubuid"
// 被评价用户id
#define kEvaluatedUserID            @"evaluateduid"
// 评价详情
#define kEvaluatedDetail            @"evaluatedetail"
// 评价星级
#define kEvaluationLevel            @"num"
// 评价内容
#define kEvaluatedContent           @"content"

// 被查询用户id
#define kQueriedUserID              @"querieduid"

// 旧密码
#define kSrcPassword                @"psw"
// 新密码
#define kNewPassword                @"newpsw"

// 应用版本号
#define kAppVer                     @"appver"
// 反馈信息
#define kFeedbackContent            @"content"

@implementation ParserManager

- (id)generalParse:(NSString *)response {
    id data = nil;
    
    if (response) {
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dicResult = [jsonData objectFromJSONData];
        if (dicResult) {
            int status = [[dicResult objectForKey:kResponseStatus] intValue];
            if (status == 0) {
                _errorCode = 0;
                data = [dicResult objectForKey:kResponseData];
            }
            else {
                _errorCode = status;
                _errorMessage = [dicResult objectForKey:kResponseData];
            }
        }
    }
    
    return data;
}

- (AppUpdateData *)parseAppUpdateResponse:(NSString *)response {
    AppUpdateData *appUpdateData = nil;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        appUpdateData = [[AppUpdateData alloc] init];
        appUpdateData.bNeedUpdate = [[dicData objectForKey:@"needupdate"] boolValue];
        appUpdateData.bEnforce = [[dicData objectForKey:@"enforce"] boolValue];
        appUpdateData.pubChannel = [dicData objectForKey:@"channel"];
        appUpdateData.appName = [dicData objectForKey:@"proname"];
        appUpdateData.appVersion = [dicData objectForKey:@"prover"];
        appUpdateData.appDesc = [dicData objectForKey:@"desc"];
        appUpdateData.downloadUrl = [dicData objectForKey:@"downloadurl"];
        appUpdateData.fileSize = [[dicData objectForKey:@"filesize"] intValue];
    }
    
    return appUpdateData;
}

- (UserInfoItem *)parseRegisterResponse:(NSString *)response {
    UserInfoItem *item = nil;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        item = [[UserInfoItem alloc] init];
        item.userID = [dicData objectForKey:@"uid"];
        item.userName = [dicData objectForKey:@"username"];
        item.sex = [[dicData objectForKey:@"sex"] intValue];
        item.phoneNo = [dicData objectForKey:@"phone"];
    }
    
    return item;
}

- (BOOL)parseUserModifyResponse:(NSString *)response {
    BOOL bRet = NO;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        bRet = (_errorCode == 0)?YES:NO;
    }
    
    return bRet;
}

- (NSArray *)parseLoginResponse:(NSString *)response {
    NSMutableArray *arrUserInfo = nil;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        arrUserInfo = [[NSMutableArray alloc] init];
        
        UserInfoItem *item = [[UserInfoItem alloc] init];
        item.userID = [dicData objectForKey:@"uid"];
        item.userName = [dicData objectForKey:@"username"];
        item.sex = [[dicData objectForKey:@"sex"] intValue];
        item.phoneNo = [dicData objectForKey:@"phone"];
        item.bgColor = [[dicData objectForKey:@"picurl"] intValue];
        [arrUserInfo addObject:item];
        
        NSArray *arrData = [dicData objectForKey:@"userlist"];
        for (NSDictionary *dicSrc in arrData) {
            item = [[UserInfoItem alloc] init];
            item.userID = [dicSrc objectForKey:@"uid"];
            item.userName = [dicSrc objectForKey:@"username"];
            item.sex = [[dicSrc objectForKey:@"sex"] intValue];
            item.phoneNo = [dicSrc objectForKey:@"phone"];
            item.bgColor = [[dicSrc objectForKey:@"picurl"] intValue];
            item.evaluationValue = [[dicSrc objectForKey:@"evaluationvalue"] intValue];
            item.econtent = [dicSrc objectForKey:@"econtent"];
            [arrUserInfo addObject:item];
        }
    }
    
    return arrUserInfo;
}

- (NSArray *)parseUserListResponse:(NSString *)response {
    NSMutableArray *arrUserInfo = nil;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        arrUserInfo = [[NSMutableArray alloc] init];
        
        UserInfoItem *item = [[UserInfoItem alloc] init];
        item.userID = [dicData objectForKey:@"uid"];
        item.userName = [dicData objectForKey:@"username"];
        item.sex = [[dicData objectForKey:@"sex"] intValue];
        item.phoneNo = [dicData objectForKey:@"phone"];
        item.bgColor = [[dicData objectForKey:@"picurl"] intValue];
        [arrUserInfo addObject:item];
        
        NSArray *arrData = [dicData objectForKey:@"userlist"];
        for (NSDictionary *dicSrc in arrData) {
            item = [[UserInfoItem alloc] init];
            item.userID = [dicSrc objectForKey:@"uid"];
            item.userName = [dicSrc objectForKey:@"username"];
            item.sex = [[dicSrc objectForKey:@"sex"] intValue];
            item.phoneNo = [dicSrc objectForKey:@"phone"];
            item.bgColor = [[dicSrc objectForKey:@"picurl"] intValue];
            item.evaluationValue = [[dicSrc objectForKey:@"evaluationvalue"] intValue];
            item.econtent = [dicSrc objectForKey:@"econtent"];
            [arrUserInfo addObject:item];
        }
    }
    
    return arrUserInfo;
}

- (BOOL)parseEvaluateResponse:(NSString *)response {
    BOOL bRet = NO;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        bRet = (_errorCode == 0)?YES:NO;
    }
    
    return bRet;
}

- (UserInfoItem *)parseUserInfoResponse:(NSString *)response {
    UserInfoItem *item = nil;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        item = [[UserInfoItem alloc] init];
        item.userName = [dicData objectForKey:@"username"];
        item.sex = [[dicData objectForKey:@"sex"] intValue];
        item.phoneNo = [dicData objectForKey:@"phone"];
        item.bgColor = [[dicData objectForKey:@"picurl"] intValue];
        item.evaluationValue = [[dicData objectForKey:@"evaluatevalue"] intValue];
        item.email = [dicData objectForKey:@"email"];
        item.identityNo = [dicData objectForKey:@"idnum"];
    }
    
    return item;
}

- (BOOL)parseModifyPwdResponse:(NSString *)response {
    BOOL bRet = NO;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        bRet = (_errorCode == 0)?YES:NO;
    }
    
    return bRet;
}

- (BOOL)parseForgetPwdResponse:(NSString *)response {
    BOOL bRet = NO;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        bRet = (_errorCode == 0)?YES:NO;
    }
    
    return bRet;
}

- (BOOL)parseUploadPicResponse:(NSString *)response {
    BOOL bRet = NO;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        bRet = (_errorCode == 0)?YES:NO;
        NSString *userID = [dicData objectForKey:@"uid"];
        NSString *picUrl = [dicData objectForKey:@"picurl"];
        
        NSLog(@"userID=%@, picUrl=%@", userID, picUrl);
    }

    return bRet;
}

- (BOOL)parseFeedbackResponse:(NSString *)response {
    BOOL bRet = NO;
    NSDictionary *dicData = [self generalParse:response];
    
    if (dicData) {
        bRet = (_errorCode == 0)?YES:NO;
    }
    
    return bRet;
}

+ (NSString *)appUpdateReqString {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager appUpdateReqParams];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)registerReqString:(UserInfoItem *)userInfo {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager registerReqParams:userInfo];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)userModifyReqString:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager userModifyReqParams:userID phoneNo:phoneNo bgColor:bgColor];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)loginReqString:(NSString *)userName password:(NSString *)password isList:(BOOL)bList {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager loginReqParams:userName password:password isList:bList];

    reqString = [dicReq JSONString];

    return reqString;
}

+ (NSString *)userListReqString:(NSString *)userID {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager userListReqParams:userID];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)evaluationReqString:(NSString *)userID evaluatedUser:(NSString *)evaluatedUser level:(int)level eContent:(NSString *)eContent {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager evaluationReqParams:userID evaluatedUser:evaluatedUser level:level eContent:eContent];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)userInfoReqString:(NSString *)userID destID:(NSString *)destID {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager userInfoReqParams:userID destID:destID];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)modifyPwdReqString:(NSString *)userID srcPwd:(NSString *)srcPwd newPwd:(NSString *)newPwd {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager modifyPwdReqParams:userID srcPwd:srcPwd newPwd:newPwd];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)forgetPwdReqString:(NSString *)userName {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager forgetPwdReqParams:userName];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSString *)feedbackReqString:(NSString *)userID appVerson:(NSString *)appVerson content:(NSString *)content {
    NSString *reqString = nil;
    NSDictionary *dicReq = [ParserManager feedbackReqParams:userID appVerson:appVerson content:content];
    
    reqString = [dicReq JSONString];
    
    return reqString;
}

+ (NSDictionary *)appUpdateReqParams {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    // app名称
    [dicReq setObject:@"xiuxiu_ios" forKey:kAppName];
    // 应用版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [dicReq setObject:version forKey:kAppVersion];
    // 应用发布日期
    [dicReq setObject:@"20140520101000" forKey:kPublishDate];
    // 发布渠道
    [dicReq setObject:@"appStore" forKey:kAppChannel];

    return dicReq;
}

+ (NSDictionary *)registerReqParams:(UserInfoItem *)userInfo {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userInfo.userName forKey:kUserName];
    [dicReq setObject:[[NSNumber alloc] initWithInt:userInfo.sex] forKey:kUserGender];
    [dicReq setObject:userInfo.password forKey:kPassword];
    [dicReq setNullObject:userInfo.phoneNo forKey:kPhoneNo];
    [dicReq setNullObject:userInfo.identityNo forKey:kIndentityNo];
    [dicReq setNullObject:userInfo.email forKey:kEmail];

    return dicReq;
}

+ (NSDictionary *)userModifyReqParams:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userID forKey:kUserID];
    [dicReq setObject:phoneNo forKey:kPhoneNo];
    [dicReq setObject:[[NSNumber alloc] initWithInt:bgColor] forKey:kBGColor];

    return dicReq;
}

+ (NSDictionary *)loginReqParams:(NSString *)userName password:(NSString *)password isList:(BOOL)bList {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userName forKey:kUserName];
    [dicReq setObject:password forKey:kPassword];
    [dicReq setObject:[[NSNumber alloc] initWithBool:bList] forKey:kISList];

    return dicReq;
}

+ (NSDictionary *)userListReqParams:(NSString *)userID {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userID forKey:kUserID];

    return dicReq;
}

+ (NSDictionary *)evaluationReqParams:(NSString *)userID evaluatedUser:(NSString *)evaluatedUser level:(int)level eContent:(NSString *)eContent {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userID forKey:kPubUserID];
    [dicReq setObject:evaluatedUser forKey:kEvaluatedUserID];
    
    NSMutableDictionary *dicDetail = [[NSMutableDictionary alloc] init];
    [dicReq setObject:[[NSNumber alloc] initWithInt:level] forKey:kEvaluationLevel];
    [dicReq setObject:eContent forKey:kEvaluatedContent];
    
    [dicReq setObject:dicDetail forKey:kEvaluatedDetail];

    return dicReq;
}

+ (NSDictionary *)userInfoReqParams:(NSString *)userID destID:(NSString *)destID {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userID forKey:kUserID];
    [dicReq setObject:destID forKey:kQueriedUserID];

    return dicReq;
}

+ (NSDictionary *)modifyPwdReqParams:(NSString *)userID srcPwd:(NSString *)srcPwd newPwd:(NSString *)newPwd {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userID forKey:kUserID];
    [dicReq setObject:srcPwd forKey:kSrcPassword];
    [dicReq setObject:newPwd forKey:kNewPassword];

    return dicReq;
}

+ (NSDictionary *)forgetPwdReqParams:(NSString *)userName {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userName forKey:kUserName];

    return dicReq;
}

+ (NSDictionary *)feedbackReqParams:(NSString *)userID appVerson:(NSString *)appVerson content:(NSString *)content {
    NSMutableDictionary *dicReq = [[NSMutableDictionary alloc] init];
    
    [dicReq setObject:userID forKey:kUserID];
    [dicReq setObject:appVerson forKey:kAppVer];
    [dicReq setObject:content forKey:kFeedbackContent];

    return dicReq;
}

@end

//
//  NetworkManager.m
//  TestProject
//
//  Created by wangfei on 14-5-19.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "NetworkManager.h"
#import "UrlStringResource.h"
#import "ParserManager.h"
#import "AFNetworking.h"
#import "UtilityTools.h"

@implementation NetworkManager

+ (NetworkManager *)getInstance {
    static dispatch_once_t onceToken;
    static NetworkManager *sSharedInstance;

    dispatch_once(&onceToken, ^{
        sSharedInstance = [[NetworkManager alloc] init];
    });
    
    return sSharedInstance;
}

- (NSString *)appUpdateURL {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_APP_UPDATE];
    
    return urlString;
}

- (NSString *)registerURL:(UserInfoItem *)userInfo {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_USER_REGISTER];
    
    return urlString;
}

- (NSString *)userModifyURL:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_USER_MODIFY];
    
    return urlString;
}

- (NSString *)loginURL:(NSString *)userName password:(NSString *)password isList:(BOOL)bList {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_USER_LOGIN];
    
    return urlString;
}

- (NSString *)getUserListURL:(NSString *)userID {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_USER_LIST];
    
    return urlString;
}

- (NSString *)evaluateURL:(NSString *)userID evaluatedUser:(NSString *)evaluatedID level:(int)level eContent:(NSString *)eContent {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_USER_EVALUATION];
    
    return urlString;
}

- (NSString *)userInfoURL:(NSString *)userID queriedUser:(NSString *)queriedID {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_USER_QUERY];
    
    return urlString;
}

- (NSString *)modifyPwdURL:(NSString *)userID oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_CHANGE_PWD];
    
    return urlString;
}

- (NSString *)forgetPwdURL:(NSString *)userName {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_FORGET_PWD];
    
    return urlString;
}

- (NSString *)uploadPicURL:(NSString *)userID picPath:(NSString *)filePath {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_UPLOAD_USERHAED];

    return urlString;
}

- (NSString *)feedbackURL:(NSString *)userID content:(NSString *)content {
    NSMutableString *urlString = [[NSMutableString alloc] init];
    
    // 拼接基地址
    [urlString appendFormat:@"%@%@", URL_SERVER_BASEADDR, URL_UPLOAD_FEEDBACK];
    
    return urlString;
}

- (void)asychronousAppUpdate {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self appUpdateURL]
       parameters:[ParserManager appUpdateReqParams]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ParserManager *parser = [[ParserManager alloc] init];
        AppUpdateData *updateData = [parser parseAppUpdateResponse:responseObject];
        if(_appUpdateCallBack) {
            if (updateData) {
                _appUpdateCallBack(updateData, operation.response.statusCode, nil);
            }
            else {
                _appUpdateCallBack(nil, parser.errorCode, parser.errorMessage);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_appUpdateCallBack) {
            _appUpdateCallBack(nil, operation.response.statusCode, nil);
        }
    }];
}

- (void)asychronousRegister:(UserInfoItem *)userInfo {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self registerURL:userInfo]
       parameters:[ParserManager registerReqParams:userInfo]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ParserManager *parser = [[ParserManager alloc] init];
        UserInfoItem *item = [parser parseRegisterResponse:responseObject];
        if(_registerCallBack) {
            if (item) {
                _registerCallBack(item, operation.response.statusCode, nil);
            }
            else {
                _registerCallBack(nil, parser.errorCode, parser.errorMessage);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_registerCallBack) {
            _registerCallBack(nil, operation.response.statusCode, nil);
        }
    }];
}

- (void)asychronousUserInfoModify:(NSString *)userID phoneNo:(NSString *)phoneNo bgColor:(int)bgColor {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self userModifyURL:userID phoneNo:phoneNo bgColor:bgColor]
       parameters:[ParserManager userModifyReqParams:userID phoneNo:phoneNo bgColor:bgColor]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ParserManager *parser = [[ParserManager alloc] init];
        BOOL bRet = [parser parseUserModifyResponse:responseObject];
        if(_userModifyBlock) {
            if (bRet) {
                _userModifyBlock(YES, operation.response.statusCode, nil);
            }
            else {
                _userModifyBlock(NO, parser.errorCode, parser.errorMessage);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_userModifyBlock) {
            _userModifyBlock(NO, operation.response.statusCode, nil);
        }
    }];
}

- (void)asychronousLogin:(NSString *)userName password:(NSString *)password isList:(BOOL)bList {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:[self loginURL:userName password:password isList:bList]
       parameters:[ParserManager loginReqParams:userName password:password isList:bList]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              NSArray *arrUserInfo = [parser parseLoginResponse:responseObject];
              if(_loginBlock) {
                  if (arrUserInfo) {
                      _loginBlock(arrUserInfo, operation.response.statusCode, nil);
                  }
                  else {
                      _loginBlock(nil, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_loginBlock) {
                  _loginBlock(nil, operation.response.statusCode, nil);
              }
          }];
}

- (void)asychronousGetUserList:(NSString *)userID {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self getUserListURL:userID]
       parameters:[ParserManager userListReqParams:userID]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              NSArray *arrUserInfo = [parser parseUserListResponse:responseObject];
              if(_getUserListBlock) {
                  if (arrUserInfo) {
                      _getUserListBlock(arrUserInfo, operation.response.statusCode, nil);
                  }
                  else {
                      _getUserListBlock(nil, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_getUserListBlock) {
                  _getUserListBlock(nil, operation.response.statusCode, nil);
              }
          }];
}

- (void)asychronousEvaluate:(NSString *)userID evaluatedUser:(NSString *)evaluatedID level:(int)level eContent:(NSString *)eContent {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self evaluateURL:userID evaluatedUser:evaluatedID level:level eContent:eContent]
       parameters:[ParserManager evaluationReqParams:userID evaluatedUser:evaluatedID level:level eContent:eContent]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              BOOL bRet = [parser parseEvaluateResponse:responseObject];
              if(_evaluateBlock) {
                  if (bRet) {
                      _evaluateBlock(YES, operation.response.statusCode, nil);
                  }
                  else {
                      _evaluateBlock(NO, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_evaluateBlock) {
                  _evaluateBlock(NO, operation.response.statusCode, nil);
              }
          }];
}

- (void)asychronousQueryUserInfo:(NSString *)userID queriedUser:(NSString *)queriedID {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self userInfoURL:userID queriedUser:queriedID]
       parameters:[ParserManager userInfoReqParams:userID destID:queriedID]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              UserInfoItem *item = [parser parseUserInfoResponse:responseObject];
              if(_queryUIBlock) {
                  if (item) {
                      _queryUIBlock(item, operation.response.statusCode, nil);
                  }
                  else {
                      _queryUIBlock(nil, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_queryUIBlock) {
                  _queryUIBlock(nil, operation.response.statusCode, nil);
              }
          }];
}

- (void)asychronousModifyPwd:(NSString *)userID oldPwd:(NSString *)oldPwd newPwd:(NSString *)newPwd {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self modifyPwdURL:userID oldPwd:oldPwd newPwd:newPwd]
       parameters:[ParserManager modifyPwdReqParams:userID srcPwd:[UtilityTools md5:oldPwd] newPwd:[UtilityTools md5:newPwd]]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              BOOL bRet = [parser parseModifyPwdResponse:responseObject];
              if(_changePwdBlock) {
                  if (bRet) {
                      _changePwdBlock(YES, operation.response.statusCode, nil);
                  }
                  else {
                      _changePwdBlock(NO, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_changePwdBlock) {
                  _changePwdBlock(NO, operation.response.statusCode, nil);
              }
          }];
}

- (void)asychronousForgetPwd:(NSString *)userName {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[self forgetPwdURL:userName]
       parameters:[ParserManager forgetPwdReqParams:userName]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              BOOL bRet = [parser parseForgetPwdResponse:responseObject];
              if(_forgetPwdBlock) {
                  if (bRet) {
                      _forgetPwdBlock(YES, operation.response.statusCode, nil);
                  }
                  else {
                      _forgetPwdBlock(NO, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_forgetPwdBlock) {
                  _forgetPwdBlock(NO, operation.response.statusCode, nil);
              }
          }];
}

- (void)asychronousUploadPic:(NSString *)userID picPath:(NSString *)filePath {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *url =[NSURL URLWithString:[self uploadPicURL:userID picPath:filePath]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:fileURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            if (_uploadPicBlock) {
                _uploadPicBlock(NO, 400, nil);
            }
        }
        else {
            ParserManager *parser = [[ParserManager alloc] init];
            BOOL bRet = [parser parseUploadPicResponse:responseObject];
            if (_uploadPicBlock) {
                if (bRet) {
                    _feedbackBlock(YES, 200, nil);
                }
                else {
                    _feedbackBlock(NO, parser.errorCode, parser.errorMessage);
                }
            }
        }
    }];
    
    [uploadTask resume];
}

- (void)asychronousFeedback:(NSString *)userID content:(NSString *)content {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 拼接请求串
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];

    [manager POST:[self feedbackURL:userID content:content]
       parameters:[ParserManager feedbackReqParams:userID appVerson:version content:content]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              ParserManager *parser = [[ParserManager alloc] init];
              BOOL bRet = [parser parseFeedbackResponse:responseObject];
              if(_feedbackBlock) {
                  if (bRet) {
                      _feedbackBlock(YES, operation.response.statusCode, nil);
                  }
                  else {
                      _feedbackBlock(NO, parser.errorCode, parser.errorMessage);
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (_feedbackBlock) {
                  _feedbackBlock(NO, operation.response.statusCode, nil);
              }
          }];
}

@end

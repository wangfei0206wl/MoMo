/*!
 @header UrlStringResource.h
 @abstract 各业务的url定义
 @author fei.wang
 @version 1.0
 */

#ifndef UrlStringResource_h
#define UrlStringResource_h

// 网络超时秒数
#define MAX_NETWORK_TIMEOUT         30

// 服务器基地址
#define URL_SERVER_BASEADDR         @"http://ip:port/xiuxiu/index.php?"

// 检查更新接口
#define URL_APP_UPDATE              @"appupdate"
// 用户注册接口
#define URL_USER_REGISTER           @"register"
// 用户信息修改接口
#define URL_USER_MODIFY             @"usermodify"
// 登录接口
#define URL_USER_LOGIN              @"login"
// 请求聊天对象接口
#define URL_USER_LIST               @"getuserlist"
// 发布评价接口
#define URL_USER_EVALUATION         @"evaluation"
// 用户信息查询接口
#define URL_USER_QUERY              @"userinfo"
// 密码修改接口
#define URL_CHANGE_PWD              @"changepsw"
// 忘记密码接口
#define URL_FORGET_PWD              @"setpsw"
// 上传头像接口
#define URL_UPLOAD_USERHAED         @"uploadpic"
// 用户反馈接口
#define URL_UPLOAD_FEEDBACK         @"feedback"
//

// 返回的统一参数
// 返回状态
#define kResponseStatus             @"status"
// 返回的数据字典
#define kResponseData               @"res"

// 统一错误码定义
// 缺少参数,请检查
#define ERROR_LACK_PARAM            101
// 无结果集
#define ERROR_NONE_RESULT           102
// 查询出错
#define ERROR_QUERY_EXCEPTION       103
// 非定义参数，请检查
#define ERROR_UNDEFINED_PARAM       104
// 存入数据库出错
#define ERROR_STOREDB_FAILURE       106
// 数据库连接失败
#define ERROR_CONNECTDB_FAILURE     201
// 此用户名已存在
#define ERROR_USER_EXIST            301
// 注册失败请重试
#define ERROR_REGISTER_FAILURE      302
// 两次输入新密码不一致，请重新输入
#define ERROR_PWD_INCONSISTENT      303
// 您的旧密码输入有误，请重新输入
#define ERROR_OLDPWD_ERROR          304
// 更新密码失败，或新密码与旧密码一样，请重新输入
#define ERROR_PWDUPDATE_FAILURE     305
// 您输入的帐号信息有误，请重新输入
#define ERROR_ACCOUNT_ERROR         306

#endif

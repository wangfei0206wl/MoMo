//
//  GeneralData.m
//  TestProject
//
//  Created by wangfei on 14-5-20.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#import "GeneralData.h"
#import "PublicDefines.h"

@implementation AppUpdateData

@end

@implementation UserInfoItem

- (void)initWithItem:(UserInfoItem *)item {
    if (item) {
        _userID = item.userID;
    }
}

@end

@implementation UserInfoData

+ (UserInfoData *)shareInstance {
    static dispatch_once_t onceToken;
    static UserInfoData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UserInfoData alloc] init];
    });
    
    return sSharedInstance;
}

- (void)initDatas {
#if LOCAL_VERSION
    _userInfo = [[UserInfoItem alloc] init];
    _userInfo.userID = @"000001";
    _userInfo.userName = @"张三";
    _userInfo.sex = 1;
    _userInfo.password = @"123456";
    _userInfo.phoneNo = @"13601234567";
    _userInfo.identityNo = @"0123456789012345678";
    _userInfo.email = @"zhangshan@test.com";
    _userInfo.bgColor = 0x9bbf4c;
    _userInfo.evaluationValue = 4;
    _userInfo.econtent = @"有点傻 有点黑";

    NSMutableArray *arrUsers = [[NSMutableArray alloc] init];
    UserInfoItem *item = [[UserInfoItem alloc] init];
    item.userID = @"000011";
    item.userName = @"李四";
    item.sex = 2;
    item.phoneNo = @"13701234567";
    item.bgColor = 0xd86a7a;
    item.evaluationValue = 5;
    item.econtent = @"漂亮 大方";
    [arrUsers addObject:item];

    item = [[UserInfoItem alloc] init];
    item.userID = @"000012";
    item.userName = @"王五";
    item.sex = 1;
    item.phoneNo = @"13801234568";
    item.bgColor = 0x9bbf4c;
    item.evaluationValue = 5;
    item.econtent = @"大男子主义 神人";
    [arrUsers addObject:item];

    item = [[UserInfoItem alloc] init];
    item.userID = @"000013";
    item.userName = @"阿兰";
    item.sex = 2;
    item.phoneNo = @"13991234567";
    item.bgColor = 0xc9b29c;
    item.evaluationValue = 3;
    item.econtent = @"有些不靠谱 不守信用";
    [arrUsers addObject:item];

    _arrUserInfo = arrUsers;
    
    arrUsers = [[NSMutableArray alloc] init];
    item = [[UserInfoItem alloc] init];
    item.userID = @"000021";
    item.userName = @"小白";
    item.sex = 1;
    item.phoneNo = @"13708888567";
    item.bgColor = 0x9bbf4c;
    item.evaluationValue = 4;
    item.econtent = @"很可爱 爱玩";
    [arrUsers addObject:item];
    
    item = [[UserInfoItem alloc] init];
    item.userID = @"000022";
    item.userName = @"小玉";
    item.sex = 2;
    item.phoneNo = @"13809999568";
    item.bgColor = 0xf58446;
    item.evaluationValue = 4;
    item.econtent = @"美女 思想前卫";
    [arrUsers addObject:item];
    
    _arrRequestUsers = arrUsers;
#endif
}

- (id)init {
    if (self = [super init]) {
        [self initDatas];
    }
    
    return self;
}

@end
//
//  test.h
//  TestProject
//
//  Created by wangfei on 14-6-12.
//  Copyright (c) 2014年 wangfei. All rights reserved.
//

#ifndef TestProject_test_h
#define TestProject_test_h
/*
1、getno.html页面中“筛选”点击事件，本地需要得到，在筛选完条件后，如何将值传递给本页面？
 a) 筛选点击事件设置locaiton为"protocol://nocondition"
 b) 得到值以后，调用setNoCondition(json);完成筛选条件设置
    json格式为:
    {
        "phoneNoFeature":"ABCD",    //号码特征
        "preStoreMoney":"0-200元",  //预存金额
        "contractTime":"6个月"      //合约时长
    }
 
2、nocondition.html页面，如何拿到筛选条件？
  a) 定义号码特征对应的id为"phoneNoFeature"
  b) 定义预存金额对应的id为"preStoreMoney"
  c) 定义合约时长对应的id为"contractTime"
 
3、nodetail.html页面中"用户信息"、“收货地址”点击事件，在填写完毕后，如何将值传递给本页面？
 a) 用户信息点击事件设置location为"protocol://customerinfo"
 b) 收货地址点击事件设置location为"protocol://receiverinfo"
 c) 得到用户信息后，调用setCustomerInfo(json);完成用户信息显示
    json格式为:
    {
        "userName":"张三",    //用户名
        "cardType":"身份证",   //证件类型
        "cardNo":"12345678901234567890",    //证件号码
        "cardAddress":"宇宙最大的那个恒星最高的那个山上",   // 证件地址
        “cardPicHasUpload”:"1"  //证件照片是否上传(0:未上传; 1:已上传)
    }
 d) 得到收货地址信息后，调用setReceiverInfo(json);完成收货地址信息显示
    json格式为:
    {
        "receiverName":"张三",                    //收货人姓名
        "receiverPhoneNo":"13600000000",         //收货人电话
        "area":"北京",                            //地区
        "detailAddress":"北京市朝阳区第十八条街最南边",//收货人地址
        "postCode":"100010",                     //邮编
        "diliverTime":"工作日(周一至周五)"          //配送时间
    }
4、customerinfo.html页面中如何拿到用户信息？
 a) 定义用户名对应的id为"userName"
 b) 定义证件类型的id为"cardType"
 c) 定义证件号码的id为"cardNo"
 d) 定义证件地址的id为"cardAddress"
 e) 定义证件正面的id为"cardFrontSide"
 f) 定义证件反面的id为"cardReverseSide"

5、customerinfo.html页面中检测"身份证正面"、“身份证反面”点击事件
 a) 身份证正面点击事件设置location为"protocol://cardFrontSide"
 b) 身份证反面点击事件设置location为"protocol://cardReverseSide"

6、customerinfo.html页面如何设置正反面照片(在上传照片后)
 a) 上传正面照片成功后，调用setFrontSide(frontSideNo);显示正面照
    frontSideNo: 上传照片，服务器返回的图片的id号
 b) 上传反面照片成功后，调用setReverseSide(reverseSideNo);显示反面照
    reverseSideNo: 上传照片，服务器返回的图片的id号

7、receiverinfo.html页面中如何拿到收货信息？
 a) 定义收货人姓名对应的id为"receiverName"
 b) 定义收货人电话对应的id为"receiverPhoneNo"
 c) 定义地区对应的id为"area"
 d) 定义收货人地址对应的id为"detailAddress"
 e) 定义邮编对应的id为"postCode"
 f) 定义配送时间对应的id为"diliverTime" ???(是否单独提供一个getDiliverTime();的json函数更靠谱一些)

8、protocol.html页面还没有入口？
 
9、getno.html页面点击一个号码后如何将数据传给nodetail.html
 a) 点击号码事件设置lcoation为"protocol://phoneNoDetail:号码;号码归属;号码信息;费用总计"
    如:"protocol://phoneNoDetail:17090020002;北京;200元(入网次月起6个月返还200元);200元"
 b) nodetail.html加载完成后，调用setPhoneNoInfo(json);设置号码相关信息
    json格式为:
    {
        "phoneNo":"17090020213",
        "area":"北京",
        "noInfo":"200元(入网次月起6个月返还200元)",
        "totalFee":"200元"
    }
*/
#endif

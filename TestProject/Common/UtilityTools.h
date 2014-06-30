//
//  UtilityTools.h
//  simpleWindowTest
//
//  Created by apple on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityTools : NSObject

//获取设备的uuid
+ (NSString *)getHandsetIMSI;

//获取距离2000.01.01 00:00:00的秒数
+ (int)getSecondsFromDate:(NSDate *)date;
//获取字符串时间(如:2000.01.01 00:00:00)距离当前时间的秒数
+ (int)getSecondsFromCurrentToDateString:(NSString *)dateString;
//根据时间间隔秒数得到日期(时间间隔从2000.01.01 00:00:00开始)
+ (NSDate *)getDateByInterval:(int)nInterval;
//根据date得到年月日时分秒字符串(yyyy-MM-dd hh:mm:ss)
+ (NSString *)getDateStringByDate:(NSDate *)date;
//根据字符串(2000.01.01 00:00:00)生成NSDate
+ (NSDate *)getDateFromString:(NSString *)dateString;
//根据字符串(2000-01-01 00:00:00)生成NSDate
+ (NSDate *)getDateFromStringEx:(NSString *)dateString;
//转换GMT时间到北京时间
+ (NSDate *)changeDateFromGMTToBJ:(NSDate *)gmtDate;
//获取当前时间的年月日时分秒字符串
+ (NSString *)getCurrentTimeString;
//根据简单时间字串(如:12:30)获取完整时间字串(2012.06.18 12:30:00)
+ (NSString *)getFullDateString:(NSString *)refreshTime;
//转换时间字串(如:20120618123000)为另一种格式(2012-06-18 12:30:00)
+ (NSString *)getFullDateStringEx:(NSString *)refreshTime;
//从完整时间字符串(2012.06.18 12:30:00)获取简单时间字串(如:12:30)
+ (NSString *)getSimpleTimeString:(NSString *)fullDateString;
//从完整时间字符串(20120618123000)获取简单时间字串(如:12:30)
+ (NSString *)getSmpleTimeStringEx:(NSString *)fullDateString;
//从时间字符串(20120618123000)转换成时间字符串(2012.06.18 12:30:00)
+ (NSString *)convertTimeString:(NSString *)dateString;
//删除指定文件
+ (void)deleteSpecifiedFile:(NSString *)filePath;

//对数据做内存解压
+ (NSData *)uncompressZippedData:(NSData *)compressedData;
//做内存压缩
+ (NSData *)compressData:(NSData *)pUncompressedData;

//解压指定文件到内存中
+ (NSData *)unCompressZippedData:(NSString *)compressedFile;
//解压指定文件到目标文件夹下
+ (void)uncompressZippedFile:(NSString *)zippedFile unzipFile:(NSString *)unzipFile;

//打印内存情况
+ (void)memory_report;
+(void)creatLatestNetworkDataFile:(NSString*)param NetworkData:(NSData*)networkData;

//校验字符是否有效(只允许英文大小写、数字)
+ (BOOL)checkInputWordValid:(unichar)word;
//基于base64的编解码接口
+(NSString*)encodeBase64:(NSString*)input;
+(NSData*)decodeBase64:(NSString*)input;

//得到MD5加密字符串
+(NSString *)md5:(NSString *)str;

//取系统当前时间的毫秒数
+ (uint64_t) getTickCount;

// 通用提示框(标题+内容+一个按钮)
+ (void)showGeneralAlertWithTitle:(NSString *)title message:(NSString *)message cancelButton:(NSString *)button delegate:(id)delegate tag:(int)tag;

// 创建输入框上方的取消确定按钮
+(UIToolbar *)produceKeyBoardToolbarWithTarget:(id)target tag:(int)tag cancelAction:(SEL)cancelAction doneAction:(SEL)doneAction;

@end

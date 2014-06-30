//
//  UtilityTools.m
//  simpleWindowTest
//
//  Created by apple on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UtilityTools.h"
#import <mach/mach.h>
#import <mach/mach_time.h>
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>
#import "ZipArchive/ZipArchive.h"
#import "GTMBase64.h"
#import <AdSupport/ASIdentifierManager.h>

@implementation UtilityTools

+ (NSString *)getHandsetIMSI {
    NSString *uuid = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;

    return uuid;
}

+ (int)getSecondsFromDate:(NSDate *)date {
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    //取2000.01.01 00:00:00距离1970的时间
    NSString *oldDateString = @"2000.01.01 00:00:00";
    NSDate *oldDate = [UtilityTools getDateFromString:oldDateString];
    NSTimeInterval oldInterVal = [oldDate timeIntervalSince1970];
    
    return (interval - oldInterVal);
}

+ (int)getSecondsFromCurrentToDateString:(NSString *)dateString {
    if(dateString == nil)
        return -1;
    
    NSDate *dateOld = [UtilityTools getDateFromString:dateString];
    NSDate *dateNow = [NSDate date];
    int interval = [dateNow timeIntervalSinceDate:dateOld] + 8 * 3600;
    
    return interval;
}

+ (NSDate *)getDateByInterval:(int)nInterval {
    NSString *oldDateString = @"2000.01.01 00:00:00";
    NSDate *oldDate = [UtilityTools getDateFromString:oldDateString];
    
    return [NSDate dateWithTimeInterval:(NSTimeInterval)nInterval sinceDate:oldDate];
}

+ (NSString *)getDateStringByDate:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];

    NSMutableString *dateString = [[NSMutableString alloc] init];
    
    [dateString appendFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:00",(long)[comps year],(long)[comps month],(long)[comps day],(long)[comps hour],(long)[comps minute]];//,[comps second]
    
    return dateString;
}

+ (NSDate *)getDateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc ] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];

    return date;
}

+ (NSDate *)getDateFromStringEx:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc ] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return date;    
}

+ (NSDate *)changeDateFromGMTToBJ:(NSDate *)gmtDate {
    NSTimeInterval interval = 8 * 3600;
    
    return [NSDate dateWithTimeInterval:interval sinceDate:gmtDate];
}

+ (NSString *)getCurrentTimeString {
    NSDate *date = [NSDate date];
    NSString *timeString = [UtilityTools getDateStringByDate:date];
    
    return timeString;
}

+ (NSString *)getFullDateString:(NSString *)refreshTime {
    if(refreshTime == nil || [refreshTime length] == 0)
        return nil;
    
    NSString *fullDateString;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    
    fullDateString = [NSString stringWithFormat:@"%04ld.%02ld.%02ld %@:00",(long)comps.year,(long)comps.month,(long)comps.day,refreshTime];
    
    return fullDateString;
}

+ (NSString *)getFullDateStringEx:(NSString *)refreshTime {
    if(refreshTime == nil || [refreshTime length] != 14)
        return nil;
    
    NSMutableString *fullDateString = [[NSMutableString alloc] init];;
    NSRange range;

    range.location = 0;range.length = 4;
    [fullDateString appendFormat:@"%@-",[refreshTime substringWithRange:range]];
    range.location = 4;range.length = 2;
    [fullDateString appendFormat:@"%@-",[refreshTime substringWithRange:range]];
    range.location = 6;range.length = 2;
    [fullDateString appendFormat:@"%@ ",[refreshTime substringWithRange:range]];
    
    range.location = 8;range.length = 2;
    [fullDateString appendFormat:@"%@:",[refreshTime substringWithRange:range]];
    range.location = 10;range.length = 2;
    [fullDateString appendFormat:@"%@:",[refreshTime substringWithRange:range]];
    range.location = 12;range.length = 2;
    [fullDateString appendFormat:@"%@",[refreshTime substringWithRange:range]];
    
    return fullDateString;
}

+ (NSString *)getSimpleTimeString:(NSString *)fullDateString {
    if(fullDateString == nil || [fullDateString length] <= 5)
        return nil;
    
    NSString *simpleTimeString = nil;
    NSRange range = [fullDateString rangeOfString:@" "];
    
    if(range.location == NSNotFound)
        return nil;
    
    range.location += 1;
    range.length = 5;
    
    simpleTimeString = [fullDateString substringWithRange:range];
    
    return  simpleTimeString;
}

+ (NSString *)getSmpleTimeStringEx:(NSString *)fullDateString {
    if(fullDateString == nil || [fullDateString length] != 14)
        return nil;
    
    NSMutableString *simpleTimeString = [[NSMutableString alloc] init];;
    NSRange range;
    
    range.location = 8;range.length = 2;
    [simpleTimeString appendFormat:@"%@",[fullDateString substringWithRange:range]];
    [simpleTimeString appendFormat:@":"];
    range.location = 10;range.length = 2;
    [simpleTimeString appendFormat:@"%@",[fullDateString substringWithRange:range]];
    
    return simpleTimeString;
}

+ (NSString *)convertTimeString:(NSString *)dateString {
    if(dateString == nil || [dateString length] != 14)
        return nil;
    
    NSMutableString *convertString = [[NSMutableString alloc] init];
    NSRange range;
    
    range.location = 0;range.length = 4;
    [convertString appendFormat:@"%@.",[dateString substringWithRange:range]];
    range.location = 4;range.length = 2;
    [convertString appendFormat:@"%@.",[dateString substringWithRange:range]];
    range.location = 6;range.length = 2;
    [convertString appendFormat:@"%@ ",[dateString substringWithRange:range]];
    
    range.location = 8;range.length = 2;
    [convertString appendFormat:@"%@:",[dateString substringWithRange:range]];
    range.location = 10;range.length = 2;
    [convertString appendFormat:@"%@:",[dateString substringWithRange:range]];
    range.location = 12;range.length = 2;
    [convertString appendFormat:@"%@",[dateString substringWithRange:range]];
    
    return convertString;
}

+ (void)deleteSpecifiedFile:(NSString *)filePath {
    NSFileManager *defaultManager;
    defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:filePath error:nil];
}

+ (NSData *)uncompressZippedData:(NSData *)compressedData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDate *date = [NSDate date];
    NSUInteger seconds = [date timeIntervalSince1970];
    
    NSString *srcFileName = [NSString stringWithFormat:@"%lu.zip",(unsigned long)seconds];
    NSString *document = ([paths count] > 0)?[paths objectAtIndex:0]:nil;
    NSMutableString *srcPath = [[NSMutableString alloc] init];
    [srcPath appendFormat:@"%@/%@",document,srcFileName];
    [compressedData writeToFile:srcPath atomically:YES];

    NSData *uncompressedData = [self unCompressZippedData:srcPath];
    [self deleteSpecifiedFile:srcPath];
    
    return uncompressedData;
}

+ (NSData *)compressData:(NSData *)pUncompressedData {
    return nil;
}

+ (NSData *)unCompressZippedData:(NSString *)compressedFile {
    NSData *data = nil;
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:compressedFile])
    {
        data = [zip UnzipFileToData];
        [zip UnzipCloseFile];
    }
    return data;
}

+ (void)uncompressZippedFile:(NSString *)zippedFile unzipFile:(NSString *)unzipFile {
    ZipArchive *zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:zippedFile])
    {
        [zip UnzipFileTo:unzipFile overWrite:YES];
        [zip UnzipCloseFile];
    }
}

+ (void)memory_report {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&info,&size);
    if(kerr == KERN_SUCCESS)
    {
        NSLog(@"Memory used: %u",(unsigned int)info.resident_size);
    }
    else
    {
        NSLog(@"Error: %s",mach_error_string(kerr));
    }
}

+ (NSString*)GetNetworkDataFilePath:(NSString*)param {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString* tmpFolderPath = [paths objectAtIndex:0];
    NSFileManager* fileManage = [NSFileManager defaultManager];
    NSString* Folder = [tmpFolderPath stringByAppendingPathComponent:@"NetWorkData"];
    if (![fileManage fileExistsAtPath:Folder]) {
        BOOL ok = [fileManage createDirectoryAtPath:Folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",Folder);
        if (ok == NO) {
            return nil;
        }
    }
    Folder = [Folder stringByAppendingPathComponent:param];
    if (![fileManage fileExistsAtPath:Folder]) {
        BOOL ok = [fileManage createDirectoryAtPath:Folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",Folder);
        if (ok == NO) {
            return  nil;
        }
    }
    return  Folder;
}

+ (NSString*)getLatestTimeID {
    NSCalendar* calendar=[NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:[NSDate date]];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger minute = [components minute];
    NSInteger hour = [components hour];
    NSInteger id = (hour*60 + minute)/5;
    NSString* TimeID=[NSString stringWithFormat:@"%02ld%02ld%03ld",(long)month,(long)day,(long)id];
    return TimeID;
}

+ (void)creatLatestNetworkDataFile:(NSString*)param NetworkData:(NSData *)networkData {
    if (networkData == nil || param == nil || [param length] == 0) {
        return;
    }
    NSString* Folder = [UtilityTools GetNetworkDataFilePath:param];
    if (Folder == nil || [Folder length] == 0) {
        return;
    }
    NSString* fileName = [NSString stringWithFormat:@"%llu.xml",[UtilityTools getTickCount]];
    NSString* tmpFile = [Folder stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFile ]) {
        return;
    }
    [networkData writeToFile:tmpFile atomically:YES];
}

+ (BOOL)checkInputWordValid:(unichar)word {
    //中文unicode编码范围(word >= 0x4e00 && word <= 0x9fbf)
    if((word >= '0' && word <= '9') || 
       (word >= 'A' && word <= 'Z') || 
       (word >= 'a' && word <= 'z') || 
       (word >= 0x4e00 && word <= 0x9fbf))
        return YES;
    
    return NO;
}

+ (NSString*)encodeBase64:(NSString *)input {
    NSData* data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString* base64String = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSData*)decodeBase64:(NSString *)input {
    NSData* data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    return data;
}

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    NSString *md5Str = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return md5Str;
}

+ (uint64_t) getTickCount {
    static mach_timebase_info_data_t sTimebaseInfo;
    uint64_t machTime = mach_absolute_time();
    
    if(sTimebaseInfo.denom == 0) {
        mach_timebase_info(&sTimebaseInfo);
    }
    
    uint64_t millis = ((machTime / 1000000) * sTimebaseInfo.numer)/ sTimebaseInfo.denom;
    
    return millis;
}

+ (void)showGeneralAlertWithTitle:(NSString *)title
                          message:(NSString *)message
                     cancelButton:(NSString *)button
                         delegate:(id)delegate
                              tag:(int)tag {
    UIAlertView* tips = [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:delegate
                                         cancelButtonTitle:(button == nil)?@"确定":button
                                         otherButtonTitles: nil];
    tips.tag = tag;
    [tips show];
}

+ (UIToolbar *)produceKeyBoardToolbarWithTarget:(id)target tag:(int)tag cancelAction:(SEL)cancelAction doneAction:(SEL)doneAction {
    
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    [toolBar sizeToFit];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:target action:cancelAction];
    cancelBtn.tag = tag;
    UIBarButtonItem *nilBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:target action:doneAction];
    doneBtn.tag = tag;
    
    
    if ([[UIToolbar class] instancesRespondToSelector:@selector(barTintColor)]) {
        [doneBtn setTintColor:[UIColor blackColor]];
    }else{
        [toolBar setBarStyle:UIBarStyleBlackTranslucent];
    }
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn,nilBtn,doneBtn, nil]];
    
    return toolBar;
    
}

@end

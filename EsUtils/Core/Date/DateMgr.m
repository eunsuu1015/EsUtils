//
//  DateMgr.m
//  EsUtils
//
//  Created by Authlabs on 2021/11/10.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "DateMgr.h"

@implementation DateMgr

/// 현재 날짜 조회
/// 날짜 형식 yyyy-MM-dd
+(NSString*)getDate {
    NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    NSLog(@"%s end. return : %@", __FUNCTION__, date);
    return date;
}

/// 현재 시간 조회
/// 시간 형식 HH:mm:ss
+(NSString*)getTime {
    NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:@"HH:mm:ss"];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    NSLog(@"%s end. return : %@", __FUNCTION__, date);
    return date;
}

/// 현재 날짜 및 시간 조회
/// 형식 yyyy-MM-dd HH:mm:ss
+(NSString*)getDateTime {
    NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    NSLog(@"%s end. return : %@", __FUNCTION__, date);
    return date;
}

/// 포맷 형식에 맞춰 현재 날짜 또는 날짜 및 시간 조회
/// @param format 포맷 (ex. yyyy-MM-dd HH:mm:ss)
+(NSString*)getDateTimeWithFormat:(nonnull NSString*)format {
    NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSString *date = @"";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:format];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
            date = nil;
        }
        NSLog(@"%s end. return : %@", __FUNCTION__, date);
        return date;
}

/// 날짜 비교
/// 날짜 형식 yyyy-MM-dd
/// @param standard 기준 날짜
/// @param target 비교 날짜
/// return 0 : 기준 날짜 = 비교 날짜        (standard = target)
/// return 양수 : 기준 날짜 < 비교 날짜    (standard 가 target 이전)
/// return 음수 : 기준 날짜 > 비교 날짜    (standard 가 target 이후)
+(NSInteger)compareFromStand:(nonnull NSDate *)standard toTarget:(nonnull NSDate *)target {
    NSLog(@"%s start", __FUNCTION__);
    NSInteger result = 0;
    @try {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate* standardDate = [df dateFromString:[df stringFromDate:standard]];
        NSDate* targetDate = [df dateFromString:[df stringFromDate:target]];
        NSInteger standardResult = (int)[standardDate timeIntervalSinceNow] / (60*60*24);
        NSInteger targetResult = (int)[targetDate timeIntervalSinceNow] / (60*60*24);
        
        // 리턴값이 0보다 크면 target이 standard 지남.
        result = standardResult - targetResult;
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        result = 0;
    }
    NSLog(@"%s end. result : %ld", __FUNCTION__, (long)result);
    return result;
}


/// 날짜 + 시간 비교
/// 형식 yyyy/MM/dd/HH:mm:ss
/// @param standard 기준 날짜
/// @param target 비교 날짜
/// return 0 : 기준 날짜 = 비교 날짜
/// return 1 : 기준 날짜 < 비교 날짜
/// return -1 : 기준 날짜 > 비교 날짜
/// return -1인 경우 유효기간 지났다 보면 됨
+(int)compareFromStandTime:(NSString *)standard toTarget:(NSString *)target {
    NSLog(@"%s start", __FUNCTION__);
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd/HH:mm:ss"];
        
        NSDate *date1= [formatter dateFromString:standard];
        NSDate *date2 = [formatter dateFromString:target];
        
        NSComparisonResult result = [date1 compare:date2];
        if(result == NSOrderedDescending)
        {
            NSLog(@"비교 날짜 지남");
            return -1;
        }
        else if(result == NSOrderedAscending)
        {
            NSLog(@"비교 날짜 안지남");
            return  1;
        }
        else
        {
            NSLog(@"비교 날짜와 동일");
            return 0;
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        
    }
    return 0;
}

/// time 기준으로 min 분 이후의 시간 계산
/// time 형식은 yyyy/MM/dd/HH:mm:ss
/// @param min 초
/// @param time 기준 시간
+(NSString*)afterStrDateToTime:(int)min time:(NSString*)time {
    @try {
//        int milsec = 3600 * 24 * 30; //30일  // 일 더하기
//        int milsec = 60 * min; //1분 * 분  // 분 더하기
        int milsec = min; //30일  // 분 더하기
        NSString *format = @"yyyy/MM/dd/HH:mm:ss";
        NSDate *realTime = [self stringToTimeFormat:time format:format];
        NSDate *afterTime = [realTime dateByAddingTimeInterval:milsec];
        
        // 시간 형식 지정
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSString *dateString = [formatter stringFromDate:afterTime];
        NSLog(@"result : %@", dateString);
        return dateString;
        
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
    return nil;
}

/// 날짜 텍스트를 NSDate 타입으로 변경
/// @param string yyyy-MM-dd 형식 텍스트
+(NSDate*)stringToDate:(nonnull NSString*)string {
    NSLog(@"%s start", __FUNCTION__);
    NSDate *date = nil;
    @try {
        NSDateFormatter *foramt = [[NSDateFormatter alloc] init];
        [foramt setDateFormat:@"yyyy-MM-dd"];
        date = [foramt dateFromString:string];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    NSLog(@"%s end.", __FUNCTION__);
    return date;
}

/// 날짜 텍스트를 NSDate 타입으로 변경
/// @param string yyyy-MM-dd 형식 텍스트
+(NSDate*)stringToTime:(NSString*)string {
    NSDateFormatter *foramt = [[NSDateFormatter alloc] init];
    [foramt setDateFormat:@"HH:mm:ss"];
    NSDate *date = [foramt dateFromString:string];
    return date;
}

/// 날짜 텍스트를 NSDate 타입으로 변경
/// @param string yyyy-MM-dd 형식 텍스트
+(NSDate*)stringToTimeFormat:(NSString*)string format:(NSString*)format {
    NSDateFormatter *foramt = [[NSDateFormatter alloc] init];
    [foramt setDateFormat:format];
    NSDate *date = [foramt dateFromString:string];
    return date;
}

@end

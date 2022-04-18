//
//  DateMgr.m
//  EsUtils
//
//  Created by Authlabs on 2021/11/10.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "DateMgr.h"

@implementation DateMgr

#pragma mark - 조회

/// 현재 날짜 조회
/// 날짜 형식 yyyy-MM-dd
+(NSString*)getDate {
    @try {
        return [DateMgr getDateTimeWithFormat:@"yyyy-MM-dd"];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// 현재 시간 조회
/// 시간 형식 HH:mm:ss
+(NSString*)getTime {
    @try {
        return [DateMgr getDateTimeWithFormat:@"HH:mm:ss"];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// 현재 날짜 및 시간 조회
/// 형식 yyyy-MM-dd HH:mm:ss
+(NSString*)getDateTime {
    @try {
        return [DateMgr getDateTimeWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// 포맷 형식에 맞춰 현재 날짜 또는 날짜 및 시간 조회
+(NSString*)getDateTimeWithFormat:(nonnull NSString*)format {
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:format];
        return [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


#pragma mark - 비교 & 계산

/// 날짜 비교 (날짜만 가능)
+(NSInteger)compareFromStand:(nonnull NSDate *)standard toTarget:(nonnull NSDate *)target format:(NSString*)format {
    NSInteger result = 0;
    @try {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:format];
        NSDate* standardDate = [df dateFromString:[df stringFromDate:standard]];
        NSDate* targetDate = [df dateFromString:[df stringFromDate:target]];
        NSInteger standardResult = (int)[standardDate timeIntervalSinceNow] / (60*60*24);
        NSInteger targetResult = (int)[targetDate timeIntervalSinceNow] / (60*60*24);
        // 리턴값이 0보다 크면 target이 standard 지남
        result = standardResult - targetResult;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = 0;
    }
    return result;
}

/// 날짜 + 시간 비교
+(int)compareFromStandTime:(NSString *)standard toTarget:(NSString *)target format:(NSString*)format {
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        
        NSDate *date1= [formatter dateFromString:standard];
        NSDate *date2 = [formatter dateFromString:target];
        
        NSComparisonResult result = [date1 compare:date2];
        if(result == NSOrderedDescending) {
            // 비교 날짜 지남
            return -1;
        } else if(result == NSOrderedAscending) {
            // 비교 날짜 안지남
            return  1;
        } else {
            // 비교 날짜와 동일
            return 0;
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
    return 0;
}

/// time 기준으로 min 분 이후의 시간 계산
+(NSString*)afterStrDateToTime:(int)min time:(NSString*)time {
    @try {
        //        int milsec = 3600 * 24 * 30; //30일  // 일 더하기
        //        int milsec = 60 * min; //1분 * 분  // 분 더하기
        int milsec = min; //30일  // 분 더하기
        NSString *format = @"yyyy/MM/dd/HH:mm:ss";
        NSDate *realTime = [self stringToDate:time format:format];
        NSDate *afterTime = [realTime dateByAddingTimeInterval:milsec];
        
        // 시간 형식 지정
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSString *dateString = [formatter stringFromDate:afterTime];
        return dateString;
        
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
    return nil;
}


#pragma mark - 변경

/// 날짜 텍스트를 NSDate 타입으로 변경
+(NSDate*)stringToDate:(nonnull NSString*)string format:(NSString*)dateFormat {
    @try {
        NSDateFormatter *foramt = [[NSDateFormatter alloc] init];
        [foramt setDateFormat:dateFormat];
        return [foramt dateFromString:string];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

@end

//
//  DateMgr.h
//  EsUtils
//
//  Created by ParkEunSu on 2021/11/10.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateMgr : NSObject

#pragma mark - 조회

/// 현재 날짜 조회
/// 날짜 형식 yyyy-MM-dd
+(NSString*)getDate;

/// 현재 시간 조회
/// 시간 형식 HH:mm:ss
+(NSString*)getTime;

/// 현재 날짜 및 시간 조회
/// 형식 yyyy-MM-dd HH:mm:ss
+(NSString*)getDateTime;

/// 포맷 형식에 맞춰 현재 날짜 또는 날짜 및 시간 조회
/// @param format 포맷 (ex. yyyy-MM-dd HH:mm:ss)
+(NSString*)getDateTimeWithFormat:(nonnull NSString*)format;


#pragma mark - 비교 & 계산

/// 날짜 비교 (날짜만 가능)
/// @param standard 기준 날짜
/// @param target 비교 날짜
/// @param format 날짜 포맷
/// return 0 : 기준 날짜 = 비교 날짜      (standard = target)
/// return 양수 : 기준 날짜 < 비교 날짜    (standard 가 target 이전)
/// return 음수 : 기준 날짜 > 비교 날짜    (standard 가 target 이후)
+(NSInteger)compareFromStand:(nonnull NSDate *)standard toTarget:(nonnull NSDate *)target format:(NSString*)format;

/// 날짜 + 시간 비교
/// @param standard 기준 날짜
/// @param target 비교 날짜
/// @param format 날짜 포맷
/// return 0 : 기준 날짜 = 비교 날짜
/// return 1 : 기준 날짜 < 비교 날짜
/// return -1 : 기준 날짜 > 비교 날짜
/// return -1인 경우 유효기간 지났다 보면 됨
+(int)compareFromStandTime:(NSString *)standard toTarget:(NSString *)target format:(NSString*)format;

/// time 기준으로 min 분 이후의 시간 계산
/// time 형식은 yyyy/MM/dd/HH:mm:ss
/// @param min 초
/// @param time 기준 시간
+(NSString*)afterStrDateToTime:(int)min time:(NSString*)time;


#pragma mark - 변경

/// 날짜 텍스트를 NSDate 타입으로 변경
/// @param string 변경할 날짜 텍스트
/// @param dateFormat 포맷
+(NSDate*)stringToDate:(nonnull NSString*)string format:(NSString*)dateFormat;

@end

NS_ASSUME_NONNULL_END

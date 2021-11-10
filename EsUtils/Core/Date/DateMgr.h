//
//  DateMgr.h
//  EsUtils
//
//  Created by Authlabs on 2021/11/10.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateMgr : NSObject

#pragma mark - Date

/// 현재 날짜 조회
+(NSString*)getDate;

/// 현재 시간 조회
+(NSString*)getTime;

/// 현재 날짜 및 시간 조회
+(NSString*)getDateTime;

/// 포맷 형식에 맞춰 현재 날짜 또는 날짜 및 시간 조회
+(NSString*)getDateTimeWithFormat:(nonnull NSString*)format;

/// 날짜 비교
+(NSInteger)compareFromStand:(nonnull NSDate *)standard toTarget:(nonnull NSDate *)target;

/// 날짜 텍스트를 NSDate 타입으로 변경
+(NSDate*)stringToDate:(nonnull NSString*)string;


@end

NS_ASSUME_NONNULL_END

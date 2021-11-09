//
//  Utils.m
//  MMA
//
//  Created by Authlabs on 17/09/2019.
//  Copyright © 2019 Authlabs. All rights reserved.
//

#import "Utils.h"
#import "Reachability.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

// 탈옥 체크
// http://bitxflow.synology.me/wordpress/?p=311
// https://github.com/x128/MemeCollector/blob/master/Meme%20Collector/NSObject%2BdebugCheck.h
#include <unistd.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <string.h>
#define SEC_IS_BEING_DEBUGGED_RETURN_VOID()    size_t size = sizeof(struct kinfo_proc); \
                                    struct kinfo_proc info; \
                                    int ret, name[4]; \
                                    memset(&info, 0, sizeof(struct kinfo_proc)); \
                                    name[0] = CTL_KERN; \
                                    name[1] = KERN_PROC; \
                                    name[2] = KERN_PROC_PID; \
                                    name[3] = getpid(); \
                                    if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) { \
                                        if (ret) return; \
                                    } \
                                    if (info.kp_proc.p_flag & P_TRACED) return

#define SEC_IS_BEING_DEBUGGED_RETURN_NIL()  size_t size = sizeof(struct kinfo_proc); \
                                            struct kinfo_proc info; \
                                            int ret, name[4]; \
                                            memset(&info, 0, sizeof(struct kinfo_proc)); \
                                            name[0] = CTL_KERN; \
                                            name[1] = KERN_PROC; \
                                            name[2] = KERN_PROC_PID; \
                                            name[3] = getpid(); \
                                            if ((ret = (sysctl(name, 4, &info, &size, NULL, 0)))) { \
                                            if (ret) return nil; \
                                            } \
                                            if (info.kp_proc.p_flag & P_TRACED) return nil

@implementation Utils


#pragma mark - LOG

/// 로그 출력 여부 설정
/// @param log 출력 여부 설정
+(void)setLog:(BOOL)log {
    if (IS_DEBUG_LOG) NSLog(@"%s start. log : %d", __FUNCTION__, log);
    IS_DEBUG_LOG = log;
}


#pragma mark - JailBreak

+(NSString*)checkCJailBreak {
    if (IS_DEBUG_LOG) NSLog(@"start");
    #ifdef DEBUG
            SEC_IS_BEING_DEBUGGED_RETURN_NIL();
    #endif
    
    return @"not";
}


#pragma mark - Storyboard

/// 스토리보드에서 네비게이션 컨트롤러 pushViewController 진행
/// @param openVC push할 뷰컨트롤러
/// @param naviVC push시킬 네비게이션컨트롤러 (일반적으로 self.navigationController)
/// @param animated 오픈 시 애니메이션 여부
+(void)storyboardPushVC:(nonnull NSString*)openVC naviVC:(nonnull UINavigationController*)naviVC animated:(BOOL)animated {
    if (IS_DEBUG_LOG) NSLog(@"%s start. openVC : %@ / animated : %d", __FUNCTION__, openVC, animated);
    @try {
        
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:openVC];
        [naviVC pushViewController:vc animated:animated];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}

/// 스토리보드에서 일반 뷰컨트롤러 presentViewController 진행
/// @param openVC present할 뷰컨트롤러
/// @param selfVC present시킬 현재 뷰컨트롤러 (일반적으로 self)
/// @param animated 오픈 시 애니메이션 여부
+(void)storyboardPresentVC:(nonnull NSString*)openVC selfVC:(nonnull UIViewController*)selfVC animated:(BOOL)animated {
    if (IS_DEBUG_LOG) NSLog(@"%s start. openVC : %@ / animated : %d", __FUNCTION__, openVC, animated);
    @try {
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:openVC];
        [selfVC presentViewController:vc animated:animated completion:nil];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


#pragma mark - Random

/// 랜덤 문자 생성 (영어 대문자, 영어 소문자, 숫자)
/// @param length 랜덤 문자 길이
+(NSString *)makeRandomNumAlpha:(int)length {
    if (IS_DEBUG_LOG) NSLog(@"%s start.  length : %d", __FUNCTION__, length);
    NSString * randomString = nil;
    @try {
        NSString *allowedChars = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";;
        int allowedCharsCount = allowedChars.length;
        
        for (int i = 0; i < length; i++) {
            int randomNum = arc4random_uniform(allowedCharsCount);
            unichar ch = [allowedChars characterAtIndex:randomNum];
            randomString = [NSString stringWithFormat:@"%@%c", randomString, ch];
        }
        
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        randomString = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, randomString);
    return randomString;
}

/// 랜덤수 생성
/// @param length 랜덤수 길이
+(NSString *)makeRandomNum:(int)length {
    if (IS_DEBUG_LOG) NSLog(@"%s start. length : %d", __FUNCTION__, length);
    NSString *randomNum = nil;
    @try {
        NSString *str1 = @"";
        for (int i = 0; i < length; i++) {
            int iRandom = arc4random() & 10;
            randomNum = [str1 stringByAppendingFormat:@"%@%d", randomNum, iRandom];
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        randomNum = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, randomNum);
    return randomNum;
}




#pragma mark - App Exit

/// 0.3초 후에 서스펜드 상태로 나감.
+(void)exitApp {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:0.3];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}

/// 0.3초 후에 서스펜드 상태로 나가면서, 직전에 네비게이션 컨트롤러 루트뷰컨트롤러로 이동함
/// @param naviVC 루트뷰컨트롤러로 이동하기 위한 네비게이션 컨트롤러
+(void)exitAppMoveVC:(nonnull UINavigationController*)naviVC {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        [naviVC popToRootViewControllerAnimated:NO];
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:0.3];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


#pragma mark - Version

/// 앱 버전 조회
+(NSString*)getAppVersion {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSString *ver = nil;
    @try {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        ver = infoDictionary[@"CFBundleShortVersionString"];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        ver = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, ver);
    return ver;
}

/// 앱스토어 버전 조회
+(NSString*)getAppStoreVersion {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSString *ver = nil;
    @try {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // 번들아이디로 조회 가능
        NSString* appID = infoDictionary[@"CFBundleIdentifier"];
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
        NSData* data = [NSData dataWithContentsOfURL:url];
        NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([lookup[@"resultCount"] integerValue] == 1) {
            ver = lookup[@"results"][0][@"version"];
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
            ver = nil;
        }
        if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, ver);
        return ver;
}

/// 앱 업데이트 필요 여부 체크
/// @param appVersion 앱 버전
/// @param appStoreVersion 앱스토어 버전
+(BOOL)isNeedUpdate:(nonnull NSString *)appVersion appStoreVersion:(nonnull NSString*)appStoreVersion {
    if (IS_DEBUG_LOG) NSLog(@"%s start. 앱 버전 : %@ / 앱스토어 버전 : %@", __FUNCTION__, appVersion, appStoreVersion);
    BOOL result = NO;
    @try {
        NSArray *versionArray = [appVersion componentsSeparatedByString:@"."];
        NSArray *appStoreArray = [appStoreVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appStoreArray.count; i++) {
            int appVer = [versionArray[i] intValue];
            int appStoreVer = [appStoreArray[i] intValue];
            
            if (appVer > appStoreVer) {
                if (IS_DEBUG_LOG) NSLog(@"app > appStore");
                result = NO;
                break;
            } else if (appVer < appStoreVer) {
                if (IS_DEBUG_LOG) NSLog(@"app < appStore");
                result = YES;
                break;
            }
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        result = NO;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, result);
    return result;
}


/// 앱 업데이트 필요 여부 체크 (메이저, 마이너 2개만 체크함)
/// @param appVersion 앱 버전
/// @param appStoreVersion 앱스토어 버전
/// return 0 : 버전 동일 또는 불필요(비교 실패)
/// return 1 : 선택 업데이트 필요 (Patch 버전)
/// return 2 : 필수 업데이트 필요 (Major, Minor 버전)
+(int)isNeedUpdateMajorMinor:(NSString *)appVersion appStoreVersion:(NSString*)appStoreVersion {
    if (IS_DEBUG_LOG) NSLog(@"start. 앱 버전 : %@ / 앱스토어 버전 : %@", appVersion, appStoreVersion);
    @try {
        if (appStoreVersion == nil) {
            if (IS_DEBUG_LOG) NSLog(@"앱스토어 버전 nil");
            return NO;
        }
        
        if (appVersion == nil) {
            if (IS_DEBUG_LOG) NSLog(@"앱버전 nil");
            return NO;
        }
        
        int result = 0;
        
        NSArray *versionArray = [appVersion componentsSeparatedByString:@"."];
        NSArray *appStoreArray = [appStoreVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appStoreArray.count; i++) {
            if (IS_DEBUG_LOG) NSLog(@"i : %d ", i);
            int appVer = [versionArray[i] intValue];
            int appStoreVer = [appStoreArray[i] intValue];
            
            if (IS_DEBUG_LOG) NSLog(@"appVer      : %d", appVer);
            if (IS_DEBUG_LOG) NSLog(@"appStoreVer : %d", appStoreVer);
            
            if (appVer > appStoreVer) {
                if (IS_DEBUG_LOG) NSLog(@"app > appStore");
                result = 0;
                break;
            } else if (appVer < appStoreVer) {
                if (IS_DEBUG_LOG) NSLog(@"app < appStore");
                if (i == 2) {   // 세번째. 패치 버전
                    result = 1;
                } else {
                    result = 2;
                }
                break;
            }
            
        }
        
        if (IS_DEBUG_LOG) NSLog(@"result : %d", result);
        return result;
        
    } @catch (NSException *e) {
        if (IS_DEBUG_LOG) NSLog(@"Exception. e : %@", e.description);
        return NO;
    }
}

/// 앱스토어로 이동. appId는 앱스토어에 업로드 후 appId 얻어서 사용 가능.
/// @param appId 앱아이디. 앱스토어 업로드 후 앱스토어 커넥트에서 조회 가능
+(void)goAppStore:(nonnull NSString*)appId {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://itunes.apple.com/app/​﻿", appId];
        if (IS_DEBUG_LOG) NSLog(@"%s url : %@", __FUNCTION__, url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


#pragma mark - App 정보

+(NSString*)getBundleId {
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 번들아이디로 조회 가능
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    return appID;
}


#pragma mark - Network

/// 네트워크가 연결되어있는지 여부
/// return YES : 연결 되어있음
/// return NO : 연결 안되어있음
+(BOOL) isConnectNetwork {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    BOOL state = NO;
    @try {
        NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        if (netStatus == NotReachable) {
            // 네트워크 미연결 상태
            state = NO;
        } else {
            // 네트워크 연결 상태
            state = YES;
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        state = NO;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, state);
    return state;
    
}

/// 현재 네트워크 상태 가져오기
/// return -1 : 네트워크 미연결
/// return 1 : LTE
/// return 2 : 와이파이
/// return 0 : 알 수 없음.
+(int) getNetworkStatus {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    int state = 0;
    @try {
        // 네트워크의 상태를 알아옵니다.
        NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        switch (netStatus) {
            case NotReachable:
                if (IS_DEBUG_LOG) NSLog(@"%s 인터넷 미연결 상태", __FUNCTION__);
                state = -1;
                break;
            
            case ReachableViaWWAN:
                if (IS_DEBUG_LOG) NSLog(@"%s 3G로 연결되어있음", __FUNCTION__);
                state = 1;
                break;
                
            case ReachableViaWiFi:
                if (IS_DEBUG_LOG) NSLog(@"%s 와이파이로 연결되어있음", __FUNCTION__);
                state = 2;
                break;
        }
        
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        state = 0;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %d", __FUNCTION__, state);
    return state;
}



#pragma mark - Date

/// 현재 날짜 조회
/// 날짜 형식 yyyy-MM-dd
+(NSString*)getDate {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, date);
    return date;
}

/// 현재 시간 조회
/// 시간 형식 HH:mm:ss
+(NSString*)getTime {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:@"HH:mm:ss"];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, date);
    return date;
}

/// 현재 날짜 및 시간 조회
/// 형식 yyyy-MM-dd HH:mm:ss
+(NSString*)getDateTime {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, date);
    return date;
}

/// 포맷 형식에 맞춰 현재 날짜 또는 날짜 및 시간 조회
/// @param format 포맷 (ex. yyyy-MM-dd HH:mm:ss)
+(NSString*)getDateTimeWithFormat:(nonnull NSString*)format {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSString *date = nil;
    @try {
        NSString *date = @"";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSDate *now = [NSDate date];
        [formatter setDateFormat:format];
        date = [formatter stringFromDate:now];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
            date = nil;
        }
        if (IS_DEBUG_LOG) NSLog(@"%s end. return : %@", __FUNCTION__, date);
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
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
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
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        result = 0;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end. result : %ld", __FUNCTION__, (long)result);
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
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd/HH:mm:ss"];
        
        NSDate *date1= [formatter dateFromString:standard];
        NSDate *date2 = [formatter dateFromString:target];
        
        NSComparisonResult result = [date1 compare:date2];
        if(result == NSOrderedDescending)
        {
            if (IS_DEBUG_LOG) NSLog(@"비교 날짜 지남");
            return -1;
        }
        else if(result == NSOrderedAscending)
        {
            if (IS_DEBUG_LOG) NSLog(@"비교 날짜 안지남");
            return  1;
        }
        else
        {
            if (IS_DEBUG_LOG) NSLog(@"비교 날짜와 동일");
            return 0;
        }
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        
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
        NSDate *realTime = [Utils stringToTimeFormat:time format:format];
        NSDate *afterTime = [realTime dateByAddingTimeInterval:milsec];
        
        // 시간 형식 지정
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSString *dateString = [formatter stringFromDate:afterTime];
        if (IS_DEBUG_LOG) NSLog(@"result : %@", dateString);
        return dateString;
        
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"exception : %@", exception.description);
    }
    return nil;
}

/// 날짜 텍스트를 NSDate 타입으로 변경
/// @param string yyyy-MM-dd 형식 텍스트
+(NSDate*)stringToDate:(nonnull NSString*)string {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    NSDate *date = nil;
    @try {
        NSDateFormatter *foramt = [[NSDateFormatter alloc] init];
        [foramt setDateFormat:@"yyyy-MM-dd"];
        date = [foramt dateFromString:string];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        date = nil;
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end.", __FUNCTION__);
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

#pragma mark - Etc

/// 설정 앱에서 해당 앱 화면으로 이동
/// 퍼미션 허용 등을 위해 설정화면으로 이동할 때 사용
+(void)openSetting {
    if (IS_DEBUG_LOG) NSLog(@"%s start", __FUNCTION__);
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } @catch (NSException *exception) {
        if (IS_DEBUG_LOG) NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    if (IS_DEBUG_LOG) NSLog(@"%s end", __FUNCTION__);
}


@end

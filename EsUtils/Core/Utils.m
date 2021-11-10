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
    NSLog(@"%s start. log : %d", __FUNCTION__, log);
    IS_DEBUG_LOG = log;
}


#pragma mark - JailBreak

+(NSString*)checkCJailBreak {
    NSLog(@"start");
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
    NSLog(@"%s start. openVC : %@ / animated : %d", __FUNCTION__, openVC, animated);
    @try {
        
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:openVC];
        [naviVC pushViewController:vc animated:animated];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    NSLog(@"%s end", __FUNCTION__);
}

/// 스토리보드에서 일반 뷰컨트롤러 presentViewController 진행
/// @param openVC present할 뷰컨트롤러
/// @param selfVC present시킬 현재 뷰컨트롤러 (일반적으로 self)
/// @param animated 오픈 시 애니메이션 여부
+(void)storyboardPresentVC:(nonnull NSString*)openVC selfVC:(nonnull UIViewController*)selfVC animated:(BOOL)animated {
    NSLog(@"%s start. openVC : %@ / animated : %d", __FUNCTION__, openVC, animated);
    @try {
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:openVC];
        [selfVC presentViewController:vc animated:animated completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    NSLog(@"%s end", __FUNCTION__);
}


#pragma mark - Random

/// 랜덤 문자 생성 (영어 대문자, 영어 소문자, 숫자)
/// @param length 랜덤 문자 길이
+(NSString *)makeRandomNumAlpha:(int)length {
    NSLog(@"%s start.  length : %d", __FUNCTION__, length);
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        randomString = nil;
    }
    NSLog(@"%s end. return : %@", __FUNCTION__, randomString);
    return randomString;
}

/// 랜덤수 생성
/// @param length 랜덤수 길이
+(NSString *)makeRandomNum:(int)length {
    NSLog(@"%s start. length : %d", __FUNCTION__, length);
    NSString *randomNum = nil;
    @try {
        NSString *str1 = @"";
        for (int i = 0; i < length; i++) {
            int iRandom = arc4random() & 10;
            randomNum = [str1 stringByAppendingFormat:@"%@%d", randomNum, iRandom];
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        randomNum = nil;
    }
    NSLog(@"%s end. return : %@", __FUNCTION__, randomNum);
    return randomNum;
}




#pragma mark - App Exit

/// 0.3초 후에 서스펜드 상태로 나감.
+(void)exitApp {
    NSLog(@"%s start", __FUNCTION__);
    @try {
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:0.3];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    NSLog(@"%s end", __FUNCTION__);
}

/// 0.3초 후에 서스펜드 상태로 나가면서, 직전에 네비게이션 컨트롤러 루트뷰컨트롤러로 이동함
/// @param naviVC 루트뷰컨트롤러로 이동하기 위한 네비게이션 컨트롤러
+(void)exitAppMoveVC:(nonnull UINavigationController*)naviVC {
    NSLog(@"%s start", __FUNCTION__);
    @try {
        [naviVC popToRootViewControllerAnimated:NO];
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:0.3];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    NSLog(@"%s end", __FUNCTION__);
}


#pragma mark - Version

/// 앱 버전 조회
+(NSString*)getAppVersion {
    NSLog(@"%s start", __FUNCTION__);
    NSString *ver = nil;
    @try {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        ver = infoDictionary[@"CFBundleShortVersionString"];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        ver = nil;
    }
    NSLog(@"%s end. return : %@", __FUNCTION__, ver);
    return ver;
}

/// 앱스토어 버전 조회
+(NSString*)getAppStoreVersion {
    NSLog(@"%s start", __FUNCTION__);
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
            ver = nil;
        }
        NSLog(@"%s end. return : %@", __FUNCTION__, ver);
        return ver;
}

/// 앱 업데이트 필요 여부 체크
/// @param appVersion 앱 버전
/// @param appStoreVersion 앱스토어 버전
+(BOOL)isNeedUpdate:(nonnull NSString *)appVersion appStoreVersion:(nonnull NSString*)appStoreVersion {
    NSLog(@"%s start. 앱 버전 : %@ / 앱스토어 버전 : %@", __FUNCTION__, appVersion, appStoreVersion);
    BOOL result = NO;
    @try {
        NSArray *versionArray = [appVersion componentsSeparatedByString:@"."];
        NSArray *appStoreArray = [appStoreVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appStoreArray.count; i++) {
            int appVer = [versionArray[i] intValue];
            int appStoreVer = [appStoreArray[i] intValue];
            
            if (appVer > appStoreVer) {
                NSLog(@"app > appStore");
                result = NO;
                break;
            } else if (appVer < appStoreVer) {
                NSLog(@"app < appStore");
                result = YES;
                break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        result = NO;
    }
    NSLog(@"%s end. return : %d", __FUNCTION__, result);
    return result;
}


/// 앱 업데이트 필요 여부 체크 (메이저, 마이너 2개만 체크함)
/// @param appVersion 앱 버전
/// @param appStoreVersion 앱스토어 버전
/// return 0 : 버전 동일 또는 불필요(비교 실패)
/// return 1 : 선택 업데이트 필요 (Patch 버전)
/// return 2 : 필수 업데이트 필요 (Major, Minor 버전)
+(int)isNeedUpdateMajorMinor:(NSString *)appVersion appStoreVersion:(NSString*)appStoreVersion {
    NSLog(@"start. 앱 버전 : %@ / 앱스토어 버전 : %@", appVersion, appStoreVersion);
    @try {
        if (appStoreVersion == nil) {
            NSLog(@"앱스토어 버전 nil");
            return NO;
        }
        
        if (appVersion == nil) {
            NSLog(@"앱버전 nil");
            return NO;
        }
        
        int result = 0;
        
        NSArray *versionArray = [appVersion componentsSeparatedByString:@"."];
        NSArray *appStoreArray = [appStoreVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appStoreArray.count; i++) {
            NSLog(@"i : %d ", i);
            int appVer = [versionArray[i] intValue];
            int appStoreVer = [appStoreArray[i] intValue];
            
            NSLog(@"appVer      : %d", appVer);
            NSLog(@"appStoreVer : %d", appStoreVer);
            
            if (appVer > appStoreVer) {
                NSLog(@"app > appStore");
                result = 0;
                break;
            } else if (appVer < appStoreVer) {
                NSLog(@"app < appStore");
                if (i == 2) {   // 세번째. 패치 버전
                    result = 1;
                } else {
                    result = 2;
                }
                break;
            }
            
        }
        
        NSLog(@"result : %d", result);
        return result;
        
    } @catch (NSException *e) {
        NSLog(@"Exception. e : %@", e.description);
        return NO;
    }
}

/// 앱스토어로 이동. appId는 앱스토어에 업로드 후 appId 얻어서 사용 가능.
/// @param appId 앱아이디. 앱스토어 업로드 후 앱스토어 커넥트에서 조회 가능
+(void)goAppStore:(nonnull NSString*)appId {
    NSLog(@"%s start", __FUNCTION__);
    @try {
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://itunes.apple.com/app/​﻿", appId];
        NSLog(@"%s url : %@", __FUNCTION__, url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    NSLog(@"%s end", __FUNCTION__);
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
    NSLog(@"%s start", __FUNCTION__);
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
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        state = NO;
    }
    NSLog(@"%s end. return : %d", __FUNCTION__, state);
    return state;
    
}

/// 현재 네트워크 상태 가져오기
/// return -1 : 네트워크 미연결
/// return 1 : LTE
/// return 2 : 와이파이
/// return 0 : 알 수 없음.
+(int) getNetworkStatus {
    NSLog(@"%s start", __FUNCTION__);
    int state = 0;
    @try {
        // 네트워크의 상태를 알아옵니다.
        NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
        switch (netStatus) {
            case NotReachable:
                NSLog(@"%s 인터넷 미연결 상태", __FUNCTION__);
                state = -1;
                break;
            
            case ReachableViaWWAN:
                NSLog(@"%s 3G로 연결되어있음", __FUNCTION__);
                state = 1;
                break;
                
            case ReachableViaWiFi:
                NSLog(@"%s 와이파이로 연결되어있음", __FUNCTION__);
                state = 2;
                break;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        state = 0;
    }
    NSLog(@"%s end. return : %d", __FUNCTION__, state);
    return state;
}




#pragma mark - Etc

/// 설정 앱에서 해당 앱 화면으로 이동
/// 퍼미션 허용 등을 위해 설정화면으로 이동할 때 사용
+(void)openSetting {
    NSLog(@"%s start", __FUNCTION__);
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
    }
    NSLog(@"%s end", __FUNCTION__);
}


@end

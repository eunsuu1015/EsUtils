//
//  Utils.m
//  MMA
//
//  Created by ParkEunSu on 17/09/2019.
//  Copyright © 2019 ParkEunSu. All rights reserved.
//

#import "Utils.h"

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
+(void)setLog:(BOOL)log {
    NSLog(@"start. log : %d", log);
    IS_DEBUG_LOG = log;
}


#pragma mark - JailBreak

+(NSString*)checkCJailBreak {
#ifdef DEBUG
    SEC_IS_BEING_DEBUGGED_RETURN_NIL();
#endif
    return @"not";
}


#pragma mark - Storyboard

/// 스토리보드에서 네비게이션 컨트롤러 pushViewController 진행
+(void)storyboardPushVC:(nonnull NSString*)openVC naviVC:(nonnull UINavigationController*)naviVC animated:(BOOL)animated {
    @try {
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:openVC];
        [naviVC pushViewController:vc animated:animated];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 스토리보드에서 일반 뷰컨트롤러 presentViewController 진행
+(void)storyboardPresentVC:(nonnull NSString*)openVC selfVC:(nonnull UIViewController*)selfVC animated:(BOOL)animated {
    @try {
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:openVC];
        [selfVC presentViewController:vc animated:animated completion:nil];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}


#pragma mark - Random

/// 랜덤 문자 생성 (영어 대문자, 영어 소문자, 숫자)
+(NSString *)makeRandomNumAlpha:(int)length {
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
        NSLog(@"exception : %@", exception.description);
        randomString = nil;
    }
    return randomString;
}

/// 랜덤수 생성
+(NSString *)makeRandomNum:(int)length {
    NSString *randomNum = nil;
    @try {
        NSString *str1 = @"";
        for (int i = 0; i < length; i++) {
            int iRandom = arc4random() & 10;
            randomNum = [str1 stringByAppendingFormat:@"%@%d", randomNum, iRandom];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        randomNum = nil;
    }
    return randomNum;
}


#pragma mark - App Exit

/// 0.3초 후에 서스펜드 상태로 나감.
+(void)exitApp {
    @try {
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:0.3];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

/// 0.3초 후에 서스펜드 상태로 나가면서, 직전에 네비게이션 컨트롤러 루트뷰컨트롤러로 이동함
/// @param naviVC 루트뷰컨트롤러로 이동하기 위한 네비게이션 컨트롤러
+(void)exitAppMoveVC:(nonnull UINavigationController*)naviVC {
    @try {
        [naviVC popToRootViewControllerAnimated:NO];
        UIApplication *app = [UIApplication sharedApplication];
        [app performSelector:@selector(suspend)];
        //wait 2 seconds while app is going background
        [NSThread sleepForTimeInterval:0.3];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}


#pragma mark - Version

/// 앱 업데이트 필요 여부 체크
+(BOOL)isNeedUpdate:(nonnull NSString *)appVersion appStoreVersion:(nonnull NSString*)appStoreVersion {
    BOOL result = NO;
    @try {
        NSArray *versionArray = [appVersion componentsSeparatedByString:@"."];
        NSArray *appStoreArray = [appStoreVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appStoreArray.count; i++) {
            int appVer = [versionArray[i] intValue];
            int appStoreVer = [appStoreArray[i] intValue];
            
            if (appVer > appStoreVer) {
                result = NO;
                break;
            } else if (appVer < appStoreVer) {
                result = YES;
                break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        result = NO;
    }
    return result;
}


/// 앱 업데이트 필요 여부 체크 (메이저, 마이너 2개만 체크함)
+(int)isNeedUpdateMajorMinor:(NSString *)appVersion appStoreVersion:(NSString*)appStoreVersion {
    @try {
        if (appStoreVersion == nil || appVersion == nil) {
            return NO;
        }
        
        int result = 0;
        NSArray *versionArray = [appVersion componentsSeparatedByString:@"."];
        NSArray *appStoreArray = [appStoreVersion componentsSeparatedByString:@"."];
        
        for (int i = 0; i < appStoreArray.count; i++) {
            int appVer = [versionArray[i] intValue];
            int appStoreVer = [appStoreArray[i] intValue];
            
            if (appVer > appStoreVer) {
                result = 0;
                break;
            } else if (appVer < appStoreVer) {
                if (i == 2) {
                    result = 1;
                } else {
                    result = 2;
                }
                break;
            }
        }
        return result;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return NO;
    }
}


#pragma mark - AppStore

/// 앱스토어로 이동. appId는 앱스토어에 업로드 후 appId 얻어서 사용 가능.
+(void)goAppStore:(nonnull NSString*)appId {
    @try {
        NSString *url = [NSString stringWithFormat:@"%@%@",@"http://itunes.apple.com/app/​﻿", appId];
        NSLog(@"url : %@", url);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

@end

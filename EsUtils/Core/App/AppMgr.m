//
//  AppMgr.m
//  EsUtils
//
//  Created by Authlabs on 2022/04/18.
//  Copyright © 2022 ParkEunSu. All rights reserved.
//

#import "AppMgr.h"

@implementation AppMgr

#pragma mark - Version

/// 앱 버전 조회
+(NSString*)getAppVersion {
    @try {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        return infoDictionary[@"CFBundleShortVersionString"];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// 앱스토어 버전 조회
+(NSString*)getAppStoreVersion {
    @try {
        NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString* bundleId = infoDictionary[@"CFBundleIdentifier"];
        return [AppMgr getAppStoreVersion:bundleId];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

/// bundleId로 앱스토어 버전 조회
+(NSString*)getAppStoreVersion:(NSString*)bundleId {
    NSString *ver = nil;
    @try {
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", bundleId]];
        NSData* data = [NSData dataWithContentsOfURL:url];
        NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([lookup[@"resultCount"] integerValue] == 1) {
            ver = lookup[@"results"][0][@"version"];
        }
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}

#pragma mark - App

/// bundleID 조회
+(NSString*)getBundleId {
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    return appID;
}

/// 설정 앱 - 해당 앱 화면으로 이동
/// 퍼미션 허용 등을 위해 설정화면으로 이동할 때 사용
+(void)openSetting {
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
    }
}

@end

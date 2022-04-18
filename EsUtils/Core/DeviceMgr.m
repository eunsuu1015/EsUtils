//
//  DeviceMgr.m
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import "DeviceMgr.h"

@implementation DeviceMgr

#pragma mark - Size

/// 디바이스 가로 사이즈 조회
+(CGFloat)getDeviceWidthSize {
    @try {
        return [[UIScreen mainScreen] bounds].size.width;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return 0;
    }
}

/// 디바이스 세로 사이즈 조회
+(CGFloat)getDeviceHeightSize {
    @try {
        return [[UIScreen mainScreen] bounds].size.height;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return 0;
    }
}

#pragma mark - 디바이스 정보

/// 디바이스 OS 버전 조회
+(NSString*) getOsVer {
    @try {
        return [UIDevice currentDevice].systemVersion;
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception.description);
        return nil;
    }
}


@end

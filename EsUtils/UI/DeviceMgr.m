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
    CGFloat width = 0;
    @try {
        width = [[UIScreen mainScreen] bounds].size.width;
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        width = 0;
    }
    return width;
}

/// 디바이스 세로 사이즈 조회
+(CGFloat)getDeviceHeightSize {
    CGFloat height = 0;
    @try {
        height = [[UIScreen mainScreen] bounds].size.height;
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        height = 0;
    }
    return height;
}

#pragma mark - 디바이스 정보

/// 디바이스 OS 버전 조회
+(NSString*) getOsVer {
    NSString *ver = nil;
    @try {
        ver = [UIDevice currentDevice].systemVersion;
    } @catch (NSException *exception) {
        NSLog(@"%s exception : %@", __FUNCTION__, exception.description);
        ver = nil;
    }
    return ver;
}


@end

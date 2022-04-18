//
//  DeviceMgr.h
//  EsUtils
//
//  Created by EunSu on 2021/11/07.
//  Copyright © 2021 ParkEunSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceMgr : NSObject

#pragma mark - Size

/// 디바이스 가로 사이즈 조회
+(CGFloat)getDeviceWidthSize;

/// 디바이스 세로 사이즈 조회
+(CGFloat)getDeviceHeightSize;


#pragma mark - 디바이스 정보

/// 디바이스 OS 버전 조회
+(NSString*) getOsVer;

@end

NS_ASSUME_NONNULL_END
